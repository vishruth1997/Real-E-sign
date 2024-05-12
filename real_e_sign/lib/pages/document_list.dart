import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:real_e_sign/widgets/StorageFunctions.dart';

class ListDocuments extends StatefulWidget {
  @override
  State<ListDocuments> createState() => _ListDocumentsState();
}

class _ListDocumentsState extends State<ListDocuments> {
  late String UID;
  final storage =
      FirebaseStorage.instanceFor(bucket: "gs://real-esign-2.appspot.com");
  final storageRef =
      FirebaseStorage.instanceFor(bucket: "gs://real-esign-2.appspot.com").ref();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FutureData?>(
      future: getData(storageRef),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: snapshot.data!.DocList.length,
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                margin: EdgeInsets.only(
                    left: 8.0, top: 2.0, bottom: 2.0, right: 8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, //change here don't //worked
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("${snapshot.data!.DocList[index]}" ?? "null"),
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
                                              "${snapshot.data!.DocList[index]}"),
                                          const SizedBox(height: 15),
                                          Text(
                                              "file info/date/etc."),
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
                          icon: const Icon(Icons.details))
                    ]),
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class FutureData {
  final List<dynamic> DocList;
  final String? UID;
  FutureData({required this.DocList, required this.UID});
}
