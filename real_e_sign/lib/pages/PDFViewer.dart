import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Represents the PDF stateful widget class.
/// class SignaturePadApp extends StatelessWidget {

class viewPdf extends StatefulWidget {
  Reference? pdfUrl;
  viewPdf({Key? key, required this.pdfUrl});

  @override
  viewPdfState createState() => viewPdfState();
}

class viewPdfState extends State<viewPdf> {
  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List?> getPdfBytes() async {
    Uint8List? pdfBytes;
    pdfBytes =  await widget.pdfUrl!.getData(); 
    return pdfBytes;
  }
  Future<String?> getPdfUrl() async {
    String? RealUrl = await widget.pdfUrl?.getDownloadURL(); 
    return RealUrl;
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: getPdfUrl(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                SfPdfViewer.network(snapshot.data!);
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
