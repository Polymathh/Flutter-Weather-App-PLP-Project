import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/material.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  final TextEditingController _numberOfBedroomController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceRangeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? searchResult;

  // Function to search and retrieve data from Firebase Firestore
  Future<void> _searchHouse() async {
    String bedrooms = _numberOfBedroomController.text;
    String location = _locationController.text;
    String price = _priceRangeController.text;

    // Querying Firestore to find matching properties
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('properties')
          .where('numberOfBedrooms', isEqualTo: bedrooms)
          .where('location', isEqualTo: location)
          .where('price', isEqualTo: price)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Format and display the first matching property found
        Map<String, dynamic> houseData = snapshot.docs.first.data() as Map<String, dynamic>;
        String displayData = '''
          House Found:
          - Bedrooms: ${houseData['numberOfBedrooms']} 
          - Location: ${houseData['location']}
          - Price: ${houseData['price']}
          - Image URL: ${houseData['imageUrl']}
        ''';
        setState(() {
          searchResult = displayData;
        });
      } else {
        setState(() {
          searchResult = 'No house found with the given criteria.';
        });
      }
    } catch (e) {
      setState(() {
        searchResult = 'Error fetching data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Describe Your Home',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView( // Wrap the form in a scrollable widget
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Search for a Home',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Bedrooms Input Field
                TextFormField(
                  controller: _numberOfBedroomController,
                  decoration: InputDecoration(
                    labelText: 'Number of Bedrooms',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Location Input Field
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Price Range Input Field
                TextFormField(
                  controller: _priceRangeController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Elevated Button for Search
                ElevatedButton(
                  onPressed: () {
                    // Test the button with a simple print statement
                    print('Search button clicked');
                    _searchHouse(); // Call search function
                  },
                  child: Text('Search House'),
                ),

                SizedBox(height: 20),

                // Displaying search result
                if (searchResult != null)
                  Text(
                    searchResult!,
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
