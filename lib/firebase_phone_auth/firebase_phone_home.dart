import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_operation/firebase_phone_auth/firebase_phone.dart';
import 'package:flutter/material.dart';

class FirebasePhoneHome extends StatefulWidget {
  const FirebasePhoneHome({super.key});

  @override
  State<FirebasePhoneHome> createState() => _FirebasePhoneHomeState();
}

class _FirebasePhoneHomeState extends State<FirebasePhoneHome> {
  String? uid;

  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Phone Home"), actions: [
        IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => FirebasePhoneAuth()), (route) => false);
            },
            icon: Icon(Icons.logout))
      ]),
      body: Center(
        child: Text(
          "Hello $uid",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
