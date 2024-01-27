import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/components/primaryButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateDiaryScreen extends StatefulWidget {
  @override
  _CreateDiaryScreenState createState() => _CreateDiaryScreenState();
}

class _CreateDiaryScreenState extends State<CreateDiaryScreen> {
  // to get the current user
  final user = FirebaseAuth.instance.currentUser!;

  final _formKey = GlobalKey<FormState>();

  // create a global key to identify the form and validate the form
  final title = TextEditingController();
  final body = TextEditingController();
  String bodyText = '';

// Loading state variable
  bool _isLoading = false;

// a function to insert data into firebase
  Future saveDiary() async {
    setState(() => _isLoading = true);
    CollectionReference diaries =
        FirebaseFirestore.instance.collection('diaries');

    return await diaries.add({
      'uid': user.uid,
      'email': user.email,
      'title': title.text,
      'body': body.text,
      'date': DateFormat('MMMM dd   hh:mm a').format(
        DateTime.now(),
      ),
    }).then((value) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        title: Text('Create Diary',
            style: TextStyle(color: Colors.white, fontSize: 19)),
        backgroundColor: Colors.purple,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // diary title
              TextFormField(
                controller: title,
                decoration: InputDecoration(
                  hintText: 'Diary Title',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20.0,
                  ),
                  border: InputBorder.none,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter diary title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              // diary date and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${DateFormat('MMMM dd   hh:mm a').format(DateTime.now())}',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  Text(
                    // this function removes all the white spaces in the body string and only counts the characters
                    '${bodyText.replaceAll(RegExp(r'\s+'), '').length} characters',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              // diary body
              Expanded(
                child: TextFormField(
                  controller: body,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    setState(() {
                      bodyText = value;
                    });
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Diary Body',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 20.0,
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter diary body';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              // save button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PrimaryButton(
                      text: "Save",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          saveDiary();
                        }
                      },
                      isLoading: _isLoading,
                      size: 100)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
