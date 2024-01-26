import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  getUserName(name) {
    userName = name;
  }

  getUserEmail(email) {
    userEmail = email;
  }

  getUserPassword(password) {
    userPassword = password;
  }

  insertData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("users").doc();
    Map<String, dynamic> studentData = {
      "userName": userName,
      "userEmail": userEmail,
      "userPassword": userPassword
    };
    documentReference.set(studentData).whenComplete(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
              keyboardType: TextInputType.name,
              onChanged: (String name) {
                getUserName(name);
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (String email) {
                getUserEmail(email);
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              keyboardType: TextInputType.visiblePassword,
              onChanged: (String password) {
                getUserPassword(password);
              },
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                insertData();
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
