import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:real_e_sign/pages/popups/share_doc.dart';
import 'package:real_e_sign/widgets/StorageFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;

void showDetails(
    var snapshot, var index, var user, BuildContext context, var uid) {
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
                  Text("${snapshot.data!.docs[index].get('file_name')}"),
                  const SizedBox(height: 10),
                  Text(
                      "uploaded on: ${DateTime.parse(snapshot.data!.docs[index].get('uploaded_at').toDate().toString())}"),
                  const SizedBox(height: 10),
                  Text(
                      "signed by: ${user.get('first_name')} ${user.get('last_name')}"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () async {
                          final storageRef = FirebaseStorage.instanceFor(
                                  bucket: "gs://real-esign-2.appspot.com")
                              .ref();
                          final pathRef = storageRef.child(
                              snapshot.data.docs[index].get('storage_path'));
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
                                        null,
                                        signed_file.fromDocSnapshot(
                                            snapshot.data!.docs[index].data()
                                                as Map<String, dynamic>),
                                        uid,snapshot.data!.docs[index].ID);
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
