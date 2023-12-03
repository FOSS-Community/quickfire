import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:quickfire/core/deploy_project/pubspec_handler.dart';
import 'package:quickfire/tools/cli_handler.dart';

class BuildProject extends Command {
  @override
  String get name => 'build';

  @override
  String get description => 'Build app bundle';

  // Handle method
  @override
  Future<void> run() async {
    final cliHanldler = CliHandler();
    cliHanldler.clearScreen();
    cliHanldler.printBoltCyanText('Updated Your App Version code');
    final currentVersion = PubspecHandler.getVersion();
    PubspecHandler.updatePubspecValue('1.0.0+${currentVersion + 1}');

    final ProcessResult buildAppBundle = await Process.run(
      'flutter',
      ['build', 'appbundle'],
    );
    if (buildAppBundle.exitCode != 0) {
      print(
          'Error building appbundle!');
      print(buildAppBundle.stderr);
      return;
    }
  }
}
