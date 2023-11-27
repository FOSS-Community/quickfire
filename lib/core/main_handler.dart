import 'dart:io';

class MainFileHandler {
  static Future<void> createNotificationSystemMainWithOnboarding(
      String projectName) async {
    final File mainFile = File('lib/main.dart');
    mainFile.writeAsStringSync('''
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:$projectName/firebase_options.dart';
import 'package:$projectName/features/auth/ui/auth_screen.dart';
import 'package:$projectName/features/onBoarding/ui/on_boarding_screen.dart';
import 'package:$projectName/shared/nav_bar.dart';
import 'package:$projectName/features/notification/services/notification_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission();
  final token = await FirebaseMessaging.instance.getToken();
  await NotificationService.initLocalNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: {message.data}'); // add dollar before {message.data}
    print(message.data['body']);

    NotificationService.showLocalNotification(message);


    if (message.notification != null) {
      print('Message also contained a notification: {message.notification}'); // add dollar before {message.notification}
    }
    
  });


  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  runApp(ProviderScope(child: MyApp(hasSeenOnboarding: hasSeenOnboarding)));
}

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
              return const AuthScreen();
            } else {
              return const NavigationScreen();
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
  }

  static Future<void> createNotficationSystemMainWithoutOnboarding(
      String projectName) async {
    final File mainFile = File('lib/main.dart');
    mainFile.writeAsStringSync('''
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:$projectName/firebase_options.dart';
import 'package:$projectName/features/auth/ui/auth_screen.dart';
import 'package:$projectName/shared/nav_bar.dart';
import 'package:$projectName/features/notification/services/notification_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  await FirebaseMessaging.instance.requestPermission();
  final token = await FirebaseMessaging.instance.getToken();
  await NotificationService.initLocalNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: {message.data}'); // add dollar before {message.data}
    print(message.data['body']);

    NotificationService.showLocalNotification(message);


    if (message.notification != null) {
      print('Message also contained a notification: {message.notification}'); // add dollar before {message.notification}
    }
    
  });
}

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              return const AuthScreen();
            } else {
              return const NavigationScreen();
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
  }

  static Future<void> createFirebaseMainWithoutOnBoarding(
      String projectName) async {
    // change the content of main.dart
    final File mainFile = File('lib/main.dart');
    mainFile.writeAsStringSync('''
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:$projectName/firebase_options.dart';
import 'package:$projectName/features/auth/ui/auth_screen.dart';
import 'package:$projectName/shared/nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              return const AuthScreen();
            } else {
              return const NavigationScreen();
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
  }

  static Future<void> createFirebaseMainWithOnBoarding(
      String projectName) async {
    // change the content of main.dart
    final File mainFile = File('lib/main.dart');
    mainFile.writeAsStringSync('''
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:$projectName/firebase_options.dart';
import 'package:$projectName/features/auth/ui/auth_screen.dart';
import 'package:$projectName/features/onBoarding/ui/on_boarding_screen.dart';
import 'package:$projectName/shared/nav_bar.dart';

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
              return const AuthScreen();
            } else {
              return const NavigationScreen();
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
  }

  static Future<void> createAppwriteMainWithoutOnBoarding(
      String projectName) async {
    final File mainFile = File('lib/main.dart');
    mainFile.writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:$projectName/features/auth/service/auth_status.dart';
import 'package:$projectName/features/auth/ui/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:$projectName/shared/nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client();
  client = Client()
      .setEndpoint("<YOUR_PROJECT_ENDPOINT>")
      .setProject("<YOUR_PROJECT_ID>");
  Account account = Account(client);

  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: MyApp(
      account: account,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final Account account;
  const MyApp({
    required this.account,
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
      home: value == AuthStatus.uninitialized
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
  }

  static Future<void> createAppwriteMainWithOnBoarding(
      String projectName) async {
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
  }

  static Future<void> createNoAuthMainFileWithOnBoarding(
      String projectName) async {
    final File mainFile = File('lib/main.dart');
    mainFile.writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:$projectName/features/onBoarding/ui/on_boarding_screen.dart';
import 'package:$projectName/shared/nav_bar.dart';

void main() async {
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
      home: !hasSeenOnboarding
          ? const OnBoardingScreen()
          : const NavigationScreen(),
    );
  }
}

''');
  }

  static Future<void> createNoAuthMainFileWithoutOnBoarding(
      String projectName) async {
    final File mainFile = File('lib/main.dart');
    mainFile.writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:$projectName/shared/nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const NavigationScreen(),
    );
  }
}

''');
  }
}
