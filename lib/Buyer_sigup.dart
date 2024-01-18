import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/ask_signup.dart';
import 'package:mobile_app/login1.dart';

class Buyer_signup extends StatefulWidget {
  const Buyer_signup({Key? key}) : super(key: key);

  @override
  State<Buyer_signup> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Buyer_signup> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _email = '',
      _contactno = '',
      _password = '',
      _confirmPassword = '',
      _username = '';

  Future<void> _signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.trim(),
        password: _password,
      );

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      // Save user details to Firestore
      await FirebaseFirestore.instance
          .collection('buyer_details')
          .doc(user?.uid)
          .set({
        'email': _email.trim(),
        'username': _username,
        'contactno': _contactno,

        // Add more fields as needed
      });

      // User successfully created. You can navigate to the next screen.
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login1()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle sign-up errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sign-up error: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AskSignup()),
              );
            },
            child: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 60.0),
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          const Center(
                            child: Text(
                              "Happy to Start",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            onSaved: (value) {
                              _email = value ?? '';
                            },
                            validator: (email) {
                              if (email?.isEmpty ?? true) {
                                return "Please enter Email";
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(email!)) {
                                return "It's not a valid Email";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.blue.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.shop),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            onSaved: (value) {
                              _username = value ?? '';
                            },
                            validator: (username) {
                              if (username?.isEmpty ?? true) {
                                return "Please enter your user name";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "User Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.blue.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.medical_services),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            onSaved: (value) {
                              _contactno = value ?? '';
                            },
                            validator: (contactno) {
                              if (contactno?.isEmpty ?? true) {
                                return "Please enter your contact no";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Contact Number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.blue.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.phone),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            onSaved: (value) {
                              _password = value ?? '';
                            },
                            validator: (password) {
                              if (password?.isEmpty ?? true) {
                                return "Please enter Password";
                              } else if ((password?.length ?? 0) < 4 ||
                                  (password?.length ?? 0) > 15) {
                                return "Password length should be between 4 and 15";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.blue.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.lock),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            onSaved: (value) {
                              _confirmPassword = value ?? '';
                            },
                            validator: (confirmPassword) {
                              if (confirmPassword?.isEmpty ?? true) {
                                return "Please enter confirmed Password";
                              } else if (_password != _confirmPassword) {
                                return "Password and Confirm password do not match";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.blue.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.lock),
                            ),
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Already have an account?"),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login1()),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState != null &&
                                  formKey.currentState!.validate()) {
                                formKey.currentState?.save();
                                _signUp();
                              }
                            },
                            child: const Text(
                              "Sign up",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                              backgroundColor: Colors.blue[900],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
