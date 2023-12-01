import 'package:args/command_runner.dart';
import 'package:quickfire/core/deploy_project/pubspec_handler.dart';
import 'package:quickfire/tools/cli_handler.dart';

class DeployProject extends Command {
  @override
  String get name => 'deploy';

  @override
  String get description => 'Deploy the app to Google Play Store';

  // Handle method
  @override
  Future<void> run() async {
    final cliHanldler = CliHandler();
    cliHanldler.clearScreen();
    cliHanldler.printWithLoadingAmimation(
        '\x1B[1;36mMake your app publish ready with quickfire \x1B[0m');
    final currentVersion = PubspecHandler.getVersion();
    PubspecHandler.updatePubspecValue('1.0.0+${currentVersion + 1}');
  }
}
