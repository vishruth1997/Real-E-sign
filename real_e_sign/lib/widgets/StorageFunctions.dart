import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<List> getList(Reference storageRef) async{
  final listResult = await storageRef.listAll();
  var storageList = []; 
  for (var item in listResult.items) {
    storageList.add(item); 
  }
  return storageList; 
}