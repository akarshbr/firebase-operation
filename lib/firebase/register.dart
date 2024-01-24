import 'package:firebase_operation/firebase/firebase_function.dart';
import 'package:firebase_operation/firebase/login.dart';
import 'package:flutter/material.dart';

class RegisterFirebase extends StatelessWidget {
  RegisterFirebase({super.key});

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
          Text("Register",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
            child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Name")),
          ),
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
              onPressed: () {
                String enteredName = nameController.text.trim();
                String enteredEmail = emailController.text.trim();
                String enteredPassword = passwordController.text.trim();
                FireBaseHelper()
                    .registerUser(email: enteredEmail, password: enteredPassword)
                    .then((result) {
                  if (result == null) {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => LoginFirebase()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result), backgroundColor: Colors.redAccent));
                  }
                });
              },
              child: Text("Register")),
        ],
      ),
    );
  }
}
