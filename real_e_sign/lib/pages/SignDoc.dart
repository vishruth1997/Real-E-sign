import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; //filepicker path results not used on web, use bytes
import 'dart:typed_data'; //for uint8list

class DocumentSigner extends StatefulWidget {
  const DocumentSigner({super.key});
  @override
  _DocumentSignerState createState() => _DocumentSignerState();
}

class _DocumentSignerState extends State<DocumentSigner> {
  TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;
  String? _filePath;
  PlatformFile? document; //stores result.files.single to get various attriubtes

  final storage = FirebaseStorage.instanceFor(bucket: "gs://real-esi.appspot.com"); //our project bucket
  final storageRef = FirebaseStorage.instanceFor(bucket: "gs://real-esi.appspot.com").ref(); //reference to storage path
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  Future<void> _selectDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        if (!kIsWeb) //path doesn't work on web, throws exception
        {
          _filePath = result.files.single.path; 
        }
        document = result.files.single; //get the document single.  
      });
    }
  }
  //basic upload function. can later be replaced with maybe a popup window showing status like success/inprogress/failed/etc. 
  Future<void> _uploadDocument() async{ 
    if(document == null){ //return if document not selected.  
      return; 
    }
    if(document!.name == null){ //return if file has no name for w/e reason
      return; 
    }
    final fileRef = storageRef.child(document!.name); //create a reference to the uploaded file on firebase
    if(kIsWeb){
      Uint8List fileBytes = document!.bytes!; //get the bytes of the document
      await fileRef.putData(fileBytes);  //upload using bytes
    }
    else{
    File file = File(_filePath!);  //create a "File" from the Filepath
    await fileRef.putFile(file); //upload file.  returns type UploadTask which tracks status of the upload. 
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Signer'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                Text(
                  'Selected Date: ',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 10.0),
                _selectedDate == null
                    ? Text(
                        'No Date Selected',
                        style: TextStyle(fontSize: 16.0),
                      )
                    : Text(
                        '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _selectDocument,
              child: Text('Select a Document to Sign'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _uploadDocument,
              child: Text('upload selected document'),
            ),
          ],
        ),
      ),
    );
  }
}
