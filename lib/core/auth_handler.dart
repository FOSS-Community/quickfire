import 'dart:io';

class AuthHandler {

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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:$projectName/features/onBoarding/ui/on_boarding_screen.dart';
import 'package:$projectName/shared/nav_bar.dart';

void main() async {
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
                  ? const NavigationScreen()
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
import 'package:$projectName/shared/nav_bar.dart';

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
          context, MaterialPageRoute(builder: (context) => const NavigationScreen()));
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
import 'package:$projectName/shared/nav_bar.dart';
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
          builder: (context) => const NavigationScreen(),
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
import 'package:$projectName/shared/nav_bar.dart';



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
            MaterialPageRoute(builder: (context) => const NavigationScreen()));
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

  }
}