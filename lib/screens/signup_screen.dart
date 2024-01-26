import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/screens/home_screen.dart';
import 'package:diary_app/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

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
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false; // Loading state variable

  final userNameController = TextEditingController();
  final userEmailController = TextEditingController();
  final userPasswordController = TextEditingController();

  // create a function to insert data into firebase
  Future insertData() async {
    setState(() => _isLoading = true); // Start loading
    final validForm = _formKey.currentState!.validate();

    if (!validForm) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: userEmailController.text.trim(),
            password: userPasswordController.text.trim(),
          )
          .then((value) => addUserDetails());
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.message!),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future addUserDetails() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return await users.add({
      'userName': userNameController.text,
      'userEmail': userEmailController.text,
      'userPassword': userPasswordController.text,
    }).then((value) {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    });
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
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
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      controller: userNameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 3) {
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
                      controller: userEmailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Checking if the entered email has the right format
                        if (!EmailValidator.validate(value)) {
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
                          // change border color
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      controller: userPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null; // Return null if the input is valid
                      },
                      obscureText: true,
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _isLoading ? null : insertData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.purple),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      // if loading is true show loader else show text
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3, // stroke of the loader
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white, // loader color
                                ),
                              ),
                            )
                          : const Text('Sign Up'),
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              ),
                            );
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
          ),
        ),
      ),
    );
  }
}
