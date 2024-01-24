import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_operation/firebase/firebase_function.dart';
import 'package:firebase_operation/firebase/login.dart';
import 'package:flutter/material.dart';

class HomeFirebase extends StatelessWidget {
  const HomeFirebase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"), centerTitle: true, automaticallyImplyLeading: false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('HOME', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),
            ElevatedButton(
                onPressed: () {
                  FireBaseHelper().signOut().then((result) => Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => LoginFirebase())));
                },
                child: Text("Log out"))
          ],
        ),
      ),
    );
  }
}
