import 'package:flutter/material.dart';
import 'package:mobile_app/Order.dart';

class FoodPackageMore extends StatefulWidget {
  const FoodPackageMore({Key? key}) : super(key: key);

  @override
  _FoodPackageMoreState createState() => _FoodPackageMoreState();
}

class _FoodPackageMoreState extends State<FoodPackageMore> {
  final double _price =
      10.0; // Initial price, you can set it based on your needs

  bool _buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Package description"),
          backgroundColor: Colors.indigo, // Set app bar color to indigo
          elevation: 0, // Remove app bar shadow
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          toolbarHeight: 70, // Set the desired height
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF87CEEB),
                  Colors.white
                ], // Light Blue to White
              ),
            ),
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
                      image: const DecorationImage(
                        image: AssetImage("assets/briyani1.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.indigo,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'In the heart of the bustling city, nestled between the lively streets and vibrant storefronts, lies a charming food shop that captivates the senses of passersby...',
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Change color to pink on first press
                          setState(() {
                            _buttonPressed = true;
                          });

                          // Delay the navigation by 200 milliseconds
                          Future.delayed(Duration(milliseconds: 200), () {
                            // Navigate to the Order page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Order()),
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          primary: _buttonPressed ? Colors.pink : Colors.blue,
                        ),
                        child: Text(
                          'Order',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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
