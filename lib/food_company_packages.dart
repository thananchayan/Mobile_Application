import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Edit_Buyerprof.dart';
import 'package:mobile_app/food_package_more.dart';
import 'package:mobile_app/login1.dart';

class food_company_packages extends StatefulWidget {
  List imgdata = [
    "assets/food.jpg",
    "assets/food.jpg",
    "assets/food.jpg",
    "assets/food.jpg",
    "assets/food.jpg"
  ];
  List titles = [
    "Briyani",
    "Fried Rice",
    "Dolphin",
    "Photographer",
    "Photographer"
  ];

  @override
  State<food_company_packages> createState() => _food_company_packagesState();
}

class _food_company_packagesState extends State<food_company_packages> {
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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: height * 0.25,
                floating: false,
                pinned: true,
                backgroundColor: Colors.indigo, // Change the color to indigo
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
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
                                // Open drawer when the logo is pressed
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
                              // width: 100, // Adjust the width as needed
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
                              "Company Packages",
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
                            Text(
                              "Last update aug 07",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white54,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 0.9,
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
                                  builder: (context) => FoodPackageMore(),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
