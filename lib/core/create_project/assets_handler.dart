import 'dart:io';
import 'package:http/http.dart' as http;

class AssetsHandler {
  static Future<void> handleAssets() async {
    stdout.write('func');
    // create assets folder
    final assetsDirectory = Directory('assets');
    assetsDirectory.createSync();

    // create img folder
    final imgDirectory = Directory('assets/img');
    imgDirectory.createSync();

    http.Response response =
        await http.get(Uri.parse('https://iili.io/JzWnaHB.png'));

    final File destinationFile = File('assets/img/logo.png');
    await destinationFile.writeAsBytes(response.bodyBytes);
  }

  static void replaceAssetsBlock() {
    try {
      String newAssetsBlock = '''
assets:
    - assets/img/
  ''';
      // Read the content of the pubspec.yaml file
      File file = File('pubspec.yaml');
      String content = file.readAsStringSync();

      // Replace the #assets block with the new assets block
      content = content.replaceAll(
          RegExp(r'#\s*assets:(.*?)(?=#|$)', multiLine: true, dotAll: true),
          newAssetsBlock);

      // Write the modified content back to the file
      file.writeAsStringSync(content);
    } catch (e) {
      print('Error: $e');
    }
  }
}
