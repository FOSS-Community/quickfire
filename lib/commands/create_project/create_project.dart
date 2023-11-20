import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:quickfire/core/command_handler.dart';

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
        await CommandHandler.createFeatureFirstArchitecture(projectName);
        await CommandHandler.createConstants(projectName);

        break;
      case 'Y':
        print('Creating a feature first architecture for $projectName ....');
        await CommandHandler.createFeatureFirstArchitecture(projectName);
        await CommandHandler.createConstants(projectName);

        break;
      case 'n':
        print('Creating a Layer first architecture for $projectName ....');
        break;
      case 'N':
        print('Creating a Layer first architecture for $projectName ....');
        break;
    }

    print(
        'Choose between Firebase or Appwrite authentication (f/a) or "n" for no authentication service.');
    String firebaseChoice;
    do {
      stdout.write('Chose your choice "');
      final String firebaseInput = stdin.readLineSync() ?? '';
      firebaseChoice = firebaseInput;
    } while (firebaseChoice != 'f' &&
        firebaseChoice != 'a' &&
        firebaseChoice != 'F' &&
        firebaseChoice != 'A' &&
        firebaseChoice != 'n' &&
        firebaseChoice != 'N');

    // Handle user choice
    switch (firebaseChoice) {
      case 'f':
        print(
            'Implementing Firebase Auth and Login screen for $projectName ....');
        await CommandHandler.implementFirebase(projectName);

        break;
      case 'F':
        print(
            'Implementing Firebase Auth and Login screen for$projectName ....');
        await CommandHandler.implementFirebase(projectName);

        break;
      case 'a':
        print(
            'Implementing Appwrite Auth and Login screen for$projectName ....');
        await CommandHandler.implementAppwrite(projectName);

        break;
      case 'A':
        print(
            'Implementing Appwrite Auth and Login screen for$projectName ....');
        await CommandHandler.implementAppwrite(projectName);

        break;
      case 'n':
        break;
      case 'N':
        break;
    }
  }
}
