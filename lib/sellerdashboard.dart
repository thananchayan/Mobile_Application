import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Addsellerdetails.dart';
import 'package:mobile_app/Edit_seller%20profile.dart';
import 'package:mobile_app/Editsellerdetails.dart';
import 'package:mobile_app/login1.dart';

class WidgetModel {
  String title;

  WidgetModel({required this.title});

  Map<String, dynamic> toMap() {
    return {'title': title};
  }
}

class sellerDashboard extends StatefulWidget {
  @override
  State<sellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<sellerDashboard> {
  List<WidgetModel> widgets = [
    WidgetModel(title: "Briyani"),
    WidgetModel(title: "Fried Rice"),
    WidgetModel(title: "Dolphin"),
    WidgetModel(title: "Photographer"),
  ];

  WidgetModel? selectedWidget;

  final seller = FirebaseAuth.instance.currentUser!;
  TextEditingController _companyNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSellerData();
  }

  Future<void> fetchSellerData() async {
    try {
      DocumentSnapshot sellerSnapshot = await FirebaseFirestore.instance
          .collection("seller_details")
          .doc(seller.uid)
          .get();

      if (sellerSnapshot.exists) {
        Map<String, dynamic> sellerData =
            sellerSnapshot.data() as Map<String, dynamic>;

        print('Seller Data: $sellerData');

        setState(() {
          _companyNameController.text = sellerData['company'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching buyer data: $e');
    }
  }

  Future<bool?> _applyConfirmationlogoutseller(BuildContext context) async {
    bool? exitApp = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Really??"),
          content: const Text("Are you want to Logout?"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Addsellerdetails()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteSelectedWidget();
            },
          ),
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              if (selectedWidget != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Editsellerdetails()),
                );
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.indigoAccent,
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage("assets/logo.png"),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      //  width: 100, // Adjust the width as needed
                      child: Builder(
                        builder: (context) => MouseRegion(
                          child: Text(
                            _companyNameController.text,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "logged in",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Edit_seller_profie(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () async {
                  bool? confirmEdit =
                      await _applyConfirmationlogoutseller(context);

                  if (confirmEdit != null && confirmEdit) {
                    // Handle the tap event, for example, navigate to a new page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login1()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widgets.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedWidget = widgets[index];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: selectedWidget == widgets[index]
                        ? Colors.blue
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        color: Colors.black26,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widgets[index].title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: selectedWidget == widgets[index]
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void deleteSelectedWidget() {
    if (selectedWidget != null) {
      setState(() {
        widgets.remove(selectedWidget);
        selectedWidget = null;
      });
    }
  }
}
