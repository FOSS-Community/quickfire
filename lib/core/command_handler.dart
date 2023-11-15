import 'dart:io';
import 'dart:math';

class CommandHandler {
  static Future<void> createFeatureFirstArchitecture(String projectName) async {
    int numOfFeatures;
    // move to the newly created project directory
    final Directory projectDirectory = Directory(projectName);
    if (!projectDirectory.existsSync()) {
      print('Error: Project directory does not exist.');
      return;
    }

    Directory.current = projectDirectory.path;
    // Ask about number of features from user
    print('Enter the number of features required in $projectName: ');
    final String numOfFeaturesString = stdin.readLineSync() ?? '';
    numOfFeatures = int.parse(numOfFeaturesString);
    List featuresArray = [];

    for (int i = 0; i < numOfFeatures;) {
      print('Enter the name of feature $i : ');
      String nameOfFeature = stdin.readLineSync() ?? '';
      featuresArray.add(nameOfFeature);
      i++;
    }

    print('All of your features are : ');
    print(featuresArray);

    // create 'features' folder inside 'projectName/lib'
    final Directory featuresFolder = Directory('lib/features');
    featuresFolder.createSync(recursive: true);

    // create a folder for each feature
    for (String feature in featuresArray) {
      final Directory featuresFolder = Directory('lib/features/$feature');
      featuresFolder.createSync();
      // Under each feature folder create subfolders for bloc,ui, widgets and repo
      final Directory blocFolder = Directory('lib/features/$feature/bloc');
      final Directory uiFolder = Directory('lib/features/$feature/ui');
      final Directory repoFolder = Directory('lib/features/$feature/repo');
      final Directory widgetsFolder =
          Directory('lib/features/$feature/widgets');
      blocFolder.createSync();
      uiFolder.createSync();
      repoFolder.createSync();
      widgetsFolder.createSync();
    }

    // Creating UI files
    for (String feature in featuresArray) {
      String featureName = feature[0].toUpperCase() + feature.substring(1);

      final Directory uiFolder = Directory('lib/features/$feature/ui');

      if (uiFolder.existsSync()) {
        final File screenFile =
            File('lib/features/$feature/ui/${feature}_screen.dart');

        if (!screenFile.existsSync()) {
          // create a new dart file
          screenFile.createSync();

          // write the basic content to the dart file.
          screenFile.writeAsStringSync('''
import 'package:flutter/material.dart';

class ${featureName}Screen extends StatelessWidget {
  const ${featureName}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('${featureName}Screen '),
      ),
    );
  }
}

''');
        }
      }
    }

    // Import bloc and flutter_bloc to pubspec.yaml
    // Directory.current = projectDirectory.path;
    final ProcessResult addPackagesResult = await Process.run(
      'dart',
      ['pub', 'add', 'bloc', 'flutter_bloc'],
    );
    if (addPackagesResult.exitCode != 0) {
      print(
          'Error adding packages. Check your internet connection and try again.');
      print(addPackagesResult.stderr);
      return;
    }
    print('added bloc dependency to project');

    // Go inside every feature bloc folder
    for (String feature in featuresArray) {
      String featureName = feature[0].toUpperCase() + feature.substring(1);
      final Directory blocFolder = Directory('lib/features/$feature/bloc');
      if (blocFolder.existsSync()) {
        final File blocFile =
            File('lib/features/$feature/bloc/${feature}_bloc.dart');
        final File eventFile =
            File('lib/features/$feature/bloc/${feature}_event.dart');
        final File stateFile =
            File('lib/features/$feature/bloc/${feature}_state.dart');

        // write bloc file
        if (!blocFile.existsSync()) {
          blocFile.createSync();
          blocFile.writeAsStringSync('''
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part '${feature}_event.dart';
part '${feature}_state.dart';

class ${featureName}Bloc extends Bloc<${featureName}Event, ${featureName}State> {
  ${featureName}Bloc() : super(${featureName}Initial()) {
    on<${featureName}Event>((event, emit) {
      // TODO: implement event handler
    });
  }
}

''');
        }

        // write event file
        if (!eventFile.existsSync()) {
          eventFile.createSync();
          eventFile.writeAsStringSync('''
part of '${feature}_bloc.dart';

@immutable
sealed class ${featureName}Event {}

''');
        }

        // write state file
        if (!stateFile.existsSync()) {
          stateFile.createSync();
          stateFile.writeAsStringSync('''
part of '${feature}_bloc.dart';

@immutable
sealed class ${featureName}State {}

final class ${featureName}Initial extends ${featureName}State {}


''');
        }
      }
    }

    // Create on boarding screens
    String onBoardingChoice;
    do {
      stdout.write('Do you want an on-boarding feature? (Y/n) "');
      final String stateInput = stdin.readLineSync() ?? '';
      onBoardingChoice = stateInput;
    } while (onBoardingChoice != 'y' &&
        onBoardingChoice != 'n' &&
        onBoardingChoice != 'Y' &&
        onBoardingChoice != 'N');

    // Handle user choice
    switch (onBoardingChoice) {
      case 'y':
        print('Creating an on-boarding feature for $projectName ....');
        await createOnBoarding(projectName);

        break;
      case 'Y':
        print('Creating an on-boarding feature for $projectName ....');
        await createOnBoarding(projectName);

        break;
      case 'n':
        break;
      case 'N':
        break;
    }
  }

  static Future<void> createOnBoarding(String projectName) async {
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

  static Future<void> implementFirebase(String projectName) async {
    // Import firebase core and firebase auth
    final ProcessResult addFirebaseCore =
        await Process.run('dart', ['pub', 'add', 'firebase_core']);
    final ProcessResult addFirebaseAuth =
        await Process.run('dart', ['pub', 'add', 'firebase_auth']);
    final ProcessResult addGoogleSignIn =
        await Process.run('dart', ['pub', 'add', 'google_sign_in']);

    if (addFirebaseCore.exitCode != 0) {
      print(
          'Error adding packages. Check your internet connection and try again.');
      print(addFirebaseCore.stderr);
      return;
    }
    if (addFirebaseAuth.exitCode != 0) {
      print(
          'Error adding packages. Check your internet connection and try again.');
      print(addFirebaseAuth.stderr);
      return;
    }
    if (addGoogleSignIn.exitCode != 0) {
      print(
          'Error adding packages. Check your internet connection and try again.');
      print(addGoogleSignIn.stderr);
      return;
    }

    print('added firebase packages');

    // Create a login page

    // create lib/features/auth/ui
    final authFolder = Directory('lib/features/auth');
    authFolder.createSync();
    final authUiFolder = Directory('lib/features/auth/ui');
    authUiFolder.createSync();

    // Create login page inside lib/features/auth/ui/login_screen.dart
    final File loginScreen = File('lib/features/auth/ui/auth_screen.dart');
    if (!loginScreen.existsSync()) {
      loginScreen.createSync();
      loginScreen.writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:$projectName/features/auth/service/auth_service.dart';
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              AuthService().continueWithGoogle(context);
            },
            child: const Text('Continue with google!')),
      ),
    );
  }
}

''');
    }

    final authServiceFolder = Directory('lib/features/auth/service');
    authServiceFolder.createSync();

    // create auth service inside lib/features/auth/service/auth_service.dart
    final File authService =
        File('lib/features/auth/service/auth_service.dart');
    if (!authService.existsSync()) {
      authService.createSync();
      authService.writeAsStringSync('''
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:$projectName/features/home/ui/home_screen.dart';



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  continueWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in navigate to the home screen
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
      return user;
    } else {
      // handle signin errors
      return null;
    }
  }
}

''');
    }

    // change the content of main.dart
    final File mainFile = File('lib/main.dart');
    mainFile.writeAsStringSync('''
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:$projectName/firebase_options.dart';
import 'package:$projectName/features/home/ui/home_screen.dart';
import 'package:$projectName/features/auth/ui/login_screen.dart';
import 'package:$projectName/features/onBoarding/ui/on_boarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  runApp(ProviderScope(child: MyApp(hasSeenOnboarding: hasSeenOnboarding)));
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;
  const MyApp({required this.hasSeenOnboarding, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: !hasSeenOnboarding ? const OnBoardingScreen(): StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              return const LogInScreen();
            } else {
              return const HomeScreen();
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

''');

    print('Created Firebase Authentication');
  }

  static Future<void> implementAppwrite(String projectName) async {
    // Import appwrite sdk
    final ProcessResult addPackagesResult = await Process.run(
      'dart',
      ['pub', 'add', 'appwrite'],
    );
    final ProcessResult addProviderResult = await Process.run(
      'dart',
      ['pub', 'add', 'provider'],
    );

    if (addPackagesResult.exitCode != 0) {
      print(
          'Error adding appwrite packages. Check your internet connection and try again.');
      print(addPackagesResult.stderr);
      return;
    }
    print('added appwrite sdk to project');

    if (addProviderResult.exitCode != 0) {
      print(
          'Error adding provider  package. Check your internet connection and try again.');
      print(addProviderResult.stderr);
      return;
    }
    print('added appwrite sdk to project');

    // create auth folder
    final authFolder = Directory('lib/features/auth');
    authFolder.createSync();

    // create auth service folder
    final authServiceFolder = Directory('lib/features/auth/service');
    authServiceFolder.createSync();

    final File authStatusFile =
        File('lib/features/auth/service/auth_status.dart');

    if (!authStatusFile.existsSync()) {
      authStatusFile.createSync();
      authStatusFile.writeAsStringSync("""
// ignore_for_file: avoid_print

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
}

class AuthService extends ChangeNotifier {
  Client client = Client();
  late final Account account;

  late User _currentUser;

  AuthStatus _status = AuthStatus.uninitialized;

  // Getter methods
  User get currentUser => _currentUser;
  AuthStatus get status => _status;
  String? get username => _currentUser.name;
  String? get email => _currentUser.email;
  String? get userid => _currentUser.id; // add dollar symbol before 'id'.

  // Constructor
  AuthService() {
    init();
    loadUser();
  }

  // Initialize the Appwrite client
  init() {
    client
        .setEndpoint('replace_with_your_endpoint')
        .setProject('replace_with_project_name')
        .setSelfSigned();
    account = Account(client);
  }

  loadUser() async {
    try {
      final user = await account.get();
      _status = AuthStatus.authenticated;
      _currentUser = user;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  Future<User> createUser(
      {required String email, required String password, required String name}) async {
    notifyListeners();

    try {
      final user = await account.create(
          userId: ID.unique(),
          email: email,
          password: password,
          name: name);
      return user;
    } finally {
      notifyListeners();
    }
  }

  Future<Session> createEmailSession(
      {required String email, required String password}) async {
    notifyListeners();

    try {
      final session =
          await account.createEmailSession(email: email, password: password);
      _currentUser = await account.get();
      _status = AuthStatus.authenticated;
      return session;
    } finally {
      notifyListeners();
    }
  }

  signInWithProvider({required String provider}) async {
    try {
      final session = await account.createOAuth2Session(provider: provider);
      _currentUser = await account.get();
      _status = AuthStatus.authenticated;
      return session;
    } finally {
      notifyListeners();
    }
  }

  signOut() async {
    try {
      await account.deleteSession(sessionId: 'current');
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  Future<Preferences> getUserPreferences() async {
    return await account.getPrefs();
  }

  updatePreferences({required String bio}) async {
    return account.updatePrefs(prefs: {'bio': bio});
  }
}

""");
    }

    // change the content of androidmanifest.xml
    final File androidManifest =
        File('android/app/src/main/AndroidManifest.xml');
    androidManifest.writeAsStringSync('''
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="<YOUR-APP-NAME>"
        android:name="{applicationName}" <-- add dollar sign before {applicationName} -->
        android:icon="@mipmap/ic_launcher">
        <activity android:name="com.linusu.flutter_web_auth_2.CallbackActivity" android:exported="true">
      <intent-filter android:label="flutter_web_auth_2">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="appwrite-callback-<YOUR-APPWRITE-PROJECT-ID>" />
      </intent-filter>
      </activity>
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <!-- Specifies an Android theme to apply to this Activity as soon as
                 the Android process has started. This theme is visible to the user
                 while the Flutter UI initializes. After that, this theme continues
                 to determine the Window background behind the Flutter UI. -->
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <!-- Don't delete the meta-data below.
             This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>

''');

    // change the content of main.dart
    final File mainFile = File('lib/main.dart');
    mainFile.writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:$projectName/features/auth/service/auth_status.dart';
import 'package:$projectName/features/auth/ui/auth_screen.dart';
import 'package:$projectName/features/home/ui/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client();
  client = Client()
      .setEndpoint("<YOUR_PROJECT_ENDPOINT>")
      .setProject("<YOUR_PROJECT_ID>");
  Account account = Account(client);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenOnboarding =
      prefs.getBool('hasSeenOnboarding') ?? false;
  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: MyApp(account: account, hasSeenOnboarding: hasSeenOnboarding,),
  ));
}

class MyApp extends StatelessWidget {
  final Account account;
  final bool hasSeenOnboarding;
  const MyApp({
    required this.account,
    required this.hasSeenOnboarding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final value = context.watch<AuthService>().status;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: !hasSeenOnboarding
          ? const OnBoardingScreen()
          : value == AuthStatus.uninitialized
              ? const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                )
              : value == AuthStatus.authenticated
                  ? const HomeScreen()
                  : const AuthScreen(),
    );
  }
}

''');

    // create auth_screen.dart
    final authUiFolder = Directory('lib/features/auth/ui');
    if (!authUiFolder.existsSync()) {
      authUiFolder.createSync();
      final File authScreen = File('lib/features/auth/ui/auth_screen.dart');
      authScreen.createSync();
      authScreen.writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart' as models;
import 'package:$projectName/features/auth/ui/login_screen.dart';
import 'package:$projectName/features/auth/ui/register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  models.User? loggedInUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()));
              },
              child: const Text('Sign up'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Continue with phone number'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Continue with Google'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Continue with Facebook'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LogInScreen(),
                    ),
                  );
                },
                child: const Text('Login'))
          ],
        ),
      ),
    );
  }
}

''');
    }

    // Create login screen
    final File authLoginScreen = File('lib/features/auth/ui/login_screen.dart');
    authLoginScreen.createSync();
    authLoginScreen.writeAsStringSync('''
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:$projectName/features/auth/service/auth_status.dart'; // service/auth_status.dart
import 'package:provider/provider.dart'; 
import 'package:$projectName/features/home/ui/home_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool loading = false;

  // sign in func
  signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            backgroundColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        });

    try {
      final AuthService appwrite = context.read<AuthService>();
      await appwrite.createEmailSession(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } on AppwriteException catch (e) {
      Navigator.pop(context);
      showAlert(title: 'Login failed', text: e.message.toString());
    }
  }

  showAlert({required String title, required String text}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            decoration: const InputDecoration(label: Text('Enter your email')),
            controller: _emailController,
          ),
          TextField(
            decoration:
                const InputDecoration(label: Text('Enter your password')),
            controller: _passwordController,
          ),
          TextButton(onPressed: signIn, child: const Text('Login'))
        ],
      )),
    );
  }
}

''');

    // Create registration screen
    final File authRegisterScreen =
        File('lib/features/auth/ui/register_screen.dart');
    authRegisterScreen.createSync();
    authRegisterScreen.writeAsStringSync('''
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:provider/provider.dart';
import 'package:$projectName/features/home/ui/home_screen.dart';
import 'package:$projectName/features/auth/service/auth_status.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  createAccount() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            backgroundColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [CircularProgressIndicator()],
            ),
          );
        });
    try {
      final AuthService appwrite = context.read<AuthService>();
      await appwrite.createUser(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
      );
      Navigator.pop(context);
      const snackbar = SnackBar(content: Text('Account created!'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      Navigator.pushReplacement(
        context,
        (MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        )),
      );
    } on AppwriteException catch (e) {
      Navigator.pop(context);
      showAlert(title: 'Account creation failed', text: e.message.toString());
    }
  }

  showAlert({required String title, required String text}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(label: Text('Enter your name!')),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(label: Text('Enter your email!')),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(label: Text('Enter your password!')),
          ),
          TextButton(onPressed: createAccount, child: const Text('Create new account!'))
        ],
      )),
    );
  }
}

''');
  }
}
