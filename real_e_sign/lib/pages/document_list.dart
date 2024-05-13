import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:real_e_sign/widgets/StorageFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListDocuments extends StatefulWidget {
  @override
  State<ListDocuments> createState() => _ListDocumentsState();
}

class _ListDocumentsState extends State<ListDocuments> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final db = FirebaseFirestore.instance; 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  /* deprecated with firestore managing files
  final storage =
      FirebaseStorage.instanceFor(bucket: "gs://real-esign-2.appspot.com");
  final storageRef =
      FirebaseStorage.instanceFor(bucket: "gs://real-esign-2.appspot.com").ref();
  */
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: db.collection("Users").doc('$uid').collection('UserFiles').get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              margin:
                  EdgeInsets.only(left: 8.0, top: 2.0, bottom: 2.0, right: 8.0),
              width: 800,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 230, 205, 231),
                  borderRadius: BorderRadius.circular(15.0)),
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, //change here don't //worked
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("${snapshot.data!.docs[index].get('file_name')}" ?? "null"),
                    Spacer(),
                    IconButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                            "${snapshot.data!.docs[index].get('file_name')}"),
                                        const SizedBox(height: 15),
                                        Text("uploaded on: ${snapshot.data!.docs[index].get('uploaded_at')}"),
                                        Row(
                                          children: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Download'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
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
                                    )))),
                        icon: const Icon(Icons.more_vert))
                  ]),
            );
          },
        );
      },
    );
  }
}

class FutureData {
  final List<dynamic> DocList;
  final String? UID;
  FutureData({required this.DocList, required this.UID});
}
