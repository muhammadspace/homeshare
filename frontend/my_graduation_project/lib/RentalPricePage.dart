import 'package:flutter/material.dart';
import 'RentAvailabilityPage.dart';
import 'dart:io';

class RentalPricePage extends StatefulWidget {
  final String selectedPropertyType;
  final int numberofrooms;
  final String numberofbeds;
  final String size;
  final String address;
  final id, token;
  final String contract_id;
  List<String> apt_images_id = [];

  @override
  RentalPricePage({
    required this.selectedPropertyType,
    required this.numberofrooms,
    required this.numberofbeds,
    required this.size,
    required this.address,
    required this.id,
    required this.token,
    required this.apt_images_id,
    required this.contract_id
  });

  _RentalPricePageState createState() => _RentalPricePageState();
}

class _RentalPricePageState extends State<RentalPricePage> {
  String rentType = '';
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Rental Price',
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 100),
                Text(
                  'Select Rental Type:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                buildRentTypeRadio('Daily', Icons.calendar_today),
                buildRentTypeRadio('Monthly', Icons.calendar_view_month),
                SizedBox(height: 20),
                Text(
                  'Enter Price:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter the rental price',
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
                Spacer(),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (rentType.isNotEmpty && priceController.text.isNotEmpty) {
                        print('Selected Rent Type: $rentType');
                        print('Entered Price: ${priceController.text}');
                        String price = priceController.text;

                        // Navigate to RentPropertyPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RentPropertyPage(
                              selectedPropertyType: widget.selectedPropertyType,
                              numberofrooms: widget.numberofrooms,
                              numberofbeds: widget.numberofbeds,
                              size: widget.size,
                              contract_id: widget.contract_id,
                              apt_images_id: widget.apt_images_id,
                              address: widget.address,
                              rentType: rentType,
                              price: price,
                              id: widget.id,
                              token: widget.token,
                            ),
                          ),
                        );
                      } else {
                        print('Please select rent type and enter the price');
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

  Widget buildRentTypeRadio(String value, IconData icon) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: rentType,
          onChanged: (String? newValue) {
            setState(() {
              rentType = newValue!;
            });
          },
        ),
        Icon(icon, color: Colors.white),
        SizedBox(width: 10),
        Text(
          value,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }
}