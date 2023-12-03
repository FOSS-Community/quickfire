import 'package:args/command_runner.dart';
import 'package:quickfire/core/deploy_project/gradle_handler.dart';
import 'package:quickfire/core/deploy_project/keystore_handler.dart';
import 'package:quickfire/tools/choice_selctor.dart';
import 'package:quickfire/tools/cli_handler.dart';

class PublishProject extends Command {
  @override
  String get name => 'publish';

  @override
  String get description => 'Make your app publish ready for playstore';

  @override
  Future<void> run() async {
    final cliHandler = CliHandler();
    cliHandler.clearScreen();
    cliHandler
        .printBoltCyanText('Making your app publish ready with quickfire :');

    print('\n');
    final osChoice = ['windows', 'linux', 'mac'];
    final osChoiceSelector = ChoiceSelector(osChoice);
    cliHandler.printBoltCyanText('Choose your operating system : ');
    osChoiceSelector.printOptions();
    osChoiceSelector.handleArrowKeys();
    int osChoiceIndex = osChoiceSelector.selectedIndexForOptions;
    // windows
    if (osChoiceIndex == 0) {
      KeystoreHandler.generateWndowsKeystore();
    }
    // linux
    else if (osChoiceIndex == 1) {
      KeystoreHandler.generateLinuxMacUploadKeystore();
    }
    // mac
    else if (osChoiceIndex == 2) {
      KeystoreHandler.generateLinuxMacUploadKeystore();
    }

    cliHandler.stopLoadingAnimation();

    await KeystoreHandler.generateKeyProperties();
    await GradleHandler.referenceKeyStoreInGradle();
    await GradleHandler.updateBuildGradle();
  }
}
