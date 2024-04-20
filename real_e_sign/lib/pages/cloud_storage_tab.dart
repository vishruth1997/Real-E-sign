import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:real_e_sign/main.dart';

class CloudStorage extends StatefulWidget{  
  @override
  State<CloudStorage> createState() => _CloudStorageState();
}

class _CloudStorageState extends State<CloudStorage> {
   @override
  Widget build(BuildContext context) {
    return Text("Lisan Al Gaib");
    
  }
}