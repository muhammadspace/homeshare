import 'package:flutter/material.dart';
import 'RentalPricePage.dart';

class PropertyAddressPage extends StatefulWidget {
  @override
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
                    builder: (context) => RentalPricePage(),
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
