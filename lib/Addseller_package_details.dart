import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/sellerdashboard.dart';
import 'dart:io' show File;

class Addseller_package_details extends StatefulWidget {
  @override
  _AddsellerdetailsState createState() => _AddsellerdetailsState();
}

class _AddsellerdetailsState extends State<Addseller_package_details> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _packageName = TextEditingController();
  final _description = TextEditingController();
  bool isLoading = false;

  XFile? image;

  Future<void> _Add_package() async {
    try {
      setState(() {
        isLoading = true;
      });
      // Get the current user
      User? seller = FirebaseAuth.instance.currentUser;

      // Fetch the current seller data
      DocumentSnapshot sellerSnapshot = await FirebaseFirestore.instance
          .collection("seller_details")
          .doc(seller?.uid)
          .get();

      if (sellerSnapshot.exists) {
        Map<String, dynamic> sellerData =
            sellerSnapshot.data() as Map<String, dynamic>;

        // Get the list of existing package names
        List<dynamic>? packageDetails = sellerData['packageDetails'];
        List<String> existingPackageNames = [];

        if (packageDetails != null) {
          existingPackageNames = List<String>.from(packageDetails.map(
              (package) => package['packagename'] != null
                  ? package['packagename']
                  : ''));
        }

        // Check if the new package name already exists
        if (existingPackageNames.contains(_packageName.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Package is already in the list."),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Upload image to Firebase Storage
        String imageUrl = await uploadImageToFirebaseStorage();

        // Create package details map
        Map<String, dynamic> newPackageDetails = {
          'packagename': _packageName.text,
          'imageUrl': imageUrl,
          'description': _description.text,
        };

        // Update Firestore document with the new package
        await FirebaseFirestore.instance
            .collection('seller_details')
            .doc(seller?.uid)
            .update({
          'packageDetails': FieldValue.arrayUnion([newPackageDetails])
        });

        // Save user details to Firestore along with the image URL
        await FirebaseFirestore.instance
            .collection('seller_package_details')
            .doc(seller?.uid)
            .set({
          'packagename': _packageName.text,
          'imageUrl': imageUrl,
          'description': _description.text,
        });

        // Navigate to the seller dashboard page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => sellerDashboard()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Add_package error: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
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
        Reference referenceDirImages = referenceRoot.child('package_images');
        Reference referenceImageToUpload =
            referenceDirImages.child(uniqueFileName);

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => sellerDashboard()),
            );
          },
        ),
        title: Text('Add Details'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey, // Add this line to assign the formKey to the Form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text field for package name
              TextFormField(
                controller: _packageName,
                validator: (package) {
                  if (package?.isEmpty ?? true) {
                    return "Please enter your package name";
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Package Name'),
              ),
              SizedBox(height: 16),
              // Image picker for getting the image
              GestureDetector(
                onTap: getImage,
                child: _buildImage(),
              ),
              SizedBox(height: 16),
              // Text field for paragraph
              TextFormField(
                controller: _description,
                validator: (description) {
                  if (description?.isEmpty ?? true) {
                    return "Please enter your short description about your package";
                  }
                  return null;
                },
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              // Button to submit the form
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState != null &&
                        formKey.currentState!.validate()) {
                      _Add_package();
                    }
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[100],
                  ),
                ),
              ),
              SizedBox(height: 10),
              isLoading
                  ? Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          color: Color(0xFF207D4A),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
