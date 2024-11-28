import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SellPage extends StatefulWidget {
  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  XFile? _imageFile; 
  String? numberOfBedrooms;
  String? location;
  String? price;

  // pick an image
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  // uploading image to Firebase Storage 
  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('properties/${DateTime.now().toString()}');

      // Create the upload task
      UploadTask uploadTask = ref.putData(await _imageFile!.readAsBytes());

      // Listen to the upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print('Upload Progress: ${snapshot.bytesTransferred} of ${snapshot.totalBytes} bytes ($progress%)');
      });

      // Wait for the upload to complete
      await uploadTask;

      print('Image uploaded successfully');
    } catch (e) {
      print('Image upload error: $e');
    }
  }

  // Submit property details to Firestore
  Future<void> _submitProperty() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Upload image
      await _uploadImage();

      // Save property details to Firestore without image URL
      try {
        await FirebaseFirestore.instance.collection('properties').add({
          'numberOfBedrooms': numberOfBedrooms,
          'location': location,
          'price': price,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Property posted successfully!')),
        );

        // Clear the form after submission
        _formKey.currentState!.reset();
        setState(() {
          _imageFile = null; // Reset image
        });
      } catch (e) {
        print('Error adding property: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error posting property.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell/Lease House'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imageFile == null
                      ? Center(child: Text('Tap to add an image'))
                      : Center(child: Text('Image selected')),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Number of Bedrooms',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
                onSaved: (value) {
                  numberOfBedrooms = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of bedrooms';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
                onSaved: (value) {
                  location = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
                onSaved: (value) {
                  price = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitProperty,
                child: Text('Post Property'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
