import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Edit_Buyerprof.dart';
import 'package:mobile_app/food_buyerpack.dart';
import 'package:mobile_app/login1.dart';

class buyer_dashboard extends StatefulWidget {
  List imgdata = [
    "assets/food.jpg",
    "assets/food.jpg",
    "assets/food.jpg",
    "assets/food.jpg"
  ];
  List titles = ["Food", "Decoration", "Beautician", "Photographer"];

  @override
  State<buyer_dashboard> createState() => _buyer_dashboardState();
}

class _buyer_dashboardState extends State<buyer_dashboard> {
  late double height, width; // Declare height and width here
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final buyer = FirebaseAuth.instance.currentUser!;
  TextEditingController _userNameController = TextEditingController();

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
        });
      }
    } catch (e) {
      print('Error fetching buyer data: $e');
    }
  }

  Future<bool?> _applyConfirmationlogoutbuyer(BuildContext context) async {
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            color: Colors.indigo,
            width: width,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(),
                  height: height * 0.25,
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 35,
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Open drawer when logo is pressed
                                _scaffoldKey.currentState?.openEndDrawer();
                              },
                              child: Container(
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
                            ),
                            SizedBox(width: 5),
                            Container(
                              // Adjust the width as needed
                              child: Text(
                                _userNameController.text,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Happy Event",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    width: width,
                    padding: EdgeInsets.only(bottom: 20),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.1,
                        mainAxisSpacing: 25,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.imgdata.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Check the index and navigate accordingly
                            switch (index) {
                              case 0:
                                // Navigate to the first page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => food_buyerpack(),
                                  ),
                                );
                                break;
                              case 1:
                                // Navigate to the second page

                                break;
                              case 2:
                                // Navigate to the third page

                                break;
                              case 3:
                                // Navigate to the fourth page

                                break;
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 6,
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  widget.imgdata[index],
                                  width: 100,
                                ),
                                Text(
                                  widget.titles[index],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        endDrawer: Drawer(
          // Drawer on the right side
          child: Container(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 100, // Adjust the height of DrawerHeader
                  decoration: BoxDecoration(
                    color: Colors.indigoAccent,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
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
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        //  width: 100, // Adjust the width as needed
                        child: Builder(
                          builder: (context) => MouseRegion(
                            child: Text(
                              _userNameController.text,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
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
                    // Add your logic for when Item 1 is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Edit_Buyerprof()),
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
                        await _applyConfirmationlogoutbuyer(context);

                    if (confirmEdit != null && confirmEdit) {
                      // Handle the tap event, for example, navigate to a new page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login1()),
                      );
                    }
                  },
                ),
                // Add more ListTile items as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Placeholder classes for pages
