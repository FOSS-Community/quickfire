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

    // Create on boarding screens
    String onBoardingChoice;
    do {
      stdout.write('Do you want an on-boarding feature? (Y/n) "');
      final String stateInput = stdin.readLineSync() ?? '';
      onBoardingChoice = stateInput;
    } while (onBoardingChoice != 'y' &&
        onBoardingChoice != 'n' &&
        onBoardingChoice != 'Y' &&
        onBoardingChoice != 'N');

    // Handle user choice
    switch (onBoardingChoice) {
      case 'y':
        print('Creating an on-boarding feature for $projectName ....');
        await createOnBoarding(projectName);

        break;
      case 'Y':
        print('Creating an on-boarding feature for $projectName ....');
        await createOnBoarding(projectName);

        break;
      case 'n':
        break;
      case 'N':
        break;
    }
  }
  

  static Future<void> createOnBoarding(String projectName) async {
    // Import shared pref and riverpod
    final ProcessResult addSharedPrefResult = await Process.run(
      'dart',
      ['pub', 'add', 'bloc', 'shared_preferences'],
    );

    final ProcessResult addRiverpodResult = await Process.run(
      'dart',
      ['pub', 'add', 'bloc', 'flutter_riverpod'],
    );

    if (addSharedPrefResult.exitCode != 0) {
      print(
          'Error adding packages. Check your internet connection and try again.');
      print(addSharedPrefResult.stderr);
      return;
    }
    if (addRiverpodResult.exitCode != 0) {
      print(
          'Error adding packages. Check your internet connection and try again.');
      print(addRiverpodResult.stderr);
      return;
    }

    print('added shared pref');

    // create an on-boarding inside features folder
    final Directory onBoardingFolder = Directory('lib/features/onBoarding');
    onBoardingFolder.createSync();

    // go under onBoardingfolder and create an UI folder
    final Directory onBoardingUIFolder =
        Directory('lib/features/onBoarding/ui');
    onBoardingUIFolder.createSync();

    // create on_boarding_screen.dart
    final File onBoardinScreenFile =
        File('lib/features/onBoarding/ui/on_boarding_screen.dart');
    if (!onBoardinScreenFile.existsSync()) {
      onBoardinScreenFile.createSync();
      onBoardinScreenFile.writeAsStringSync('''
import 'package:awaaz/features/home/ui/home_screen.dart';
import 'package:awaaz/features/on_boarding/ui/intro_page2.dart';
import 'package:awaaz/features/on_boarding/ui/intro_page3.dart';
import 'package:awaaz/features/on_boarding/ui/intro_page1.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  bool onLastPage = false;

  void _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasSeenOnboarding', true);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const HomeScreen())); // PageViewHome()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            controller: _controller,
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onLastPage)
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _completeOnboarding,
                      child: const SizedBox(
                        width: 216,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Done',
                            ),
                            Icon(
                              Icons.arrow_right,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


''');
    }

    // create intro page 1
    final File introPage1 = File('lib/features/onBoarding/ui/intro_page1.dart');
    if (!introPage1.existsSync()) {
      introPage1.createSync();
      introPage1.writeAsStringSync('''
import 'package:flutter/material.dart';
class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Intro Page 1'),
      ),
    );
  }
}
''');
    }

    // create intro page 2

    final File introPage2 = File('lib/features/onBoarding/ui/intro_page2.dart');
    if (!introPage2.existsSync()) {
      introPage2.createSync();
      introPage2.writeAsStringSync('''
import 'package:flutter/material.dart';
class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Intro Page 2'),
      ),
    );
  }
}
''');
    }

    // create intro page 3
    final File introPage3 = File('lib/features/onBoarding/ui/intro_page3.dart');
    if (!introPage3.existsSync()) {
      introPage3.createSync();
      introPage3.writeAsStringSync('''
import 'package:flutter/material.dart';
class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Intro Page 3'),
      ),
    );
  }
}
''');
    }
  }
}
