// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:quickfire/core/auth_handler.dart';
import 'package:quickfire/core/command_handler.dart';
import 'package:quickfire/core/main_handler.dart';
import 'package:quickfire/core/on_boarding_creation.dart';
import 'package:quickfire/core/stripe_handler.dart';

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
    String authOption = '';
    late bool stripeOption;
    late bool onBoardingOption;
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

    print('Creating a feature first architecture for $projectName ...');
    await CommandHandler.createFeatureFirstArchitecture(projectName);
    await CommandHandler.createConstants(projectName);

    // Ask for on boarding option
    // // Create on boarding screens
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
        onBoardingOption = true;

        break;
      case 'Y':
        onBoardingOption = true;

        break;
      case 'n':
        onBoardingOption = false;
        break;
      case 'N':
        onBoardingOption = false;
        break;
    }

    print('''

Choose F for Firebase

Choose A for Appwrite

Choose N for No Auth Service...

''');
    String authChoice;
    do {
      stdout.write('Chose your choice "');
      final String authInput = stdin.readLineSync() ?? '';
      authChoice = authInput;
    } while (authChoice != 'f' &&
        authChoice != 'a' &&
        authChoice != 'F' &&
        authChoice != 'A' &&
        authChoice != 'n' &&
        authChoice != 'N');

    // Handle user choice
    switch (authChoice) {
      case 'f':
        print(
            'Implementing Firebase Auth and Login screen for $projectName ....');
        await AuthHandler.implementFirebase(projectName);
        authOption = 'firebase';
        if (onBoardingOption) {
          await MainFileHandler.createFirebaseMainWithOnBoarding(projectName);
          await OnBoarding.createOnBoardingWithAuth(projectName);
        } else if (!onBoardingOption) {
          await MainFileHandler.createFirebaseMainWithoutOnBoarding(
              projectName);
        }

        break;
      case 'F':
        print(
            'Implementing Firebase Auth and Login screen for$projectName ....');
        await AuthHandler.implementFirebase(projectName);
        authOption = 'firebase';
        if (onBoardingOption) {
          await MainFileHandler.createFirebaseMainWithOnBoarding(projectName);
          await OnBoarding.createOnBoardingWithAuth(projectName);
        } else if (!onBoardingOption) {
          await MainFileHandler.createFirebaseMainWithoutOnBoarding(
              projectName);
        }

        break;
      case 'a':
        print(
            'Implementing Appwrite Auth and Login screen for$projectName ....');
        await AuthHandler.implementAppwrite(projectName);
        authOption = 'appwrite';
        if (onBoardingOption) {
          await MainFileHandler.createAppwriteMainWithOnBoarding(projectName);
          await OnBoarding.createOnBoardingWithAuth(projectName);
        } else if (!onBoardingOption) {
          await MainFileHandler.createAppwriteMainWithoutOnBoarding(
              projectName);
        }

        break;
      case 'A':
        print(
            'Implementing Appwrite Auth and Login screen for$projectName ....');
        await AuthHandler.implementAppwrite(projectName);
        authOption = 'appwrite';
        if (onBoardingOption) {
          await MainFileHandler.createAppwriteMainWithOnBoarding(projectName);
          await OnBoarding.createOnBoardingWithAuth(projectName);
        } else if (!onBoardingOption) {
          await MainFileHandler.createAppwriteMainWithoutOnBoarding(
              projectName);
        }

        break;
      case 'n':
        // Create On boarding Screen without Auth Screen
        OnBoarding.createOnBoardingWithoutAuth(projectName);
        authOption = 'no';

        break;
      case 'N':
        OnBoarding.createOnBoardingWithoutAuth(projectName);
        authOption = 'no';
        break;
    }

    // Ask for Stripe Payment Integration...
    String stripeChoice;
    do {
      stdout.write('Do you need Strpe Payment Gateway? (Y/n) "');
      final String stripeOption = stdin.readLineSync() ?? '';
      stripeChoice = stripeOption;
    } while (stripeChoice != 'y' &&
        stripeChoice != 'n' &&
        stripeChoice != 'Y' &&
        stripeChoice != 'N');

    // Handle user choice
    switch (stripeChoice) {
      case 'y':
        await StripeHandler.implementStripe(projectName);

        break;
      case 'Y':
        await StripeHandler.implementStripe(projectName);
        break;
      case 'n':
        break;
      case 'N':
        break;
    }
  }
}
