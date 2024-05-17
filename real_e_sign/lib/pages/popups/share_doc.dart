import 'package:flutter/material.dart';
import 'package:real_e_sign/widgets/StorageFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//pop up to search for a user to share a file to. 
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
                //check for use to share with
                var search_user = await db
                    .collection('Users')
                    .where("email", isEqualTo: _email.text)
                    .get();
                 
                if (search_user.docs.isEmpty) {
                  setState(() {
                    errorstatus = 'user does not exist!';
                    print("error does not exist");
                  });
                  return; 
                } 
                final shareUID = search_user.docs.first.get('uid'); 
                final sharedUser = db.collection('Users').doc(shareUID); 
                var isSharedTo = await db.collection('Users').doc(widget.uid).collection('UserFiles').doc(widget.fileRef.id).collection('SharedTo').where("shared_user", isEqualTo: sharedUser).get();
                if(isSharedTo.docs.isNotEmpty){
                  setState(() {
                    errorstatus = 'File is already shared to that user!';
                    print("error: already shared");
                  });
                }
                else {
                  widget.fileRef.get(); 
                  //firestore document of the user being shared to
                  
                  DateTime shared_on = DateTime.now().toUtc(); 
                  final SharedFile = {
                    'file_ref': widget.fileRef,
                    'sender_ref': myUser,
                    'shared_on': shared_on,
                  };
                  final SharedTo = {
                    'shared_user': sharedUser,
                    'shared_on' : shared_on,
                  };
                 //add the SharedFile to the shared user's collection of shared files.  update the document in my files to show it's been shared to that person. 
                 sharedUser.collection('SharedFiles').add(SharedFile); 
                 myUser.collection('UserFiles').doc(widget.fileRef.id).collection('SharedTo').add(SharedTo); 
                  setState(() {
                    successStatus = '${widget.fileName} shared!';
                  });
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
