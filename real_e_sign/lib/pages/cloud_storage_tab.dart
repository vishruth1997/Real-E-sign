import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:real_e_sign/widgets/StorageFunctions.dart';

class CloudStorage extends StatefulWidget {
  @override
  State<CloudStorage> createState() => _CloudStorageState();
}

class _CloudStorageState extends State<CloudStorage> {
  final storage =
      FirebaseStorage.instanceFor(bucket: "gs://real-esi.appspot.com");
  final storageRef =
      FirebaseStorage.instanceFor(bucket: "gs://real-esi.appspot.com").ref();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List?>(
      future: getList(storageRef),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Container(
                  height: 50,
                  child: Center(
                      child: Text("${snapshot.data?[index]}" ?? "null")));
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
