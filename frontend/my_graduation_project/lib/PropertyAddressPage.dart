import 'package:flutter/material.dart';
import 'RentalPricePage.dart';
import 'dart:io';

class PropertyAddressPage extends StatefulWidget {
  final String selectedPropertyType;
  final int numberofrooms;
  final String numberofbeds;
  final String size;
  final id, token;
  final String contract_id;
  List<String> apt_images_id = [];
  @override
  PropertyAddressPage({
    required this.selectedPropertyType,
    required this.numberofrooms,
    required this.numberofbeds,
    required this.size,
    required this.id,
    required this.token,
    required this.apt_images_id,
    required this.contract_id
  });
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Property Address',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://static.vecteezy.com/system/resources/previews/030/314/140/non_2x/house-model-on-wood-table-real-estate-agent-offer-house-property-insurance-vertical-mobile-wallpaper-ai-generated-free-photo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 100),
                Text(
                  'Enter Property Address:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: controllers.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextField(
                          controller: entry.value,
                          decoration: InputDecoration(
                            hintText: entry.key,
                            hintStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
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
                            builder: (context) => RentalPricePage(
                                selectedPropertyType: widget.selectedPropertyType,
                                numberofrooms: widget.numberofrooms,
                                numberofbeds: widget.numberofbeds,
                                size: widget.size,
                                contract_id: widget.contract_id,
                                apt_images_id: widget.apt_images_id,
                                address: fullAddress,
                                id: widget.id,
                                token: widget.token),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}