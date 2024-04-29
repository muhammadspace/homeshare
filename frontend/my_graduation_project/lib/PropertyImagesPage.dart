import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'PropertyAddressPage.dart';

class PropertyImagesPage extends StatefulWidget {
  final String selectedPropertyType;
  final int numberofrooms;
  final String numberofbeds;
  final String size;
  final id;
  @override
  PropertyImagesPage({required this.selectedPropertyType,required this.numberofrooms,required this.numberofbeds,required this.size,required this.id});
  _PropertyImagesPageState createState() => _PropertyImagesPageState();
}

class _PropertyImagesPageState extends State<PropertyImagesPage> {
  List<File> propertyImages = [];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          propertyImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Images'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: propertyImages.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 200.0,
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(propertyImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Choose Image',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyAddressPage(selectedPropertyType: widget.selectedPropertyType,
                        numberofrooms: widget.numberofrooms,numberofbeds:widget.numberofbeds,size:widget.size,images:propertyImages,id:widget.id),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                backgroundColor: Colors.orange,
              ),
              child: Text(
                'Continue',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
