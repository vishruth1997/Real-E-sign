import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:real_e_sign/widgets/StorageFunctions.dart';

class CloudStorage extends StatefulWidget {
  @override
  State<CloudStorage> createState() => _CloudStorageState();
}

class _CloudStorageState extends State<CloudStorage> {
  late String UID; 
  final storage =
      FirebaseStorage.instanceFor(bucket: "gs://real-esi.appspot.com");
  final storageRef =
      FirebaseStorage.instanceFor(bucket: "gs://real-esi.appspot.com").ref();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FutureData?>(
      future: getData(storageRef),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          
          return ListView.builder(
            itemCount: snapshot.data!.list.length,
            itemBuilder: (context, index) {
              return Container(
                  height: 50,
                  child: Center(
                      child: Text("${snapshot.data!.list[index]}" ?? "null")));
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class FutureData{
  final List<dynamic> list;
  final String? UID; 
  FutureData({required this.list, required this.UID});
}