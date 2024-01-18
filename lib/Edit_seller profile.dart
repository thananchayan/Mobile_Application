import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/sellerdashboard.dart';

class Edit_seller_profie extends StatefulWidget {
  const Edit_seller_profie({super.key});

  @override
  State<Edit_seller_profie> createState() => _Edit_seller_profieState();
}

class _Edit_seller_profieState extends State<Edit_seller_profie> {
  final seller = FirebaseAuth.instance.currentUser!;
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _serviceController = TextEditingController();
  //TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchsellerData();
  }

  Future<void> fetchsellerData() async {
    try {
      DocumentSnapshot buyerSnapshot = await FirebaseFirestore.instance
          .collection("seller_details")
          .doc(seller.uid)
          .get();

      if (buyerSnapshot.exists) {
        Map<String, dynamic> sellerData =
            buyerSnapshot.data() as Map<String, dynamic>;

        print('seller Data: $sellerData');

        setState(() {
          _companyNameController.text = sellerData['company'] ?? '';
          _contactNumberController.text = sellerData['contactno'] ?? '';
          _serviceController.text = sellerData['service'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching buyer data: $e');
    }
  }

  Future<bool?> _applyConfirmationeditseller(BuildContext context) async {
    bool? exitApp = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Really??"),
          content: const Text("Are you want to Edit?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    return exitApp ?? false;
  }

  Future<void> _updatesellerProfile() async {
    try {
      await FirebaseFirestore.instance
          .collection("seller_details")
          .doc(seller.uid)
          .update({
        'company': _companyNameController.text,
        'contactno': _contactNumberController.text,
        'service': _serviceController.text,
      });

      // Show a success message or navigate to another screen if needed
    } catch (e) {
      print('Error updating buyer profile: $e');
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
                MaterialPageRoute(builder: (context) => sellerDashboard()),
              );
            },
            child: Icon(
              Icons.arrow_back, // add custom icons also
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            // height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 60.0),
                    const Text(
                      "Edit Account",
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
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        TextField(
                          controller: _companyNameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.blue.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.shop)),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _serviceController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.blue.withOpacity(0.1),
                            filled: true,
                            prefixIcon:
                                const Icon(Icons.medical_services_outlined),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _contactNumberController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.blue.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.phone)),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          child: ElevatedButton(
                            onPressed: () async {
                              bool? confirmEdit =
                                  await _applyConfirmationeditseller(context);

                              if (confirmEdit != null && confirmEdit) {
                                // User confirmed the edit, proceed with updating the profile
                                _updatesellerProfile();

                                // Handle the tap event, for example, navigate to a new page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => sellerDashboard()),
                                );
                              }
                            },
                            child: const Text(
                              "Submit",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              backgroundColor: Colors.blue[900],
                            ),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
