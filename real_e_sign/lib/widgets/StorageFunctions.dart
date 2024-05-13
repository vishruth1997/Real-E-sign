import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/document_list.dart';
import 'dart:convert';

Future<FutureData> getData(Reference storageRef) async {
  print("getting data");
  final user_id = await FirebaseAuth.instance.currentUser?.uid;
  print("got uid");
  final fileRef = storageRef.child("$user_id");
  final listResult = await fileRef.listAll();
  print("listed all files");
  var storageList = [];
  for (var item in listResult.items) {
    String name = await item.getDownloadURL();
    print(name);
    storageList.add(item.name);
  }
  return FutureData(DocList: storageList, UID: user_id);
}

Future<void> createFile(signed_file sFile) async{
            final db = FirebaseFirestore.instance;
            String? uid = await FirebaseAuth.instance.currentUser?.uid; 
            db.collection("Users").doc('$uid').collection("UserFiles").add(sFile.toJson());
            return;
}

Future<void> shareFile(signed_file sfile, String? send_uid, String? rec_uid) async{
   final db = FirebaseFirestore.instance;
}

class eUser {
  final String? first_name;
  final String? last_name;
  final String? email;
  final String? uid;
  eUser(
      {this.first_name,
      this.last_name,
      required this.email,
      required this.uid});

  factory eUser.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) => eUser(
        email: doc['email'] as String,
        first_name: doc['first_name'] as String,
        last_name: doc['last_name'] as String,
        uid: doc['uid'] as String,
      );
  Map<String, dynamic> toJson() => {
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "uid": uid,
      };
}

class signed_file {
  final String? file_name;
  final String? storage_path;
  final String? creator_uid;
  final DateTime uploaded_at;
  signed_file(
      {this.file_name,
      this.storage_path,
      required this.creator_uid,
      required this.uploaded_at});

  factory signed_file.fromDocSnapshot(Map<String, dynamic> doc) => signed_file(
        file_name: doc['file_name'] as String,
        storage_path: doc['storage_path'] as String,
        creator_uid: doc['creator_uid'] as String,
        uploaded_at: DateTime.parse(doc['uploaded_at'].toDate().toString()),
      );
  Map<String, dynamic> toJson() => {
        "file_name": file_name,
        "storage_path": storage_path,
        "creator_uid": creator_uid,
        "uploaded_at": uploaded_at,
      };
}
