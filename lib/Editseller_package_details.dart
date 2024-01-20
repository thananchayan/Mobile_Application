import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/sellerdashboard.dart';

class Editseller_package_details extends StatefulWidget {
  final WidgetModel? packageDetails;

  Editseller_package_details({Key? key, required this.packageDetails})
      : super(key: key);

  @override
  _EditsellerdetailsState createState() => _EditsellerdetailsState();
}

class _EditsellerdetailsState extends State<Editseller_package_details> {
  // Define controllers for text fields
  TextEditingController packageNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Set initial values in controllers based on packageDetails
    if (widget.packageDetails != null) {
      packageNameController.text = widget.packageDetails!.title;
      // Set other controller values as needed
    }
  }

  // Function to handle image selection
  Future<void> pickImage() async {
    // Implement your image picking logic here
    // For example, you can use ImagePicker package
  }

  // Function to update package details in Firestore
  Future<void> updatePackageDetails() async {
    try {
      setState(() {
        isLoading = true;
      });
      User? seller = FirebaseAuth.instance.currentUser;

      if (seller != null && widget.packageDetails != null) {
        String packageId = widget.packageDetails!.title;

        // Update the package details in Firestore
        await FirebaseFirestore.instance
            .collection('seller_details')
            .doc(seller.uid)
            .update({
          'packageDetails': FieldValue.arrayRemove([
            {'packagename': packageId},
          ]),
        });

        await FirebaseFirestore.instance
            .collection('seller_details')
            .doc(seller.uid)
            .update({
          'packageDetails': FieldValue.arrayUnion([
            {'packagename': packageNameController.text},
          ]),
        });

        // Navigate back to the seller dashboard page
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => sellerDashboard()),
        );
      }
    } catch (e) {
      print('Error updating package details: $e');
      // Handle the error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => sellerDashboard()),
            );
          },
        ),
        title: const Text('Edit details'),
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
                decoration: const InputDecoration(labelText: 'Package Name'),
              ),
              const SizedBox(height: 16),
              // Image picker for getting the image
              GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: const Center(
                    child: Icon(Icons.add_a_photo),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Text field for paragraph
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Paragraph'),
              ),
              SizedBox(height: 16),
              // Add a button to submit the form
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    updatePackageDetails();
                  },
                  child: Text('Submit'),
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
