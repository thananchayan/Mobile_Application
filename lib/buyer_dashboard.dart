import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Edit_Buyerprof.dart';
import 'package:mobile_app/food_buyerpack.dart';
import 'package:mobile_app/login1.dart';

class buyer_dashboard extends StatefulWidget {
  List<String> titles = ["Food", "Decorations", "Beautician", "Photographer"];
  List<String> imgdata = [
    "assets/food.jpg",
    "assets/deco.jpg",
    "assets/beauty.jpg",
    "assets/photo.jpg",
  ];

  @override
  State<buyer_dashboard> createState() => _buyer_dashboardState();
}

class _buyer_dashboardState extends State<buyer_dashboard> {
  late double height, width;
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

  void _navigateToFoodBuyerPack(String service) async {
    List<String> imgdata = [];
    List<String> company_names = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("seller_details")
          .where("service", isEqualTo: service)
          .get();

      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data();
        imgdata.add(data['imageUrl'] ?? '');
        company_names.add(data['company'] ?? '');
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => food_buyerpack(imgdata, company_names),
        ),
      );
    } catch (e) {
      print('Error fetching seller data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.indigo,
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
                  iconSize: 30,
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
              Expanded(
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
                    itemCount: widget.titles.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          _navigateToFoodBuyerPack(widget.titles[index]);
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
                                widget.imgdata.length > index
                                    ? widget.imgdata[index]
                                    : '',
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
    );
  }
}
