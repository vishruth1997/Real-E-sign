import 'package:flutter/material.dart';
import 'package:real_e_sign/widgets/StorageFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class shareItem extends StatefulWidget {
  final String fileName;
  final String? uid;
  final DocumentReference fileRef; 
  shareItem(Key? key, this.fileName, this.fileRef, this.uid);

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
          const Text("Enter email of user to share with: "),
          const SizedBox(height: 10),
          TextField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          ElevatedButton(
              onPressed: () async {
                DocumentReference myUser = db.collection('Users').doc('${widget.uid}');  
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
                  var shareUID = shareUser.docs.first.get('uid'); //firestore document of the user being shared to
                  final SharedFile = {
                    'file_ref': widget.fileRef,
                    'sender_ref': myUser,
                    'shared_on': DateTime.now().toUtc(),
                  };
                  print('shareUID'); 
                 db.collection('Users').doc(shareUID).collection('SharedFiles').add(SharedFile);
    
                  setState(() {
                    successStatus = 'File shared!';
                  });
                  print(widget.fileName);
                }
              },
              child: const Text('Share')),
          Text(
            '$errorstatus',
            style: const TextStyle(color: Colors.red),
          ),
          Text(
            '$successStatus',
            style: const TextStyle(color: Colors.green),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'))
        ]);
  }
}
