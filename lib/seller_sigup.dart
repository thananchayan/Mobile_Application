import 'dart:io' show File;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/ask_signup.dart';
import 'package:mobile_app/login1.dart';

class seller_signup extends StatefulWidget {
  const seller_signup({Key? key}) : super(key: key);

  @override
  State<seller_signup> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<seller_signup> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _email = '',
      _service = '',
      _contactno = '',
      _password = '',
      _confirmPassword = '',
      _company = '';

  XFile? image;

  Future<void> _signUp() async {
    try {
      // Create user in FirebaseAuth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.trim(),
        password: _password,
      );

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      // Upload image to Firebase Storage
      String imageUrl = await uploadImageToFirebaseStorage();

      // Save user details to Firestore along with the image URL
      await FirebaseFirestore.instance
          .collection('seller_details')
          .doc(user?.uid)
          .set({
        'email': _email.trim(),
        'service': _service,
        'contactno': _contactno,
        'company': _company,
        'imageUrl': imageUrl,
      });

      // Navigate to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login1()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sign-up error: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String> uploadImageToFirebaseStorage() async {
    if (image != null) {
      try {
        // Generate a unique filename
        String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();

        // Get a reference to the storage root
        Reference referenceRoot = FirebaseStorage.instance.ref();

        // Create a reference for the image to be stored
        Reference referenceDirImages = referenceRoot.child('images');
        Reference referenceImageToUpload =
            referenceDirImages.child(uniqueFileName);

        print("image url :" + image!.path);
        // Upload the file
        await referenceImageToUpload.putFile(File(image!.path));

        // Get the download URL of the uploaded image
        String imageUrl = await referenceImageToUpload.getDownloadURL();

        // Log the image URL for debugging
        print('Image URL: $imageUrl');

        return imageUrl;
      } catch (e) {
        // Log any errors during the image upload
        print('Image upload error: $e');
        return ''; // Return an empty string in case of an error
      }
    } else {
      // Return an empty string if no image is selected
      return '';
    }
  }

  Widget _buildImage() {
    if (image != null) {
      return kIsWeb
          ? Image.network(
              image!.path,
              height: 50,
              width: 50,
            )
          : Image.file(File(image!.path));
    } else {
      return Container(
        color: Colors.grey[200],
        height: 40,
        width: 40,
        child: const Icon(Icons.camera_alt),
      );
    }
  }

  Future<void> getImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = pickedFile;
      }
    });
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
                  const Column(
                    children: <Widget>[
                      SizedBox(height: 60.0),
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
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
                          GestureDetector(
                            onTap: getImage,
                            child: _buildImage(),
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
                              prefixIcon: const Icon(Icons.email),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            onSaved: (value) {
                              _company = value ?? '';
                            },
                            validator: (service) {
                              if (service?.isEmpty ?? true) {
                                return "Please enter your company name";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "company",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.blue.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.shop_outlined),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            onSaved: (value) {
                              _service = value ?? '';
                            },
                            validator: (service) {
                              if (service?.isEmpty ?? true) {
                                return "Please enter your service";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Service",
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
                            MaterialPageRoute(
                                builder: (context) => const Login1()),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
