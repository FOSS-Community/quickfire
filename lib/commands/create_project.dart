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
    // final String parentDir = '../';
    // Directory.current = parentDir;


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
      print(
          'Error creating Flutter project. Check the Flutter installation and try again.');
      print(result.stderr);
    }
  }
}
