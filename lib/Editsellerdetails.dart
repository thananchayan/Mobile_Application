import 'package:flutter/material.dart';
import 'package:mobile_app/sellerdashboard.dart';

class Editsellerdetails extends StatefulWidget {
  @override
  _EditsellerdetailsState createState() => _EditsellerdetailsState();
}

class _EditsellerdetailsState extends State<Editsellerdetails> {
  // Define controllers for text fields
  TextEditingController packageNameController = TextEditingController();
  TextEditingController paragraphController = TextEditingController();

  // Function to handle image selection
  Future<void> pickImage() async {
    // Implement your image picking logic here
    // For example, you can use ImagePicker package
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
            // Add functionality to go back
          },
        ),
        title: Text('Edit details'),
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
                onTap: () {
                  pickImage();
                },
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: Center(
                    child: Icon(Icons.add_a_photo),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Text field for paragraph
              TextFormField(
                controller: paragraphController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Paragraph'),
              ),
              SizedBox(height: 16),
              // Add a button to submit the form
              ElevatedButton(
                onPressed: () {
                  // Add functionality to submit the form
                  // You can access the values using packageNameController.text
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
}
