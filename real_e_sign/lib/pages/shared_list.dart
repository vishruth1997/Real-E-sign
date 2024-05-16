//displays a list of file shared to the userDimport 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_e_sign/pages/popups/show_shared_details.dart';
import 'package:real_e_sign/widgets/StorageFunctions.dart';

class SharedDocuments extends StatefulWidget {
  @override
  State<SharedDocuments> createState() => _SharedDocumentsState();
}

class _SharedDocumentsState extends State<SharedDocuments> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> sharedFilesStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('SharedFiles')
      .snapshots();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: sharedFilesStream,
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
            return FutureBuilder(
                future: getFuture(snapshot.data!.docs[index].get('file_ref'),
                    snapshot.data!.docs[index].get('sender_ref'), snapshot.data!.docs[index].get('shared_on').toDate().toLocal()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } 
                  else {
                    signed_file sfile = snapshot.data!.sfile; 
                    String? sender_name = snapshot.data!.sender_name; 
                    DateTime shared_on = snapshot.data!.shared_on; 
                    return Container(
                      height: 100,
                      margin: EdgeInsets.only(
                          left: 8.0, top: 2.0, bottom: 2.0, right: 8.0),
                      width: 800,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 230, 205, 231),
                          borderRadius: BorderRadius.circular(15.0)),
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, //change here don't //worked
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                                "${sfile.file_name}" ??
                                    "null"),
                            Spacer(),
                            IconButton(
                                onPressed: () async {
                                  showSharedDetails(
                                      sfile, sender_name, shared_on, context);
                                },
                                icon: const Icon(Icons.more_vert))
                          ]),
                    );
                  }
                });
          },
        );
      },
    );
  }
}

class FutureData {
  final signed_file sfile;
  final String? sender_name;
  final DateTime shared_on;
  FutureData({required this.sfile, required this.sender_name, required this.shared_on});
}

Future<FutureData> getFuture(
    DocumentReference file, DocumentReference user, DateTime shared_on) async {
  DocumentSnapshot fileSnap = await file.get();
  final filedata = fileSnap.data() as Map<String, dynamic>;
  signed_file sfile = signed_file.fromDocSnapshot(filedata);
  final userdoc = await user.get();
  final userdata = userdoc.data() as Map<String, dynamic>;
  final sender = eUser.fromDocSnapshot(userdata);
  final sender_name = "${sender.first_name} ${sender.last_name}";
  final sharedtime = shared_on.toLocal(); 
  return FutureData(sfile: sfile, sender_name: sender_name, shared_on: sharedtime);
}
