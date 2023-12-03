import 'dart:convert';
import 'dart:io';

import 'package:quickfire/tools/cli_handler.dart';

class KeystoreHandler {
  static Future<void> generateWndowsKeystore() async {
    final cliHandler = CliHandler();
    cliHandler.printWithLoadingAmimation(
        '\x1B[1;36mCreating upload keystore \x1B[0m \n');
    cliHandler.printBoldGreenText('Enter the name for .jks file : ');
    final String jksName = stdin.readLineSync() ?? '';
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler
        .printBoldGreenText('Enter the alias name (usually it is "upload") : ');
    final String aliasName = stdin.readLineSync() ?? '';
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    // Construct the keytool command
    String command =
        '''keytool -genkey -v -keystore %userprofile%\${$jksName}-keystore.jks ^-storetype JKS -keyalg RSA -keysize 2048 -validity 10000 ^-alias $aliasName''';

    // Run the keytool command using Process.start
    Process process = await Process.start(
      '/bin/sh',
      ['-c', command],
    );

    // Hook up stdout and stderr to capture the output
    StringBuffer outputBuffer = StringBuffer();
    StringBuffer errorBuffer = StringBuffer();

    process.stdout.transform(utf8.decoder).listen((String data) {
      outputBuffer.write(data);
    });

    process.stderr.transform(utf8.decoder).listen((String data) {
      errorBuffer.write(data);
    });

    // Provide the required input to the child process
    cliHandler.printBoltCyanText('Enter your keystore password : ');
    final String keyPass = stdin.readLineSync() ?? '';
    process.stdin.writeln(keyPass);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler.printBoldGreenText('Re-enter your keystore password : ');
    final String confirmKeyPass = stdin.readLineSync() ?? '';
    process.stdin.writeln(confirmKeyPass);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler.printBoldGreenText('What is your first and last name ? : ');
    final String name = stdin.readLineSync() ?? '';
    process.stdin.writeln(name);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler.printBoldGreenText(
        'What is the name of your organizational unit ? : ');
    final String orgUnit = stdin.readLineSync() ?? '';
    process.stdin.writeln(orgUnit);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler.printBoldGreenText('What is the name of your organization ? : ');
    final String orgName = stdin.readLineSync() ?? '';
    process.stdin.writeln(orgName);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler
        .printBoldGreenText('What is the name of your city or locality ? : ');
    final String cityName = stdin.readLineSync() ?? '';
    process.stdin.writeln(cityName);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler
        .printBoldGreenText('What is the name of your state or province ? : ');
    final String stateName = stdin.readLineSync() ?? '';
    process.stdin.writeln(stateName);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler.printBoldGreenText(
        'What is the two-letter country code for this unit ? : ');
    final String countryCode = stdin.readLineSync() ?? '';
    process.stdin.writeln(countryCode);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    process.stdin.writeln('y');

    // Wait for the process to complete
    int exitCode = await process.exitCode;
    print('Command exited with code $exitCode');
    print('Output:\n$outputBuffer');
    print('Error:\n$errorBuffer');
  }

  static Future<void> generateLinuxMacUploadKeystore() async {
    final cliHandler = CliHandler();
    cliHandler.printWithLoadingAmimation(
        '\x1B[1;36mCreating upload keystore \x1B[0m \n');
    cliHandler.printBoldGreenText('Enter the name for .jks file : ');
    final String jksName = stdin.readLineSync() ?? '';
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler
        .printBoldGreenText('Enter the alias name (usually it is "upload") : ');
    final String aliasName = stdin.readLineSync() ?? '';
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    // Construct the keytool command
    String command =
        'keytool -genkey -v -keystore ~/$jksName-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias $aliasName';

    // Run the keytool command using Process.start
    Process process = await Process.start(
      '/bin/sh',
      ['-c', command],
    );

    // Hook up stdout and stderr to capture the output
    StringBuffer outputBuffer = StringBuffer();
    StringBuffer errorBuffer = StringBuffer();

    process.stdout.transform(utf8.decoder).listen((String data) {
      outputBuffer.write(data);
    });

    process.stderr.transform(utf8.decoder).listen((String data) {
      errorBuffer.write(data);
    });

    // Provide the required input to the child process
    cliHandler.printBoltCyanText('Enter your keystore password : ');
    final String keyPass = stdin.readLineSync() ?? '';
    process.stdin.writeln(keyPass);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler.printBoldGreenText('Re-enter your keystore password : ');
    final String confirmKeyPass = stdin.readLineSync() ?? '';
    process.stdin.writeln(confirmKeyPass);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler.printBoldGreenText('What is your first and last name ? : ');
    final String name = stdin.readLineSync() ?? '';
    process.stdin.writeln(name);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler.printBoldGreenText(
        'What is the name of your organizational unit ? : ');
    final String orgUnit = stdin.readLineSync() ?? '';
    process.stdin.writeln(orgUnit);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler.printBoldGreenText('What is the name of your organization ? : ');
    final String orgName = stdin.readLineSync() ?? '';
    process.stdin.writeln(orgName);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler
        .printBoldGreenText('What is the name of your city or locality ? : ');
    final String cityName = stdin.readLineSync() ?? '';
    process.stdin.writeln(cityName);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler
        .printBoldGreenText('What is the name of your state or province ? : ');
    final String stateName = stdin.readLineSync() ?? '';
    process.stdin.writeln(stateName);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    cliHandler.printBoldGreenText(
        'What is the two-letter country code for this unit ? : ');
    final String countryCode = stdin.readLineSync() ?? '';
    process.stdin.writeln(countryCode);
    cliHandler.eraseLastLine();
    cliHandler.eraseLastLine();

    process.stdin.writeln('y');

    // Wait for the process to complete
    int exitCode = await process.exitCode;
    print('Command exited with code $exitCode');
    print('Output:\n$outputBuffer');
    print('Error:\n$errorBuffer');
  }

  static Future<void> generateKeyProperties() async {
    final File keyPro = File('android/key.properties');
    keyPro.createSync();
    keyPro.writeAsStringSync('''
storePassword=<password-from-previous-step>
keyPassword=<password-from-previous-step>
keyAlias=<your-alias-name->
storeFile=<keystore-file-location>
''');
  }
}
