import 'package:flutter/material.dart';
import 'package:real_e_sign/widgets/StorageFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class shareItem extends StatefulWidget {
  final signed_file sfile;
  final String? uid;
  final String? fileID; 
  shareItem(Key? key, this.sfile, this.fileID, this.uid);

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
                  final SharedFile = {
                    'file_id': '$widget.fileID',
                    'sender_id': '${widget.uid}',
                    'shared_on': DateTime.now(),
                  };
                  db.collection('Users').doc('shareuid').collection('sharedFiles').add(SharedFile);
    
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
