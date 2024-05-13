import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
class SignaturePage extends StatefulWidget {
  const SignaturePage({Key? key});
  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage>{
    final storage = FirebaseStorage.instanceFor(bucket: "gs://real-esign-2.appspot.com"); //our project bucket
    final storageRef = FirebaseStorage.instanceFor(bucket: "gs://real-esign-2.appspot.com").ref(); //reference to storage path


  // Create a SignatureController to control the signature pad
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  // Variable to store whether a signature has been saved
  bool _signatureSaved = false;
  Uint8List? image;

Future<void> uploadImage() async {
  if (image == null) {
    return;
  }

  // Ensure that there's a signed-in user
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('No signed-in user.');
    return;
  }

  // Retrieve the user ID
  String user_id = user.uid;
  final fileRef = storageRef.child("$user_id/signature.png");

  try {
    if (kIsWeb) {
      // For web, directly upload image data
      await fileRef.putData(image!);
    } else {
      // For Android, convert the Uint8List to a File
      Uint8List imageData = image!;
      Directory tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/signature.png').create();
      await file.writeAsBytes(imageData);

      // Upload the File to Firebase Storage
      await fileRef.putFile(file);
      // Upload the File to Firebase Storage
    }
    // print('Image uploaded successfully.');
  } catch (e) {
    print('Error uploading image: $e');
  }
  return;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signature Pad'),
      ),
      body: Column(
        children: [
          // Signature widget
          Signature(
            controller: _controller,
            height: 300,
            backgroundColor: Colors.white,
          ),
          // Save and Clear buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Save the signature
                    _controller.toPngBytes().then((data) async {
                      // Handle saving the signature data (e.g., save to file, send to server)
                      // Here, you could save the data to show the preview later
                      image = data;
                      await uploadImage();
                      _signatureSaved = true;
                    });
                  });
                },
                child: Text('Save'),
              ),
              ElevatedButton(
                onPressed: () {
                  /*setState(() {
                    // Clear the signature
                    _controller.clear();
                    _signatureSaved = false;
                  });*/
                },
                child: Text('Clear'),
              ),
            ],
          ),
          // Signature preview
          if (_signatureSaved)
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Signature Preview:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          if (_signatureSaved)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Image.memory(
                // Display saved signature preview
                image!,
              ),
            ),
        ],
      ),
    );
  }
}

