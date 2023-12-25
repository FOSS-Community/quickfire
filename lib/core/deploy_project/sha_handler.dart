import 'dart:io';

class SHAHandler {
  static Future<void> generateWindowsSHA() async {
    String command =
        'keytool -list -v -keystore "\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android';

    // Start the process
    Process process = await Process.start(
      '/bin/sh',
      ['-c', command],
    );

    // Capture and display the output
    stdout.addStream(process.stdout);
    stderr.addStream(process.stderr);

    // Wait for the process to complete
    int exitCode = await process.exitCode;
    print('Command exited with code $exitCode');
  }

  static Future<void> generateLinuxSHA() async {
    String command =
        'keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android';

    // Start the process
    Process process = await Process.start(
      '/bin/sh',
      ['-c', command],
    );

    // Capture and display the output
    stdout.addStream(process.stdout);
    stderr.addStream(process.stderr);

    // Wait for the process to complete
    int exitCode = await process.exitCode;
    print('Command exited with code $exitCode');
  }

  static Future<void> generateMacSHA() async {
    String command =
        'keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android';

    // Start the process
    Process process = await Process.start(
      '/bin/sh',
      ['-c', command],
    );

    // Capture and display the output
    stdout.addStream(process.stdout);
    stderr.addStream(process.stderr);

    // Wait for the process to complete
    int exitCode = await process.exitCode;
    print('Command exited with code $exitCode');
  }
}
