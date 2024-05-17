import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:real_e_sign/widgets/StorageFunctions.dart';
import 'package:intl/intl.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void showSharedDetails(signed_file sfile, String? sender_name,
    DateTime shared_date, BuildContext context) {
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
                  Text(
                      "signed on:${DateFormat('MM/dd/yyyy hh:mm:ss').format(sfile.uploaded_at.toLocal())}"),
                  const SizedBox(height: 10),
                  Text("signed by: $sender_name"),
                  const SizedBox(height: 10),
                  Text(
                      "signed at: Latitude: ${sfile.latitude}, Longitude: ${sfile.longitude}}"),
                  const SizedBox(height: 10),
                  Text(
                      "shared with you on:${DateFormat('MM/dd/yyyy hh:mm:ss').format(shared_date)}"),
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

                          final fileUrl = await pathRef.getDownloadURL();
                          html.AnchorElement anchorElement =
                              html.AnchorElement(href: fileUrl);
                          anchorElement.download = fileUrl;
                          anchorElement.click();
                        },
                        child: const Text('Download'),
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
