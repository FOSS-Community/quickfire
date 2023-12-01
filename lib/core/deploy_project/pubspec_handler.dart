import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

class PubspecHandler {
  static void updatePubspecValue(String newValue) {
    // Construct the path to pubspec.yaml
    final pubspecPath = 'pubspec.yaml';

    // Read the contents of pubspec.yaml
    final pubspecFile = File(pubspecPath);
    final content = pubspecFile.readAsStringSync();

    // Parse the YAML content using YamlEditor
    final editor = YamlEditor(content);

    // Update the value associated with the key
    editor.update(['version'], newValue);

    // Write the updated content back to pubspec.yaml
    pubspecFile.writeAsStringSync(editor.toString());
  }

  static int getVersion() {
    // Construct the path to pubspec.yaml
    final pubspecPath = 'pubspec.yaml';

    // Read the contents of pubspec.yaml
    final pubspecFile = File(pubspecPath);
    final content = pubspecFile.readAsStringSync();

    // Parse the YAML content using the yaml package
    final pubspecYaml = loadYaml(content);

    // Retrieve the current value of 'version'
    final versionValue = pubspecYaml['version'];
    final String version = versionValue.toString();
    List<String> parts = version.split('+');
    String numberAfterPlus = parts[1];
    int number = int.tryParse(numberAfterPlus) ?? 0;

    return number;
  }
}
