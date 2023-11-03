import 'dart:io';

import 'package:args/command_runner.dart';

class CreateProject extends Command {
  // Command details
  @override
  String get name => 'create';

  @override
  String get description => 'Create a new Flutter project.';

  CreateProject() {
    argParser.addFlag('verbose',
        abbr: 'v', help: 'Prints this usage information.', negatable: false);
  }

  // Handle Method
  @override
  Future<void> run() async {
    print('Enter the name of the project:');
    final String projectName = stdin.readLineSync() ?? '';

    if (projectName.isEmpty) {
      print('Project name cannot be empty.');
      return;
    }

    final ProcessResult result = await Process.run(
      'flutter',
      ['create', projectName],
    );

    if (result.exitCode == 0) {
      print('Flutter project $projectName created successfully');
    } else {
      print(result.exitCode);
      print(
          'Error creating Flutter project. Check the Flutter installation and try again.');
      print(result.stderr);
    }

    // Ask for feature first approach?
    print('Do you want a feature first approach ? (Y/n)');

    // Get user choice for State management
    String stateChoice;
    do {
      stdout.write('Chose your choice "');
      final String stateInput = stdin.readLineSync() ?? '';
      stateChoice = stateInput;
    } while (stateChoice != 'y' &&
        stateChoice != 'n' &&
        stateChoice != 'Y' &&
        stateChoice != 'N');

    // Handle user choice
    switch (stateChoice) {
      case 'y':
        print('Creating a feature first architecture for $projectName ....');
        await createFeatureFirstArchitecture(projectName);
        break;
      case 'Y':
        print('Creating a feature first architecture for $projectName ....');
        await createFeatureFirstArchitecture(projectName);
        break;
      case 'n':
        print('Creating a Layer first architecture for $projectName ....');
        break;
      case 'N':
        print('Creating a Layer first architecture for $projectName ....');
        break;
    }
  }

  Future<void> createFeatureFirstArchitecture(String projectName) async {
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

    // Go inside every feature bloc folder ]
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
}
