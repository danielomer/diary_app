import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // initialize variables to store user input data
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  // create a global key to identify the form and validate the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // create a function to get the user input data
  getUserName(name) {
    userName = name;
  }

  //  create a function to get the user input data
  getUserEmail(email) {
    userEmail = email;
  }

  //  create a function to get the user input data
  getUserPassword(password) {
    userPassword = password;
  }

  // create a function to insert data into firebase
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
      // add overflow to avoid pixel overflow
      resizeToAvoidBottomInset: false,

      // app bar
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      // body
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // welcome text
              const Text(
                "Welcome to Diary App",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 25),

              // form fields
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Username",
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType: TextInputType.name,
                onChanged: (String name) {
                  getUserName(name);
                },
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 3) {
                    return 'Username must be at least 3 characters';
                  }
                  return null; // Return null if the input is valid
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (String email) {
                  getUserEmail(email);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Checking if the entered email has the right format
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                      .hasMatch(value)) {
                    return 'Please enter a valid email Address';
                  }
                  return null; // Return null if the input is valid
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                onChanged: (String password) {
                  getUserPassword(password);
                },
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null; // Return null if the input is valid
                },
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(150, 50),
                  textStyle: const TextStyle(fontSize: 20),
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                  } else {
                    insertData();
                  }
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 25),

              // sign in text if user already has an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  const SizedBox(width: 5.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
