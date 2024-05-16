import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_e_sign/pages/HomePage.dart';
import 'Register.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  String error = "";
  @override
  void initState() {}

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                Container(
                  margin: const EdgeInsets.all(30),
                  child: Text(
                    'Welcome to Real E-Sign!',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                      minHeight: 200,
                      minWidth: 400,
                      maxHeight: 600,
                      maxWidth: 500),
                  child: Card(
                    margin: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            controller: _email,
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _password,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: () async {
                                if (_email.text.isEmpty) {
                                  setState(() {
                                    error = "Please enter an email!";
                                  });
                                } else if (_password.text.isEmpty) {
                                  setState(() {
                                    error = "Please enter a password!";
                                  });
                                }
                                try {
                                  final credential = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: _email.text,
                                    password: _password.text,
                                  );
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    print('wrong password');

                                    setState(() {
                                      error = 'No user found for that email.';
                                    });
                                  } else if (e.code == 'wrong-password') {
                                    print('wrong password');
                                    setState(() {
                                      error = 'Incorrect Password';
                                    });
                                  } else {
                                  }
                                }
                              },
                              child: const Text('Login')),
                          Text(
                            '$error',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Not registered?',
                            style: Theme.of(context).textTheme.bodySmall),
                        TextButton(
                            child: const Text('Sign Up!'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()));
                            }),
                      ]),
                ),
                const Spacer(flex: 4),
              ],
            ));
          }
          return const HomePage();
        });
  }
}
