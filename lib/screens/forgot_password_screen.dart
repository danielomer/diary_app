import 'package:diary_app/screens/signin_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // create a global key to identify the form and validate the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  Future resetPassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Reset link sent to your email'),
        actions: [
          TextButton(
            onPressed: () => {
              Navigator.pop(context),
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignInScreen();
                  },
                ),
              )
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Center(
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
                    "Enter your email to reset your password",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 25),

                  // form fields
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
                    controller: emailController,
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
                  ElevatedButton(
                    onPressed: () => resetPassword(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.purple),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    // if loading is true show loader else show text
                    child: const Text('Send Reset Link'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}