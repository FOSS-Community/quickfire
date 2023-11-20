import 'dart:io';
class CommandHandler {
  static Future<void> createFeatureFirstArchitecture(String projectName) async {
    int numOfFeatures;
    // move to the newly created project directory
    final Directory projectDirectory = Directory(projectName);
    if (!projectDirectory.existsSync()) {
      print('Error: Project directory does not exist.');
      return;
    }

    Directory.current = projectDirectory.path;
    // Ask about number of features from user
    print('Enter the number of features required in $projectName: ');
    final String numOfFeaturesString = stdin.readLineSync() ?? '';
    numOfFeatures = int.parse(numOfFeaturesString);
    List featuresArray = [];

    for (int i = 0; i < numOfFeatures;) {
      print('Enter the name of feature $i : ');
      String nameOfFeature = stdin.readLineSync() ?? '';
      featuresArray.add(nameOfFeature);
      i++;
    }

    print('All of your features are : ');
    print(featuresArray);

    // create 'features' folder inside 'projectName/lib'
    final Directory featuresFolder = Directory('lib/features');
    featuresFolder.createSync(recursive: true);

    // create a folder for each feature
    for (String feature in featuresArray) {
      final Directory featuresFolder = Directory('lib/features/$feature');
      featuresFolder.createSync();
      // Under each feature folder create subfolders for bloc,ui, widgets and repo
      final Directory blocFolder = Directory('lib/features/$feature/bloc');
      final Directory uiFolder = Directory('lib/features/$feature/ui');
      final Directory repoFolder = Directory('lib/features/$feature/repo');
      final Directory widgetsFolder =
          Directory('lib/features/$feature/widgets');
      blocFolder.createSync();
      uiFolder.createSync();
      repoFolder.createSync();
      widgetsFolder.createSync();
    }

    // Creating UI files
    for (String feature in featuresArray) {
      String featureName = feature[0].toUpperCase() + feature.substring(1);

      final Directory uiFolder = Directory('lib/features/$feature/ui');

      if (uiFolder.existsSync()) {
        final File screenFile =
            File('lib/features/$feature/ui/${feature}_screen.dart');

        if (!screenFile.existsSync()) {
          // create a new dart file
          screenFile.createSync();

          // write the basic content to the dart file.
          screenFile.writeAsStringSync('''
import 'package:flutter/material.dart';

class ${featureName}Screen extends StatelessWidget {
  const ${featureName}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('${featureName}Screen '),
      ),
    );
  }
}

''');
        }
      }
    }

    // create navigation bar.....

    // create shared folder
    final sharedFolder = Directory('lib/shared');
    sharedFolder.createSync();

    final File navbar = File('lib/shared/nav_bar.dart');
    if (!navbar.existsSync()) {
      navbar.createSync();
      navbar.writeAsStringSync('''
import 'package:flutter/material.dart';
''', mode: FileMode.append);

      for (var feature in featuresArray) {
        navbar.writeAsStringSync(
          "import 'package:$projectName/features/$feature/ui/${feature}_screen.dart';\n",
          mode: FileMode.append,
        );
      }
      navbar.writeAsStringSync('''
class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedTab = 0;

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  List _pages = [

''', mode: FileMode.append);
    }

    for (String feature in featuresArray) {
      // make the first letter of feature capital
      String cFeature = feature[0].toUpperCase() + feature.substring(1);
      navbar.writeAsStringSync(
        "${cFeature}Screen(),\n",
        mode: FileMode.append,
      );
    }
    navbar.writeAsStringSync(
      '];',
      mode: FileMode.append,
    );
    navbar.writeAsStringSync(
      '''
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) {
          _changeTab(index);
        },
        items: const [
''',
      mode: FileMode.append,
    );

    for (var feature in featuresArray) {
      navbar.writeAsStringSync(
        "BottomNavigationBarItem(icon: Icon(Icons.home), label: '$feature'),\n",
        mode: FileMode.append,
      );
    }
    navbar.writeAsStringSync('''
        ],
      ),
    );
  }
}
''', mode: FileMode.append);

    // Import bloc and flutter_bloc to pubspec.yaml
    // Directory.current = projectDirectory.path;
    final ProcessResult addPackagesResult = await Process.run(
      'dart',
      ['pub', 'add', 'bloc', 'flutter_bloc'],
    );
    if (addPackagesResult.exitCode != 0) {
      print(
          'Error adding packages. Check your internet connection and try again.');
      print(addPackagesResult.stderr);
      return;
    }
    print('added bloc dependency to project');

    // Go inside every feature bloc folder
    for (String feature in featuresArray) {
      String featureName = feature[0].toUpperCase() + feature.substring(1);
      final Directory blocFolder = Directory('lib/features/$feature/bloc');
      if (blocFolder.existsSync()) {
        final File blocFile =
            File('lib/features/$feature/bloc/${feature}_bloc.dart');
        final File eventFile =
            File('lib/features/$feature/bloc/${feature}_event.dart');
        final File stateFile =
            File('lib/features/$feature/bloc/${feature}_state.dart');

        // write bloc file
        if (!blocFile.existsSync()) {
          blocFile.createSync();
          blocFile.writeAsStringSync('''
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part '${feature}_event.dart';
part '${feature}_state.dart';

class ${featureName}Bloc extends Bloc<${featureName}Event, ${featureName}State> {
  ${featureName}Bloc() : super(${featureName}Initial()) {
    on<${featureName}Event>((event, emit) {
      // TODO: implement event handler
    });
  }
}

''');
        }

        // write event file
        if (!eventFile.existsSync()) {
          eventFile.createSync();
          eventFile.writeAsStringSync('''
part of '${feature}_bloc.dart';

@immutable
sealed class ${featureName}Event {}

''');
        }

        // write state file
        if (!stateFile.existsSync()) {
          stateFile.createSync();
          stateFile.writeAsStringSync('''
part of '${feature}_bloc.dart';

@immutable
sealed class ${featureName}State {}

final class ${featureName}Initial extends ${featureName}State {}


''');
        }
      }
    }
  }






  static Future<void> createConstants(String projectName) async {
    final constantsFolder = Directory('lib/constants');
    constantsFolder.createSync();

    final File dimensionsFile = File('lib/constants/dimensions.dart');
    if (!dimensionsFile.existsSync()) {
      dimensionsFile.createSync();
      dimensionsFile.writeAsStringSync('''
import 'package:flutter/widgets.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenheight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

''');
    }
  }
}
