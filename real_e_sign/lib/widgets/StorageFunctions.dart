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

eUser eUserFromJson(String str) => eUser.fromJson(json.decode(str));
String eUserToJson(eUser data) => json.encode(data.toJson());

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

  factory eUser.fromJson(Map<String, dynamic> json) => eUser(
        email: json['email'] as String,
        first_name: json['first_name'] as String,
        last_name: json['last_name'] as String,
        uid: json['uid'] as String,
      );
  Map<String, dynamic> toJson() => {
        "firest_name": first_name,
        "last_name": last_name,
        "email": email,
        "uid": uid,
      };
}
