import 'dart:io';

class OnBoarding {
  static Future<void> createOnBoardingWithAuth(String projectName) async {
    // Import shared pref and riverpod
    final ProcessResult addSharedPrefResult = await Process.run(
      'dart',
      ['pub', 'add', 'shared_preferences'],
    );

    final ProcessResult addRiverpodResult = await Process.run(
      'dart',
      ['pub', 'add', 'flutter_riverpod'],
    );

    if (addSharedPrefResult.exitCode != 0) {
      print(
          'Error adding packages. Check your internet connection and try again.');
      print(addSharedPrefResult.stderr);
      return;
    }
    if (addRiverpodResult.exitCode != 0) {
      print(
          'Error adding packages. Check your internet connection and try again.');
      print(addRiverpodResult.stderr);
      return;
    }

    print('added shared pref');

    // create an on-boarding inside features folder
    final Directory onBoardingFolder = Directory('lib/features/onBoarding');
    onBoardingFolder.createSync();

    // go under onBoardingfolder and create an UI folder
    final Directory onBoardingUIFolder =
        Directory('lib/features/onBoarding/ui');
    onBoardingUIFolder.createSync();

    // create on_boarding_screen.dart
    final File onBoardinScreenFile =
        File('lib/features/onBoarding/ui/on_boarding_screen.dart');
    if (!onBoardinScreenFile.existsSync()) {
      onBoardinScreenFile.createSync();
      onBoardinScreenFile.writeAsStringSync('''
import 'package:$projectName/features/auth/ui/auth_screen.dart';
import 'package:$projectName/features/onBoarding/ui/intro_page2.dart';
import 'package:$projectName/features/onBoarding/ui/intro_page3.dart';
import 'package:$projectName/features/onBoarding/ui/intro_page1.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  bool onLastPage = false;

  void _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasSeenOnboarding', true);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const AuthScreen())); // PageViewHome()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            controller: _controller,
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onLastPage)
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _completeOnboarding,
                      child: const SizedBox(
                        width: 216,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Done',
                            ),
                            Icon(
                              Icons.arrow_right,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


''');
    }

    // create intro page 1
    final File introPage1 = File('lib/features/onBoarding/ui/intro_page1.dart');
    if (!introPage1.existsSync()) {
      introPage1.createSync();
      introPage1.writeAsStringSync('''
import 'package:flutter/material.dart';
class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Intro Page 1'),
      ),
    );
  }
}
''');
    }

    // create intro page 2

    final File introPage2 = File('lib/features/onBoarding/ui/intro_page2.dart');
    if (!introPage2.existsSync()) {
      introPage2.createSync();
      introPage2.writeAsStringSync('''
import 'package:flutter/material.dart';
class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Intro Page 2'),
      ),
    );
  }
}
''');
    }

    // create intro page 3
    final File introPage3 = File('lib/features/onBoarding/ui/intro_page3.dart');
    if (!introPage3.existsSync()) {
      introPage3.createSync();
      introPage3.writeAsStringSync('''
import 'package:flutter/material.dart';
class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Intro Page 3'),
      ),
    );
  }
}
''');
    }
  }

  static Future<void> createOnBoardingWithoutAuth(String projectName) async {
    // Import shared pref and riverpod
    final ProcessResult addSharedPrefResult = await Process.run(
      'dart',
      ['pub', 'add', 'shared_preferences'],
    );

    final ProcessResult addRiverpodResult = await Process.run(
      'dart',
      ['pub', 'add', 'flutter_riverpod'],
    );

    if (addSharedPrefResult.exitCode != 0) {
      print(
          'Error adding packages. Check your internet connection and try again.');
      print(addSharedPrefResult.stderr);
      return;
    }
    if (addRiverpodResult.exitCode != 0) {
      print(
          'Error adding packages. Check your internet connection and try again.');
      print(addRiverpodResult.stderr);
      return;
    }

    print('added shared pref');

    // create an on-boarding inside features folder
    final Directory onBoardingFolder = Directory('lib/features/onBoarding');
    onBoardingFolder.createSync();

    // go under onBoardingfolder and create an UI folder
    final Directory onBoardingUIFolder =
        Directory('lib/features/onBoarding/ui');
    onBoardingUIFolder.createSync();

    // create on_boarding_screen.dart
    final File onBoardinScreenFile =
        File('lib/features/onBoarding/ui/on_boarding_screen.dart');
    if (!onBoardinScreenFile.existsSync()) {
      onBoardinScreenFile.createSync();
      onBoardinScreenFile.writeAsStringSync('''
import 'package:$projectName/features/auth/ui/auth_screen.dart';
import 'package:$projectName/features/onBoarding/ui/intro_page2.dart';
import 'package:$projectName/features/onBoarding/ui/intro_page3.dart';
import 'package:$projectName/features/onBoarding/ui/intro_page1.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  bool onLastPage = false;

  void _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasSeenOnboarding', true);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const HomeScreen())); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            controller: _controller,
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onLastPage)
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _completeOnboarding,
                      child: const SizedBox(
                        width: 216,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Done',
                            ),
                            Icon(
                              Icons.arrow_right,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


''');
    }

    // create intro page 1
    final File introPage1 = File('lib/features/onBoarding/ui/intro_page1.dart');
    if (!introPage1.existsSync()) {
      introPage1.createSync();
      introPage1.writeAsStringSync('''
import 'package:flutter/material.dart';
class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Intro Page 1'),
      ),
    );
  }
}
''');
    }

    // create intro page 2

    final File introPage2 = File('lib/features/onBoarding/ui/intro_page2.dart');
    if (!introPage2.existsSync()) {
      introPage2.createSync();
      introPage2.writeAsStringSync('''
import 'package:flutter/material.dart';
class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Intro Page 2'),
      ),
    );
  }
}
''');
    }

    // create intro page 3
    final File introPage3 = File('lib/features/onBoarding/ui/intro_page3.dart');
    if (!introPage3.existsSync()) {
      introPage3.createSync();
      introPage3.writeAsStringSync('''
import 'package:flutter/material.dart';
class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Intro Page 3'),
      ),
    );
  }
}
''');
    }
  }
}
