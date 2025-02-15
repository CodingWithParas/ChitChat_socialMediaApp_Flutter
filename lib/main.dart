import 'package:chit_chat/Theme/theme_provider.dart';
import 'package:chit_chat/services/auth/auth_gate.dart';
import 'package:chit_chat/services/database/database_provider.dart';
import 'package:chit_chat/services/notification/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:chit_chat/helper/shot_time_messages.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Register custom timeago locale
  timeago.setLocaleMessages('short', ShortTimeMessages());

  // setup notification background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // request notification permission
  final noti = NotificationService();
  await noti.requestPermission();
  noti.setupInteraction();

  // run app
  runApp(
      MultiProvider(
          providers: [
            // Theme Provider
            ChangeNotifierProvider(create: (context) => ThemeProvider()),

            // database provider
            ChangeNotifierProvider(create: (context) => DatabaseProvider())
          ],

        child: const MyApp(),
      )
  );
}

// NOTIFICATION BACKGROUND HANDLER
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}" );
  print("Message data: ${message.data}" );
  print("Message notification: ${message.notification?.title}" );
  print("Message notification: ${message.notification?.body}" );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate()
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

