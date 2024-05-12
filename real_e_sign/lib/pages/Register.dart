import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_e_sign/pages/HomePage.dart'; 
import 'package:real_e_sign/widgets/StorageFunctions.dart'; 
import 'dart:convert';



Future<void> createUser(eUser user) async{
            final db = FirebaseFirestore.instance;
            db.collection("Users").doc("testuser123").set(user.toJson()).onError((error, stackTrace){print("error");});
            return;
}


class Register extends StatefulWidget {
  const Register({super.key});
  @override
  State<Register> createState() => RegisterState();
}

//replace with streambuilder method in login
class RegisterState extends State<Register> {
  RegisterState();
  String? uc = "";
  final TextEditingController FirstName = TextEditingController();
  final TextEditingController LastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String? uid = FirebaseAuth.instance.currentUser?.uid; 
            print(uid); 
            final user = eUser(email: _email.text, first_name: FirstName.text, last_name: LastName.text, uid: null);
            createUser(user);
            return HomePage(); 
          }
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(30),
                child: Text(
                  'Register an Account',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              Container(
                constraints: const BoxConstraints(
                    minHeight: 200,
                    minWidth: 400,
                    maxHeight: 600,
                    maxWidth: 500),
                child: Card(
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: FirstName,
                          decoration: const InputDecoration(labelText: 'First Name'),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: LastName,
                          decoration:
                              const InputDecoration(labelText: 'Last Name'),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _email,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _password,
                          decoration: const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (FirstName.text.isEmpty) {
                              setState(() {
                                uc = "Please enter a public_name!";
                              });
                            } else if (LastName.text.isEmpty) {
                              setState(() {
                                uc = "Please enter a private name";
                              });
                            }else if (_email.text.isEmpty) {
                              setState(() {
                                uc = "Please enter an email!";
                              });
                            } else if (_password.text.isEmpty) {
                              setState(() {
                                uc = "Please enter a password!";
                              });
                            }  
                            else {
                              try {
                                final credential = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: _email.text,
                                  password: _password.text,
                                );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  setState(() {
                                    uc = 'The password provided is too weak.';
                                  });
                                } else if (e.code == 'email-already-in-use') {
                                  setState(() {
                                    uc =
                                        'The account already exists for that email.';
                                  });
                                }
                              } catch (e) {
                                setState(() {
                                  uc = '$e';
                                });
                              }
                            }
                          },
                          child: const Text(
                            'Register',
                          ),
                        ),
                        Text(
                            '$uc',
                            style: TextStyle(color: Colors.red),
                          ), 
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Already registered?',
                          style: Theme.of(context).textTheme.bodySmall),
                      TextButton(
                          child: Text('Sign in!'),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ]),
              ),
            ],
          ));
        });
  }
}
