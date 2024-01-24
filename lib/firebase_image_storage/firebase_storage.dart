import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAHPbvuMDqhMP8ynSpvAXVbFJ5-MhZIwqM",
          appId: "1:486936459036:android:25651abe4e4cdcdcddecd9",
          messagingSenderId: "",
          projectId: "fir-operation-baa1e",
          storageBucket: "fir-operation-baa1e.appspot.com"));
  runApp(MaterialApp(home: FireImageStorage()));
}

class FireImageStorage extends StatefulWidget {
  const FireImageStorage({super.key});

  @override
  State<FireImageStorage> createState() => _FireImageStorageState();
}

class _FireImageStorageState extends State<FireImageStorage> {
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Cloud"), centerTitle: true),
      body: Center(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    onPressed: () => upload("camera"),
                    icon: Icon(FontAwesomeIcons.cameraRetro),
                    label: Text("Camera")),
                ElevatedButton.icon(
                    onPressed: () => upload("gallery"),
                    icon: Icon(FontAwesomeIcons.photoFilm),
                    label: Text("Gallery"))
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                  future: loadFile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return GridView.builder(
                          itemCount: snapshot.data?.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            final image = snapshot.data![index];
                            return Card(
                              child: Stack(
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(image["imageURL"]),
                                            fit: BoxFit.cover)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 100),
                                    child: IconButton(
                                        onPressed: () => deleteFile(image["path"]),
                                        icon: Icon(Icons.delete),
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            );
                          });
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            )
          ],
        ),
      ),
    );
  }

  Future<void> upload(String imageFrom) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
          source: imageFrom == "camera" ? ImageSource.camera : ImageSource.gallery);
      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);
      try {
        await storage
            .ref(fileName)
            .putFile(imageFile, SettableMetadata(customMetadata: {"Phone:": "Realme 6 Pro"}));
        setState(() {});
      } on FirebaseException catch (error) {
        print(error);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<List<Map<String, dynamic>>> loadFile() async {
    List<Map<String, dynamic>> images = [];
    final ListResult results = await storage.ref().list();
    final List<Reference> allFiles = results.items;
    await Future.forEach(allFiles, (singleFile) async {
      final String fileURL = await singleFile.getDownloadURL();
      final FullMetadata metadata = await singleFile.getMetadata();
      images.add({
        "imageURL": fileURL,
        "path": singleFile.fullPath,
        "Phone:": metadata.customMetadata?["Phone:"] ?? "nodata"
      });
    });
    return images;
  }

  Future<void> deleteFile(String image) async {
    await storage.ref(image).delete();
    setState(() {});
  }
}
