import 'package:flutter/material.dart';

class FoodPackageMore extends StatefulWidget {
  @override
  _FoodPackageMoreState createState() => _FoodPackageMoreState();
}

class _FoodPackageMoreState extends State<FoodPackageMore> {
  double _price = 10.0; // Initial price, you can set it based on your needs

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Package description"),
          backgroundColor: Colors.indigo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          toolbarHeight: 70, // Set the desired height
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage("assets/briyani1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5, // Set the elevation for the shadow
                  margin: EdgeInsets.all(10), // Add margin to the Card
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.indigo, // Set border color to indigo
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(
                              0.5), // Set shadow color to indigo with opacity
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // Set shadow offset
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'In the heart of the bustling city, nestled between the lively streets and vibrant storefronts, lies a charming food shop that captivates the senses of passersby. Its inviting facade boasts an array of colors, from the warm, earthy tones of rustic wooden panels to the lively hues of fresh produce showcased in baskets near the entrance. The tantalizing aroma of freshly baked bread and aromatic spices permeates the air', // Replace with your food description
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "1500.00/per",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
