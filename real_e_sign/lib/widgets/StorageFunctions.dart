import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/document_list.dart';

Future<FutureData> getData(Reference storageRef) async{
  final user_id = await FirebaseAuth.instance.currentUser?.uid; 
  final fileRef = storageRef.child("$user_id"); 
  final listResult = await fileRef.listAll();
  var storageList = []; 
  for (var item in listResult.items) {
    storageList.add(item.name); 
  }
  return FutureData(DocList: storageList, UID: user_id); 
}