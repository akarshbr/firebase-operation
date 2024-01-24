import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_operation/firebase/firebase_function.dart';
import 'package:firebase_operation/firebase/home.dart';
import 'package:firebase_operation/firebase/register.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAHPbvuMDqhMP8ynSpvAXVbFJ5-MhZIwqM",
          appId: "1:486936459036:android:25651abe4e4cdcdcddecd9",
          messagingSenderId: "",
          projectId: "fir-operation-baa1e"));
  User? user = FirebaseAuth.instance.currentUser;
  runApp(MaterialApp(home: user == null ? LoginFirebase() : HomeFirebase()));
}

class LoginFirebase extends StatelessWidget {
  LoginFirebase({super.key});

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
          title: Text("Register firebse", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.black),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Login",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
            child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Email")),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
            child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Password")),
          ),
          ElevatedButton(
              onPressed: () async {
                String enteredEmail = emailController.text.trim();
                String enteredPassword = passwordController.text.trim();
                FireBaseHelper()
                    .loginUser(email: enteredEmail, password: enteredPassword)
                    .then((result) {
                  if (result == null) {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => HomeFirebase()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result), backgroundColor: Colors.redAccent));
                  }
                });
              },
              child: Text("Login")),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "Dont have an Account,",
                style: TextStyle(color: Colors.white),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => RegisterFirebase()));
                  },
                  child: Text(
                    "Sign UP",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
