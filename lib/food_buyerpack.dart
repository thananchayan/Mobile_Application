import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Edit_Buyerprof.dart';
import 'package:mobile_app/food_company_packages.dart';
import 'package:mobile_app/login1.dart';

class food_buyerpack extends StatefulWidget {
  List imgdata = [
    "assets/food.jpg",
    "assets/food.jpg",
    "assets/food.jpg",
    "assets/food.jpg",
    "assets/food.jpg"
  ];
  List titles = ["Hajiar", "gadabi", "Thaj", "Moulavi", "Moulavi"];
  List ratings = [5.0, 4.0, 3.0, 3.5, 4.0];

  @override
  State<food_buyerpack> createState() => _food_buyerpackState();
}

class _food_buyerpackState extends State<food_buyerpack> {
  late double height, width; // Declare height and width here

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
        body: Container(
          color: Colors.indigo, // Change the background color to indigo
          width: width,
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  iconSize: 30, // Adjust the size as needed
                ),
              ),
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
                              // Open drawer when the logo is pressed
                              // _scaffoldKey.currentState?.openEndDrawer();
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
                            "Companies",
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
                          // Text(
                          //   "Last update aug 07",
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     color: Colors.white54,
                          //     letterSpacing: 1,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
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
                            switch (index) {
                              case 0:
                                // Navigate to the first page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        food_company_packages(),
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
                                StarRating(rating: widget.ratings[index]),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;

  StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    int numberOfFullStars = rating.floor();
    int numberOfHalfStars = ((rating - numberOfFullStars) * 2).round();

    return Row(
      children: List.generate(
            numberOfFullStars,
            (index) => Icon(
              Icons.star,
              color: Colors.yellow,
            ),
          ) +
          List.generate(
            numberOfHalfStars,
            (index) => Icon(
              Icons.star_half,
              color: Colors.yellow,
            ),
          ),
    );
  }
}
