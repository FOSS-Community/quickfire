import 'dart:io';

class GradleHandler {
  static Future<void> updateCompileSdkVersion() async {
    final File buildGradle = File('android/app/build.gradle');
    String content = buildGradle.readAsStringSync();

    String oldValue = 'compileSdkVersion flutter.compileSdkVersion';
    String newValue = 'compileSdkVersion 34';

    content = content.replaceAllMapped(
      RegExp(oldValue),
      (match) => newValue,
    );
    buildGradle.writeAsStringSync(content);
  }

  static Future<void> referenceKeyStoreInGradle() async {
    final File buildGradle = File('android/app/build.gradle');
    String keystorePropertiesSnippet = '''
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
  ''';

    try {
      String contents = await buildGradle.readAsString();

      // Find the position to insert the keystorePropertiesSnippet before 'android' block
      int androidBlockIndex = contents.indexOf('android {');
      if (androidBlockIndex != -1) {
        String updatedContents = contents.replaceRange(
            androidBlockIndex, androidBlockIndex, keystorePropertiesSnippet);

        // Write the updated contents back to the file
        await buildGradle.writeAsString(updatedContents);
        print('Build.gradle file updated successfully.');
      } else {
        print('Error: Could not find the "android {" block in build.gradle.');
      }
    } catch (e) {
      print('Error reading/writing build.gradle file: $e');
    }
  }

  static Future<void> updateBuildGradle() async {
    File buildGradleFile = File(
        'android/app/build.gradle'); // Update the path to your build.gradle file
    String keystorePropertiesSnippet = '''
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    
    
  ''';

    try {
      String contents = await buildGradleFile.readAsString();

      // Find the position to replace the existing 'release' block in buildTypes
      int releaseBlockStart = contents.indexOf('buildTypes {');
      int releaseBlockEnd = contents.indexOf('}', releaseBlockStart);

      if (releaseBlockStart != -1 && releaseBlockEnd != -1) {
        String existingReleaseBlock =
            contents.substring(releaseBlockStart, releaseBlockEnd + 1);
        String updatedContents = contents.replaceFirst(
            existingReleaseBlock, keystorePropertiesSnippet);

        // Write the updated contents back to the file
        await buildGradleFile.writeAsString(updatedContents);
        print('Build.gradle file updated successfully.');
      } else {
        print(
            'Error: Could not find the "buildTypes {" block in build.gradle.');
      }
    } catch (e) {
      print('Error reading/writing build.gradle file: $e');
    }
  }
}
