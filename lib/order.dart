import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  TextEditingController addressController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Information",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // backgroundColor: Color(0xFF87CEEB),
        backgroundColor: Colors.indigo[900], // ,Soft Sky Blue
        elevation: 0, // Remove the shadow
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFAEE0FF),
              Color(0xFFFFFFFF)
            ], // Gradient from Sky Blue to White
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Address:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    hintText: "Enter your address",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Date:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      hintText: "Select date",
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dateController.text,
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _validateAndConfirmOrder();
                  },
                  child: Text("Confirm"),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFF69B4), // Hot Pink
                    onPrimary: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
        )) ??
        DateTime.now();

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void _validateAndConfirmOrder() {
    if (_formKey.currentState!.validate()) {
      if (dateController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select a date."),
          ),
        );
      } else {
        _showConfirmationDialog();
      }
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Do you want to confirm the order?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _performConfirmationAction();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void _performConfirmationAction() {
    // Add your logic for what should happen when the user confirms the order
    String address = addressController.text;
    String date = dateController.text;

    // Display a confirmation message
    _showConfirmationMessage();

    // You can use the collected information as needed (e.g., send to a server, store locally, etc.)
    print("Address: $address");
    print("Date: $date");
  }

  void _showConfirmationMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Thank you for your order! The seller will contact you within 30 minutes.",
        ),
        duration: Duration(seconds: 5), // Adjust the duration as needed
      ),
    );
  }
}
