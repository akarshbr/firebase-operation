import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  runApp(MaterialApp(home: FirebaseCrud()));
}

class FirebaseCrud extends StatefulWidget {
  FirebaseCrud({super.key});

  @override
  State<FirebaseCrud> createState() => _FirebaseCrudState();
}

class _FirebaseCrudState extends State<FirebaseCrud> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  late CollectionReference _userCollection;

  @override
  void initState() {
    _userCollection = FirebaseFirestore.instance.collection("users");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> addUser() async {
      return _userCollection.add(
          {"name": nameController.text.trim(), "email": emailController.text.trim()}).then((value) {
        print("User Added");
        nameController.clear();
        emailController.clear();
      }).catchError((onError) {
        print("Failed");
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Firebase Cloud"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Name")),
          TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Email")),
          ElevatedButton(
              onPressed: () {
                addUser();
              },
              child: Text("Add User")),
          StreamBuilder<QuerySnapshot>(
              stream: getUser(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error ${snapshot.error}");
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                final users = snapshot.data!.docs;
                return Expanded(
                  child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final userID = user.id;
                        final userName = user["name"];
                        final userEmail = user["email"];
                        return Card(
                          color: Colors.black,
                          child: ListTile(
                            title: Text(userName, style: TextStyle(color: Colors.white)),
                            subtitle: Text(userEmail, style: TextStyle(color: Colors.white)),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      editUser(userID);
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      deleteUser(userID);
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            ),
                          ),
                        );
                      }),
                );
              })
        ]),
      ),
    );
  }

  Stream<QuerySnapshot> getUser() {
    return _userCollection.snapshots();
  }

  void editUser(var id) {
    final editNameController = TextEditingController();
    final editEmailController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: editNameController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Name"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: editEmailController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Email"),
                )
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    updateUser(id, editNameController.text, editEmailController.text);
                  },
                  child: Text("Update"))
            ],
          );
        });
  }

  Future<void> updateUser(var id, String newName, String newEmail) {
    return _userCollection.doc(id).update({"name": newName, "email": newEmail}).then((value) {
      print("Updated Successfully");
    }).catchError((error) {
      print("Failed");
    });
  }

  void deleteUser(var id) {
    _userCollection.doc(id).delete().then((value) {
      print("user deleted");
    }).catchError((error) {
      print("Failed");
    });
  }
}
