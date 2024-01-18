import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'buyer_dashboard.dart';

class Edit_Buyerprof extends StatefulWidget {
  const Edit_Buyerprof({Key? key});

  @override
  State<Edit_Buyerprof> createState() => _Edit_BuyerprofState();
}

class _Edit_BuyerprofState extends State<Edit_Buyerprof> {
  final buyer = FirebaseAuth.instance.currentUser!;
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBuyerData();
  }

  Future<void> fetchBuyerData() async {
    try {
      DocumentSnapshot buyerSnapshot = await FirebaseFirestore.instance
          .collection("buyer_details")
          .doc(buyer.uid)
          .get();

      if (buyerSnapshot.exists) {
        Map<String, dynamic> buyerData =
            buyerSnapshot.data() as Map<String, dynamic>;

        print('Buyer Data: $buyerData');

        setState(() {
          _userNameController.text = buyerData['username'] ?? '';
          _contactNumberController.text = buyerData['contactno'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching buyer data: $e');
    }
  }

  Future<bool?> _applyConfirmationedituser(BuildContext context) async {
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

  Future<void> _updateBuyerProfile() async {
    try {
      await FirebaseFirestore.instance
          .collection("buyer_details")
          .doc(buyer.uid)
          .update({
        'username': _userNameController.text,
        'contactno': _contactNumberController.text,
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
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => buyer_dashboard()),
                );
              },
              child: Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          body: SingleChildScrollView(
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
                        "Edit Account",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: _userNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.blue.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _contactNumberController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.blue.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.phone),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          child: ElevatedButton(
                            onPressed: () async {
                              bool? confirmEdit =
                                  await _applyConfirmationedituser(context);

                              if (confirmEdit != null && confirmEdit) {
                                // User confirmed the edit, proceed with updating the profile
                                _updateBuyerProfile();

                                // Handle the tap event, for example, navigate to a new page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => buyer_dashboard()),
                                );
                              }
                            },
                            child: const Text(
                              "Accept to Edit",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
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
