import 'package:flutter/material.dart';
import 'RentalPricePage.dart';
import 'dart:io';

class PropertyAddressPage extends StatefulWidget {
  final String selectedPropertyType;
  final int numberofrooms;
  final String numberofbeds;
  final String size;
  final List<File> images;
  final id;
  @override
  PropertyAddressPage({required this.selectedPropertyType,required this.numberofrooms,required this.numberofbeds,required this.size,required this.images,required this.id});
  _PropertyAddressPageState createState() => _PropertyAddressPageState();
}

class _PropertyAddressPageState extends State<PropertyAddressPage> {
  Map<String, TextEditingController> controllers = {
    'Country': TextEditingController(),
    'Governorate': TextEditingController(),
    'City': TextEditingController(),
    'Street': TextEditingController(),
    'Building Number': TextEditingController(),
    'Floor Number': TextEditingController(),
    'Apartment Number': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Address'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Enter Property Address:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 10),
          Column(
            children: controllers.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  controller: entry.value,
                  decoration: InputDecoration(
                    hintText: entry.key,
                    border: OutlineInputBorder(),
                  ),
                ),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () {
              String fullAddress = controllers.entries
                  .map((entry) => '${entry.key}: ${entry.value.text}')
                  .join(', ');

              if (fullAddress.isNotEmpty) {
                print('Full Address: $fullAddress');
                // Navigate to RentalPricePage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RentalPricePage(selectedPropertyType: widget.selectedPropertyType,
                        numberofrooms: widget.numberofrooms,numberofbeds:widget.numberofbeds,size:widget.size,images:widget.images,address:fullAddress,id:widget.id),
                  ),
                );
              } else {
                print('Please enter the complete address');
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.orange,
            ),
            child: Text(
              'Continue',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
