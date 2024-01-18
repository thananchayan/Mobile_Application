import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/ask_signup.dart';
import 'package:mobile_app/sellerdashboard.dart';
import 'buyer_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login1 extends StatefulWidget {
  const Login1({Key? key}) : super(key: key);

  @override
  State<Login1> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login1> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _email = '', _password = '';

  void signIn(BuildContext context) async {
    try {
      UserCredential authUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);

      // User successfully signed in. Identify whether the user is a seller or buyer.
      String user = await checkUserType(authUser.user?.uid);

      // Navigate to the appropriate dashboard
      if (user == 'seller') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => sellerDashboard(),
          ),
        );
      }
      if (user == 'buyer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => buyer_dashboard(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle authentication errors
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User not found. Please check your email."),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Incorrect password. Please try again."),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An error occurred. Please try again later."),
          ),
        );
      }
    }
  }

  Future<String> checkUserType(String? uid) async {
    try {
      // Check if the 'seller_details' collection has a document with the provided UID
      DocumentSnapshot sellerSnapshot = await FirebaseFirestore.instance
          .collection("seller_details")
          .doc(uid)
          .get();

      // Check if the 'buyer_details' collection has a document with the provided UID
      DocumentSnapshot buyerSnapshot = await FirebaseFirestore.instance
          .collection("buyer_details")
          .doc(uid)
          .get();

      // Return "seller" if the document exists in 'seller_details'
      if (sellerSnapshot.exists) {
        return 'seller';
      }
      // Return "buyer" if the document exists in 'buyer_details'
      else if (buyerSnapshot.exists) {
        return 'buyer';
      } else {
        // If neither seller nor buyer document exists, you may handle this case
        // Maybe return a default value or throw an exception based on your needs
        return 'unknown';
      }
    } catch (e) {
      // Handle any errors (e.g., network issues, permission denied)
      print('Error checking user type: $e');
      return 'error';
    }
  }

  void navigateToPasswordReset(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordReset()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/logo.png"),
                      ),
                    ),
                  ),
                  _inputField(context),
                  _forgotPassword(context),
                  _signup(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Form(
          key: formKey, // Associate the formKey with the Form widget
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                onSaved: (value) {
                  _email = value ?? '';
                },
                validator: (email) {
                  if (email?.isEmpty ?? true) {
                    return "Please enter Email";
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(email!)) return "It's not a valid Email";
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.blueAccent.withOpacity(0.1),
                  filled: true,
                  prefixIcon: const Icon(Icons.person),
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
                      (password?.length ?? 0) > 15)
                    return "Password length should be between 4 and 15";

                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.blueAccent.withOpacity(0.1),
                  filled: true,
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate()) {
                    formKey.currentState?.save();
                    signIn(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue[900],
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _forgotPassword(BuildContext context) {
    return TextButton(
      onPressed: () {
        navigateToPasswordReset(context);
      },
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AskSignup()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      // Password reset email sent successfully.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password reset email sent. Check your inbox."),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Handle password reset errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password reset error: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Password Reset"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/password_reset_image.png', // Add your image path
            //   height: 150,
            // ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_emailController.text.isNotEmpty) {
                  _resetPassword();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter your email."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 20), // Increased vertical padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                backgroundColor: Colors.blue, // Button color
              ),
              child: const Text(
                "Reset Password",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white), // Adjust font size if needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Login1(),
  ));
}
