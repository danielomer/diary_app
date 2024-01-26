import 'package:cloud_firestore/cloud_firestore.dart';
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
  runApp(const SplashScreen());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Firebase Demo'),
        ),
        body: Column(
          children: <Widget>[
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    return Row(
                      children: [
                        Expanded(
                          child: Text(documentSnapshot["name"].toString()),
                        ),
                        Expanded(
                          child: Text(documentSnapshot["email"]),
                        ),
                        Expanded(
                          child: Text(documentSnapshot["password"]),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
