import 'package:diary_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      // ......Android Options Attributes......
      apiKey: 'AIzaSyC5kUMhrfu3vItqGBmmtSUINtunIMAvvF8',
      appId: '1:675696188857:android:f9344bf720bc9e7e8eaa68',
      messagingSenderId: '675696188857',
      projectId: 'diaryapp-30213',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SplashScreen(),
    );
  }
}
