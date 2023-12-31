import 'package:args/command_runner.dart';
import 'package:quickfire/commands/create_project.dart';
import 'package:quickfire/commands/build_project.dart';
import 'package:quickfire/commands/publish_project.dart';
import 'package:quickfire/commands/sha_generate.dart';

Future<void> main(List<String> args) async {
  final CommandRunner<void> runner =
      CommandRunner<void>('quickfire', 'Flutter on steroids')
        ..addCommand(CreateProject())
        ..addCommand(BuildProject())
        ..addCommand(PublishProject())
        ..addCommand(GenerateSHA());

  try {
    await runner.run(args);
  } catch (e) {
    print('Error: $e');
  }
}
