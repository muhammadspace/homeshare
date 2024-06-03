import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:my_graduation_project/aptmodel.dart';
import 'RoommatePreferencePage.dart';
import 'dart:io';
import 'home.dart';

class RentPropertyPage extends StatefulWidget {
  final String selectedPropertyType;
  final int numberofrooms;
  final String numberofbeds;
  final String size;
  final String address;
  final String rentType;
  final String price;
  final id, token;
  final String contract_id;
  List<String> apt_images_id = [];

  @override
  RentPropertyPage({
    required this.selectedPropertyType,
    required this.numberofrooms,
    required this.numberofbeds,
    required this.size,
    required this.address,
    required this.rentType,
    required this.price,
    required this.id,
    required this.token,
    required this.contract_id,
    required this.apt_images_id
  });

  _RentPropertyPageState createState() => _RentPropertyPageState();
}

class _RentPropertyPageState extends State<RentPropertyPage> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate ?? DateTime.now() : endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Rent Property',
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
                  'https://static.vecteezy.com/system/resources/previews/030/314/140/non_2x/house-model-on-wood-table-real-estate-agent-offer-house-property-insurance-vertical-mobile-wallpaper-ai-generated-free-photo.jpg',
                ),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Text(
                  'Select Rent Duration:',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                if (startDate != null)
                  Text(
                    'Start Date: ${DateFormat('yyyy/MM/dd').format(startDate!)}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                SizedBox(height: 20.0),
                ElevatedButton.icon(
                  onPressed: () => _selectDate(context, true),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(24.0),
                  ),
                  icon: Icon(Icons.date_range, size: 24.0),
                  label: Text(
                    'Select Start Date',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                SizedBox(height: 20.0),
                if (endDate != null)
                  Text(
                    'End Date: ${DateFormat('yyyy/MM/dd').format(endDate!)}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                SizedBox(height: 20.0),
                ElevatedButton.icon(
                  onPressed: () => _selectDate(context, false),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(24.0),
                  ),
                  icon: Icon(Icons.date_range, size: 24.0),
                  label: Text(
                    'Select End Date',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final int rentprice = int.parse(widget.price);
                      final int numbeds = int.parse(widget.numberofbeds);

                      createapt(widget.id, widget.address, rentprice, numbeds, widget.numberofrooms, 2,
                        '$startDate', '$endDate', widget.selectedPropertyType,);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(id: widget.id, Token: widget.token),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 22.0),
                      backgroundColor: Colors.orange,
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 24),
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