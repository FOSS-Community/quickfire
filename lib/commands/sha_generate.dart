import 'package:args/command_runner.dart';
import 'package:quickfire/core/deploy_project/sha_handler.dart';
import 'package:quickfire/tools/choice_selctor.dart';
import 'package:quickfire/tools/cli_handler.dart';

class GenerateSHA extends Command {
  @override
  String get name => 'sha';

  @override
  String get description => 'Generate SHA Keys';

  @override
  Future<void> run() async {
    final cliHandler = CliHandler();

    cliHandler.printBoltCyanText('Generating debug SHA keys');
    print('\n');
    final osChoice = ['windows', 'linux', 'mac'];
    final osChoiceSelector = ChoiceSelector(osChoice);
    cliHandler.printBoltCyanText('Choose your operating system : ');
    osChoiceSelector.printOptions();
    osChoiceSelector.handleArrowKeys();
    int osChoiceIndex = osChoiceSelector.selectedIndexForOptions;
    // windows
    if (osChoiceIndex == 0) {
      await SHAHandler.generateWindowsSHA();
    }
    // linux
    else if (osChoiceIndex == 1) {
      await SHAHandler.generateLinuxSHA();
    }
    // mac
    else if (osChoiceIndex == 2) {
      await SHAHandler.generateMacSHA();
    }
  }
}
