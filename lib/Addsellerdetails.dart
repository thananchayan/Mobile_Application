import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/sellerdashboard.dart';

class Addsellerdetails extends StatefulWidget {
  @override
  _AddsellerdetailsState createState() => _AddsellerdetailsState();
}

class _AddsellerdetailsState extends State<Addsellerdetails> {
  // Controllers for text fields
  final TextEditingController packageNameController = TextEditingController();
  final TextEditingController paragraphController = TextEditingController();

  // Function to handle image selection
  Future<void> pickImage() async {
    // Implement your image picking logic here
    // For example, you can use the ImagePicker package
    // Remember to handle errors and provide user feedback
  }
  XFile? image;

  @override
  void dispose() {
    packageNameController.dispose();
    paragraphController.dispose();
    super.dispose();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text field for package name
              TextFormField(
                controller: packageNameController,
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
                controller: paragraphController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              // Button to submit the form
              ElevatedButton(
                onPressed: () {
                  // Add functionality to submit the form
                  // Access values using packageNameController.text
                  // and paragraphController.text
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (image != null) {
      return kIsWeb
          ? Image.network(
              image!.path,
              height: 100,
              width: 100,
            )
          : Image.file(File(image!.path));
    } else {
      return Container(
        color: Colors.grey[200],
        height: 100,
        width: 100,
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
}
