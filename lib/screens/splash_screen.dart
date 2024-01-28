import 'package:diary_app/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: FlutterSplashScreen.gif(
            backgroundColor: Colors.white,
            gifPath: 'assets/images/splashGif.gif',
            gifWidth: 269,
            gifHeight: 474,
            nextScreen: const Auth(),
            duration: const Duration(seconds: 4),
            onInit: () async {
              debugPrint("onInit");
            },
            onEnd: () async {
              debugPrint("onEnd 1");
            },
          ),
        ),
      ),
    );
  }
}
