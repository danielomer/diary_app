import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateDiaryScreen extends StatefulWidget {
  @override
  _CreateDiaryScreenState createState() => _CreateDiaryScreenState();
}

class _CreateDiaryScreenState extends State<CreateDiaryScreen> {
  String title = '';
  String body = '';

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
              '${DateTime.now().day.toString() + '/' + DateTime.now().month.toString() + '/' + DateTime.now().year.toString()}',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // diary title
            TextField(
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Diary Title',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                ),
                border: InputBorder.none,
              ),
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
                  '${body.replaceAll(RegExp(r'\s+'), '').length} characters',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            // diary body
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    body = value;
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
              ),
            ),
            SizedBox(height: 16.0),
            // save button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Save diary entry logic here
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
