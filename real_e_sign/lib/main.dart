import 'package:flutter/material.dart';
import 'pages/LogIn.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


//To Do: for potential api stuff pls no touch
const clientId = 'YOUR_CLIENT_ID';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );


 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  const MyApp({super.key});
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LogIn(),
    );
  }
}
