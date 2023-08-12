import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hackathonxcodexuberance/Authentication/signup.dart';
import 'package:hackathonxcodexuberance/screens/dashboard.dart';
import 'package:hackathonxcodexuberance/screens/friends.dart';
import '../Authentication/login.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();
  print('User granted permission: ${settings.authorizationStatus}');

  // Configure how the app handles messages when it's in the foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received foreground message: ${message.notification?.body}');
  });

  // Configure how the app handles messages when it's in the background or terminated
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MaterialApp(
      initialRoute: FirebaseAuth.instance.currentUser != null ? '/' : '/login',
      routes: {
        '/': (context) => const Dashboard(),
        '/login': (context) => const Login(),
        '/signup': (context) => const SignUp(),
        '/friends': (context) => const Friends(),
      }));
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Received background message: ${message.notification?.body}');
}
