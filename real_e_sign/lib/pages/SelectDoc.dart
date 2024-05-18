import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart'
    show kIsWeb; //filepicker path results not used on web, use bytes
import 'dart:typed_data'; //for uint8list
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:real_e_sign/widgets/StorageFunctions.dart';
import './PDFsigner.dart';
import 'package:intl/intl.dart';


typedef documentCallBack = void Function();
class DocumentSelector extends StatefulWidget {
  final documentCallBack docCallBack;
  const DocumentSelector({Key? key, required this.docCallBack});
  @override
  DocumentSelectorState createState() => DocumentSelectorState();
}

class DocumentSelectorState extends State<DocumentSelector> {
  String? errorstatus = '';
  String? PDF_Upload_success = '';
  String? _filePath;
  String? doc_name = 'none';
  PlatformFile? document; //stores result.files.single to get various attributes
  Uint8List? documentbytes;
  Uint8List? signature_img;
  //location services
  Position? _currentLocation;
  Position? pulledPosition;
  late bool service_permission = false;
  late LocationPermission permission;
  String _currentAddress = "";
  bool selected = false;
  bool signed = false; 
  Future<Position> _getCurrentLocation() async {
    service_permission = await Geolocator.isLocationServiceEnabled();
    if (!service_permission) {
      print("service disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.locality},${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  _getlocationDetails() async {
    _currentLocation = await _getCurrentLocation();
    setState(() {
      _currentLocation;
    });
    while (_currentLocation == null) {}
    await _getAddressFromCoordinates();
    print("${_currentLocation}");
  }

  // InitSatet to get the location as soon as the page is opened

  @override
  void initState() {
    super.initState();
    _getlocationDetails();
  }

  final storage = FirebaseStorage.instanceFor(
      bucket: "gs://real-esign-2.appspot.com"); //our project bucket
  final storageRef =
      FirebaseStorage.instanceFor(bucket: "gs://real-esign-2.appspot.com")
          .ref(); //reference to storage path

  Future<void> _selectDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        if (!kIsWeb) //path doesn't work on web, throws exception
        {
          _filePath = result.files.single.path;
        }
        document = result.files.single; //get the document single.
        documentbytes = document!.bytes!;
        errorstatus = '';
        doc_name = document!.name;
        selected = true;
      });
    }
  }

  void pdfCallback(Uint8List pdf) {
    setState(() {
      documentbytes = pdf;
      signed = true; 
    });
  }

  //basic upload function. can later be replaced with maybe a popup window showing status like success/inprogress/failed/etc.
  _uploadDocument() async {
    if (document == null) {
      setState(() {
        errorstatus = 'document is null!';
      });
      //return if document not selected.
      return;
    }
    if (document?.name == null) {
      //return if file has no name for w/e reason
      setState(() {
        errorstatus = 'document name is null!';
      });
      return;
    }

    String? uid = await FirebaseAuth.instance.currentUser?.uid;
    final fileRef = storageRef.child(
        "$uid/$doc_name"); //create a reference to the uploaded file on firebase
    if (documentbytes == null) {
      setState(() {
        errorstatus = 'document bytes is null!';
      });
      return;
    } else if (kIsWeb) {
      print("is web! putdata!");
      await fileRef.putData(documentbytes!); //upload using bytes
      print("finished putting!");
    } else {
      File file = File(_filePath!); //create a "File" from the Filepath
      await fileRef.putFile(
          file); //upload file.  returns type UploadTask which tracks status of the upload.
    }

    var sfile = signed_file(
        creator_uid: uid,
        file_name: doc_name,
        storage_path: fileRef.fullPath,
        uploaded_at: DateTime.now().toUtc(),
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
        signStatus: signed);
    createFile(sfile);
    setState(() {
      PDF_Upload_success = '${document!.name} uploaded successfuly!';
    }
    );
    widget.docCallBack; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Document Signer'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Text(
                      'Signing time: ${DateFormat('MM/dd/yyyy hh:mm:ss').format(DateTime.now())}');
                },
              ),
              const SizedBox(height: 20.0),
              Text(
                  'You will be signing from: ($_currentAddress Longitude:${_currentLocation?.latitude}, Latitude${_currentLocation?.longitude})'),
              //Text('Location: ${_currentAdress}'),
              const SizedBox(height: 20.0),
              Text(
                'Selected Document: $doc_name',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _selectDocument,
                child: const Text('Select Document'),
              ),
              // Display selected document name
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (document == null) {
                    setState(() {
                      errorstatus = 'Please select a document!';
                    });
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PDFSigner(
                                  pdf: documentbytes!,
                                  pdfcb: pdfCallback,
                                )));
                  }
                },
                child: const Text('Sign Document'),
              ),
             const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _uploadDocument,
                child: const Text('Upload Document'),
              ),
              const SizedBox(height: 20.0),
              Text(
                '$errorstatus',
                style: const TextStyle(color: Colors.red),
              ),
              // Display selected document name
              Text('$PDF_Upload_success')
            ],
          ),
        ));
  }
}
