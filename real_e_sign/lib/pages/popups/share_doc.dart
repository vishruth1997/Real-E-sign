import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:real_e_sign/widgets/StorageFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class shareItem extends StatefulWidget {
  final signed_file sfile;
  final String? uid;
  shareItem(Key? key, this.sfile, this.uid);

  @override
  State<shareItem> createState() => _shareItemState();
}

class _shareItemState extends State<shareItem> {
  final TextEditingController _email = TextEditingController();
  final db = FirebaseFirestore.instance; 
  String? errorstatus = '';
  String? successStatus = '';


  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Enter email of user to share with: "),
          const SizedBox(height: 10),
          TextField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          ElevatedButton(
              onPressed: () async {
                var shareUser = await db
                    .collection('Users')
                    .where("email", isEqualTo: _email.text)
                    .get();
                if (shareUser.docs.isEmpty) {
                  setState(() {
                    errorstatus = 'user does not exist!';
                    print("error does not exist");
                  });
                } else {
                  String? shareuid = shareUser.docs.first.get('uid');
    
                  setState(() {
                    successStatus = widget.sfile.file_name;
                  });
                  print(widget.sfile.file_name);
                }
              },
              child: Text('Share')),
          Text(
            '$errorstatus',
            style: TextStyle(color: Colors.red),
          ),
          Text(
            '$successStatus',
            style: TextStyle(color: Colors.green),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'))
        ]);
  }
}
