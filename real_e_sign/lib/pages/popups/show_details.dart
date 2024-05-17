import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:real_e_sign/pages/popups/share_doc.dart';
import 'package:real_e_sign/widgets/StorageFunctions.dart';
import 'package:real_e_sign/pages/PDFViewer.dart';
import 'package:intl/intl.dart'; 
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void showDetails(signed_file sfile, DocumentReference fileref, var user,
    BuildContext context, var uid) {
      String isUplOrSig = "Uploaded"; 
      if(sfile.signStatus == true){
          isUplOrSig = "Signed";
      } 
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: StatefulBuilder(builder: (context, setState) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("${sfile.file_name}"),
                  const SizedBox(height: 10),
                  Text("$isUplOrSig on: ${DateFormat('MM/dd/yyyy hh:mm:ss').format(sfile.uploaded_at.toLocal())}"),
                  const SizedBox(height: 10),
                  Text(
                      "$isUplOrSig  by: ${user.get('first_name')} ${user.get('last_name')}"),
                  const SizedBox(height: 10),
                  Text(
                      "$isUplOrSig at: Latitude: ${sfile.latitude}, Longitude: ${sfile.longitude}}"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () async {
                          final storageRef = FirebaseStorage.instanceFor(
                                  bucket: "gs://real-esign-2.appspot.com")
                              .ref();
                          final pathRef = storageRef.child(sfile.storage_path!);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      viewPdf(pdfUrl: pathRef)));
                        },
                        child: const Text('View'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final storageRef = FirebaseStorage.instanceFor(
                                  bucket: "gs://real-esign-2.appspot.com")
                              .ref();
                          final pathRef = storageRef.child(sfile.storage_path!);
                          final fileUrl = await pathRef.getDownloadURL();
                          html.AnchorElement anchorElement =
                              new html.AnchorElement(href: fileUrl);
                          anchorElement.download = fileUrl;
                          anchorElement.click();
                        },
                        child: const Text('Download'),
                      ),
                      TextButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(content: StatefulBuilder(
                                  builder: (context, setState) {
                                    return shareItem(
                                        null, sfile.file_name!, fileref, uid);
                                  },
                                ));
                              });
                        },
                        child: const Text('Share'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  )
                ],
              ));
        }));
      });
}
