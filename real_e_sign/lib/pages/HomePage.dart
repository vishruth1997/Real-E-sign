import 'package:flutter/material.dart';
import 'SignDoc.dart';
import './cloud_storage_tab.dart'; 
import 'CreateSign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart'; 

void SignOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // Pop the current page
    Navigator.pop(context);
    // Push the new page (HomeRoute in this case)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = "Real E-Sign";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar( //tab bar to list documents and list shared documents
              tabs: [
                Tab(text: "My Documents"),
                Tab(text: "Shared Documents"),
              ],
            ), // TabBar
            title: const Text('Real E-Sign'),
            actions: <Widget>[ //button to route to the document signer
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentSigner())); 
              }, icon: const Icon(Icons.add))
            ],
            backgroundColor: Colors.green,
          ), // AppBar
          body: TabBarView(
            children: [
              CloudStorage(),
              Center(child:
                Text('Hello There')
                ),
            ],
          ),
          drawer: Drawer(
            //remove/replace soon
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Drawer Header'),
                ),
                ListTile(
                  title: const Text('Add Signature'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignaturePage())); 
                  },
                ),
                ListTile(
                  title: const Text('Sign Out'),
                  onTap: () {
                    SignOut(context); 
                  },
                ),
              ],
            ),
          ),// TabBarView
        ), // Scaffold
      ); // DefaultTabController// MaterialApp
  }
}
