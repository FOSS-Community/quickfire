// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:quickfire/tools/choice_selctor.dart';
import 'package:quickfire/tools/cli_handler.dart';
import 'package:quickfire/core/create_project/auth_handler.dart';
import 'package:quickfire/core/create_project/command_handler.dart';
import 'package:quickfire/core/create_project/main_handler.dart';
import 'package:quickfire/core/create_project/notification_handler.dart';
import 'package:quickfire/core/create_project/on_boarding_creation.dart';
import 'package:quickfire/core/create_project/stripe_handler.dart';

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
    // Create an instance of Cli handler
    final cliHandler = CliHandler();
    String authOption = '';
    late bool stripeOption;
    late bool onBoardingOption;
    cliHandler.printBoltCyanText('Enter your organization name: ');
    final String orgName = stdin.readLineSync() ?? '';
    cliHandler.printBoltCyanText('Enter the name of the project: ');
    final String projectName = stdin.readLineSync() ?? '';

    // Clears the screen
    cliHandler.clearScreen();

    // using bold cyan and red color...
    cliHandler.printWithLoadingAmimation(
        '\x1B[1;36mquickfire\x1B[0m is creating \x1B[32m$projectName\x1B[0m');

    if (projectName.isEmpty) {
      cliHandler.stopLoadingAnimation();
      cliHandler.clearScreen();
      cliHandler.printErrorText('Project name cannot be empty');
      return;
    }
    if (orgName.isEmpty) {
      cliHandler.stopLoadingAnimation();
      cliHandler.clearScreen();
      cliHandler.printErrorText('Org name cannot be empty');
      return;
    }

    final ProcessResult result = await Process.run(
      'flutter',
      ['create', '--org', 'com.$orgName', projectName],
    );

    if (result.exitCode == 0) {
      cliHandler.clearScreen();
      print(
          '\x1B[1;32mFlutter project \x1B[1;36m$projectName \x1B[1;32mcreated successfully\x1B[0m');
    } else {
      print(result.exitCode);
      cliHandler.printErrorText(
          'Error creating Flutter project. Check the Flutter installation and try again.');
      print(result.stderr);
    }

    await CommandHandler.createFeatureFirstArchitecture(projectName);
    await CommandHandler.createConstants(projectName);

    // On Boarding Feature
    final onBoardingChoices = ['Yes', 'No'];
    final onBoardingChoiceSelector = ChoiceSelector(onBoardingChoices);
    cliHandler.clearScreen();
    cliHandler.printBoltCyanText('Do you want an on-boarding feature?');
    onBoardingChoiceSelector.printOptions();
    onBoardingChoiceSelector.handleArrowKeys();
    int onBoardingIndex = onBoardingChoiceSelector.selectedIndexForOptions;
    if (onBoardingIndex == 0) {
      onBoardingOption = true;
    } else if (onBoardingIndex == 1) {
      onBoardingOption = false;
    }

    cliHandler.clearScreen();
    final authChoices = ['firebase', 'appwrite', 'noAuth'];
    final authChoiceSelector = ChoiceSelector(authChoices);
    cliHandler.clearScreen();
    cliHandler.printBoltCyanText('Choose your Backend as a Service (BaaS)');
    authChoiceSelector.printOptions();
    authChoiceSelector.handleArrowKeys();
    int authChoiceIndex = authChoiceSelector.selectedIndexForOptions;
    if (authChoiceIndex == 0) {
      cliHandler.printBoldGreenText(
          'Implementing Firebase Auth and Login screen for $projectName ');
      await AuthHandler.implementFirebase(projectName);
      authOption = 'firebase';
      if (onBoardingOption) {
        await MainFileHandler.createFirebaseMainWithOnBoarding(projectName);
        await OnBoarding.createOnBoardingWithAuth(projectName);
      } else if (!onBoardingOption) {
        await MainFileHandler.createFirebaseMainWithoutOnBoarding(projectName);
      }
    } else if (authChoiceIndex == 1) {
      cliHandler.printBoldGreenText(
          'Implementing Appwrite Auth and Login screen for $projectName ....');
      await AuthHandler.implementAppwrite(projectName);
      authOption = 'appwrite';
      if (onBoardingOption) {
        await MainFileHandler.createAppwriteMainWithOnBoarding(projectName);
        await OnBoarding.createOnBoardingWithAuth(projectName);
      } else if (!onBoardingOption) {
        await MainFileHandler.createAppwriteMainWithoutOnBoarding(projectName);
      }
    } else if (authChoiceIndex == 2) {
      if (onBoardingOption) {
        cliHandler.printBoldGreenText(
            'You have choosed no BaaS for your application...');
        await MainFileHandler.createNoAuthMainFileWithOnBoarding(projectName);
        await OnBoarding.createOnBoardingWithoutAuth(projectName);
      } else if (onBoardingOption) {
        cliHandler.printBoldGreenText(
            'You have choosed no BaaS for your application...');
        await MainFileHandler.createNoAuthMainFileWithoutOnBoarding(
            projectName);
      }
      authOption = 'no';
    }

    // Ask for FCM and local Notifications

    if (authOption == 'firebase') {
      cliHandler.clearScreen();
      final notificationOptions = ['Yes', 'No'];
      final notificationChoiceSelector = ChoiceSelector(notificationOptions);
      cliHandler.clearScreen();
      cliHandler.printBoltCyanText(
          'Do you want to implement Firebase Cloud Messaging with local notifications?');
      notificationChoiceSelector.printOptions();
      notificationChoiceSelector.handleArrowKeys();
      int notificationChoiceIndex =
          notificationChoiceSelector.selectedIndexForOptions;
      if (notificationChoiceIndex == 0) {
        await NotificationHandler.implementFirebaseNotification(projectName);
        if (onBoardingOption) {
          await MainFileHandler.createNotificationSystemMainWithOnboarding(
              projectName);
        } else if (onBoardingOption) {
          await MainFileHandler.createNotficationSystemMainWithoutOnboarding(
              projectName);
        }
      }
    }

    // Ask for Stripe Payment Integration...
    cliHandler.clearScreen();
    final stripeChoices = ['Yes', 'No'];
    final stripeChoiceSelector = ChoiceSelector(stripeChoices);
    cliHandler.clearScreen();
    cliHandler.printBoltCyanText('Do you want to integrate Stripe payment?');
    stripeChoiceSelector.printOptions();
    stripeChoiceSelector.handleArrowKeys();
    int stripeChoiceIndex = stripeChoiceSelector.selectedIndexForOptions;
    if (stripeChoiceIndex == 0) {
      cliHandler
          .printBoldGreenText('Integrating Stripe into your $projectName..');
      await StripeHandler.implementStripe(
        projectName: projectName,
        orgName: orgName,
      );
    }

    cliHandler.clearScreen();

    cliHandler.printBoldGreenText('$projectName created by Quickfire.');
    cliHandler.printBoltCyanText('\$cd $projectName');

    cliHandler.stopLoadingAnimation();
  }
}
