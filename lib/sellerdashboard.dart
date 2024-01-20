import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Addseller_package_details.dart';
import 'package:mobile_app/Edit_seller%20profile.dart';
import 'package:mobile_app/Editseller_package_details.dart';
import 'package:mobile_app/login1.dart';

class WidgetModel {
  String title;

  WidgetModel({required this.title});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }
}

class sellerDashboard extends StatefulWidget {
  @override
  State<sellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<sellerDashboard> {
  List<WidgetModel> widgets = [];
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

          // Clear the existing widgets
          widgets.clear();

          // Add package names to the widgets list
          List<dynamic>? packageDetails = sellerData['packageDetails'];
          if (packageDetails != null) {
            for (var package in packageDetails) {
              widgets.add(WidgetModel(title: package['packagename'] ?? ''));
            }
          }

          print('Widgets: $widgets');
        });
      }
    } catch (e) {
      print('Error fetching seller data: $e');
    }
  }

  Future<bool?> _applyConfirmationlogoutseller(BuildContext context) async {
    bool? exitApp = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout!"),
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

  Future<bool?> _applyConfirmationdeletepackage(BuildContext context) async {
    bool? exitApp = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirm Delete",
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
          content: const Text("Are you want to Delete this package?"),
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
        title: Container(
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
        // SizedBox(width: 5),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Addseller_package_details()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool? confirmdeletepackage =
                  await _applyConfirmationdeletepackage(context);

              if (confirmdeletepackage != null && confirmdeletepackage) {
                deleteSelectedWidget();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              if (selectedWidget == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please select a package to edit'),
                  ),
                );
                return;
              }
              if (selectedWidget != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Editseller_package_details(
                          packageDetails: selectedWidget)),
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
          color: Colors.grey[200],
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

  void deleteSelectedWidget() async {
    if (selectedWidget != null) {
      try {
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

          // Find the package to be deleted in the packageDetails list
          List<dynamic>? packageDetails = sellerData['packageDetails'];
          if (packageDetails != null) {
            var packageToRemove = packageDetails.firstWhere(
                (package) => package['packagename'] == selectedWidget!.title,
                orElse: () => null);

            // Remove the package from the list
            if (packageToRemove != null) {
              packageDetails.remove(packageToRemove);

              // Update the Firestore document
              await FirebaseFirestore.instance
                  .collection('seller_details')
                  .doc(seller?.uid)
                  .update({'packageDetails': packageDetails});
            }
          }
        }

        // Remove the widget from the UI
        setState(() {
          widgets.remove(selectedWidget);
          selectedWidget = null;
        });
      } catch (e) {
        print('Error deleting package: $e');
      }
    }
  }
}
