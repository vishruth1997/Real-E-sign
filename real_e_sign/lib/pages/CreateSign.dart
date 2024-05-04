import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
class SignaturePage extends StatefulWidget {
  const SignaturePage({Key? key});
  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage>{
    final storage = FirebaseStorage.instanceFor(bucket: "gs://real-esi.appspot.com"); //our project bucket
    final storageRef = FirebaseStorage.instanceFor(bucket: "gs://real-esi.appspot.com").ref(); //reference to storage path


  // Create a SignatureController to control the signature pad
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  // Variable to store whether a signature has been saved
  bool _signatureSaved = false;
  Uint8List? image;

  Future<void> uploadImage()async{
    if(image==null){
      return;
    }
    User? user = FirebaseAuth.instance.currentUser;
    String user_id = user!.uid;
    final fileRef = storageRef.child("$user_id/signature.png");
    if(kIsWeb){
      // Uint8List fileBytes = image!.bytes!;
      await fileRef.putData(image!); 
    }
    else{
      // should implement to store into the firestorage
    }
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
                    _signatureSaved = true;
                    _controller.toPngBytes().then((data) async {
                      // Handle saving the signature data (e.g., save to file, send to server)
                      // Here, you could save the data to show the preview later
                      image = data;
                    });
                    uploadImage();
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

