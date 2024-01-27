import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/screens/create_diary_screen.dart';
import 'package:diary_app/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); // Scaffold Key for SnackBar
  final user = FirebaseAuth.instance.currentUser!; // to get the current user

  // Function to sign out the user
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(), // Navigate to SignIn Screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // Scaffold Key for SnackBar
      // appbar
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.book, color: Colors.white),
            SizedBox(width: 10),
            Text('Diaries', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.purple,
        // Logout button
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          // Stream to get all the diaries of the current user from Firestore in real-time
          stream: FirebaseFirestore.instance
              .collection('diaries')
              .where('uid', isEqualTo: user.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // if there is error in getting data from Firestore
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong try again later'),
              );
            }
            // if the connection is waiting
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // if there is no diary entry
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No diary entries yet'),
              );
            }

            // if there is no problem and the connection is active
            return ListView.builder(
              itemCount:
                  snapshot.data!.docs.length, // The number of items in the list
              itemBuilder: (context, index) {
                // Extracting data for each diary entry
                var doc = snapshot.data!.docs[index];
                return diaryContainer(
                  title: doc["title"],
                  body: doc["body"],
                  date: doc["date"],
                  id: doc.id, // Document ID
                  scaffoldKey: scaffoldKey, // Scaffold Key for SnackBar
                  uid: user.uid,
                );
              },
            );
          },
        ),
      ),
      // Floating Action Button to create a new diary entry
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateDiaryScreen(
                isUpdate: false,
              ),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.deepPurple),
      ),
    );
  }
}

// Diary Container Widget
class diaryContainer extends StatelessWidget {
  final String title;
  final String body;
  final String date;
  final String id;
  final String uid;
  final scaffoldKey;

  const diaryContainer({
    super.key,
    required this.id,
    required this.uid,
    required this.title,
    required this.body,
    required this.date,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple),
        borderRadius: BorderRadius.circular(10),
      ),
      child: MaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateDiaryScreen(
                docId: id,
                uid: uid,
                title: title,
                body: body,
                isUpdate: true,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // diary title
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // diary body
            Text(
              body,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            // diary date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                // delete icon button
                IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Diary'),
                          content: const Text(
                              'Are you sure you want to delete this diary?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteDiary(context);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

// Function to delete a diary entry from Firestore
  void deleteDiary(BuildContext context) {
    FirebaseFirestore.instance
        .collection('diaries')
        .doc(id)
        .delete()
        .then(
          (value) => {
            Navigator.pop(context),
            ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
              SnackBar(
                content: Text('Diary deleted successfully'),
              ),
            ),
          },
        )
        .onError(
          (error, stackTrace) => {
            Navigator.pop(context),
            ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
              SnackBar(
                content: Text('Error deleting diary'),
              ),
            )
          },
        );
  }
}
