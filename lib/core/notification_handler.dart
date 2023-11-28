import 'dart:io';

class NotificationHandler {
  static Future<void> implementFirebaseNotification(String projectName) async {
    // add firebase messaging and local notification packages
    final ProcessResult addFirebaseMessaging = await Process.run(
      'dart',
      ['pub', 'add', 'firebase_messaging'],
    );
    final ProcessResult addFlutterLocalNoti = await Process.run(
      'dart',
      ['pub', 'add', 'flutter_local_notifications'],
    );

    await Process.run(
      'dart',
      ['pub', 'add', 'http'],
    );

    if (addFirebaseMessaging.exitCode != 0) {
      print(
          'Error adding firebase_messaging packages. Check your internet connection and try again.');
      print(addFirebaseMessaging.stderr);
      return;
    }

    if (addFlutterLocalNoti.exitCode != 0) {
      print(
          'Error adding flutter_local_notifications  package. Check your internet connection and try again.');
      print(addFlutterLocalNoti.stderr);
      return;
    }

    print('added notification packages to project');

    // create notification feature
    final Directory notificationFeature =
        Directory('lib/features/notification');
    notificationFeature.createSync();
    final Directory notificationServiceFolder =
        Directory('lib/features/notification/services');
    notificationServiceFolder.createSync();
    final File notificationService =
        File('lib/features/notification/services/notification_services.dart');
    if (!notificationService.existsSync()) {
      notificationService.createSync();
      notificationService.writeAsStringSync('''
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:$projectName/main.dart';
import 'package:http/http.dart' as http;

class NotificationService {

  // Api function to send push messages via the app itself
  static sendPushMessage(
      {required String token,
      required String body,
      required String title}) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'key=<FIREBASE_CLOUD_MESSAGING_KEY>'
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "<CHANNEL_NAME>"
            },
            "to": token
          }));
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '<channel_name>', // Change this to a unique channel ID
      'Your Channel Name', // no need to change this
      channelDescription: '',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      message.data['title'],
      message.data['body'],
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}

''');
    }

    // change androidmanifest.xml
    final File manifestFile = File('android/app/src/main/AndroidManifest.xml');
    manifestFile.writeAsStringSync('''
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
<uses-permission android:name="android.permission.INTERNET"/>
    <application
        android:label="$projectName"
        android:name="{applicationName}" <-- add a dollar symbol before {applicationName} -->
        android:icon="@mipmap/ic_launcher">
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
                         <meta-data
              android:name="com.google.firebase.messaging.default_notification_channel_id"
              android:value="<channel_name>"  <-- create a uniques channel name-->
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
            <intent-filter>
                <action android:name="FLUTTER_NOTIFICATION_CLICK"/>
                <category android:name="android.intent.category.DEFAULT"/>
            </intent-filter>
            <intent-filter>
                <action android:name="com.google.firebase.MESSAGING_EVENT"/>
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

  }
}
