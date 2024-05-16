import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_e_sign/pages/popups/show_details.dart';
import 'package:real_e_sign/widgets/StorageFunctions.dart'; 

class ListDocuments extends StatefulWidget {
  const ListDocuments({super.key});

  @override
  State<ListDocuments> createState() => _ListDocumentsState();
}

class _ListDocumentsState extends State<ListDocuments> {
  late String? uid;
  late FirebaseFirestore db;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
    db = FirebaseFirestore.instance;
  }
  
  //function for the show details on pressing an item. 
  
  /* deprecated with firestore managing files
  final storage =
      FirebaseStorage.instanceFor(bucket: "gs://real-esign-2.appspot.com");
  final storageRef =
      FirebaseStorage.instanceFor(bucket: "gs://real-esign-2.appspot.com").ref();
  */
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: db.collection("Users").doc('$uid').collection('UserFiles').get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              margin:
                  const EdgeInsets.only(left: 8.0, top: 2.0, bottom: 2.0, right: 8.0),
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
                    Text("${snapshot.data!.docs[index].get('file_name')}"),
                    Spacer(),
                    IconButton(
                        onPressed: () async {
                          final data = snapshot.data!.docs[index].data() as Map<String, dynamic>; 
                          signed_file sfile = signed_file.fromDocSnapshot(data);
                          DocumentReference fileRef = snapshot.data!.docs[index].reference; 
                          print(sfile.file_name); 
                          var user = await db
                              .collection('Users')
                              .doc(
                                  '${snapshot.data!.docs[index].get('creator_uid')}')
                              .get();
                          return showDetails(sfile,fileRef, user, context, uid);
                        },
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
