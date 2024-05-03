import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
class SignaturePage extends StatefulWidget {
  const SignaturePage({Key? key});
  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage>{
  // Create a SignatureController to control the signature pad
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  // Variable to store whether a signature has been saved
  bool _signatureSaved = false;
  Uint8List? image;

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
                    _controller.toPngBytes().then((data) {
                      // Handle saving the signature data (e.g., save to file, send to server)
                      // Here, you could save the data to show the preview later
                    });
                  });
                },
                child: Text('Save'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Clear the signature
                    _controller.clear();
                    _signatureSaved = false;
                  });
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
                // Provide your saved signature image data here
                Uint8List(0), // Replace Uint8List(0) with your signature data
              ),
            ),
        ],
      ),
    );
  }
}

