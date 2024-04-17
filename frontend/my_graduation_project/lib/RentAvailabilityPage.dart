import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:my_graduation_project/aptmodel.dart';
import 'RoommatePreferencePage.dart';
import 'dart:io';

class RentPropertyPage extends StatefulWidget {
  final String selectedPropertyType;
  final int numberofrooms;
  final String numberofbeds;
  final String size;
  final List<File> images;
  final String address;
  final String rentType;
  final String price;
  @override
  RentPropertyPage({required this.selectedPropertyType,required this.numberofrooms,required this.numberofbeds,required this.size,required this.images,required this.address,required this.rentType,required this.price});
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
      appBar: AppBar(
        title: Text('Rent Property'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select Rent Duration:',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              if (startDate != null)
                Text(
                  'Start Date: ${DateFormat('yyyy/MM/dd').format(startDate!)}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
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
              SizedBox(height: 350.0),
              SizedBox(
                width: double.infinity, // Make the button take the full width
                child: ElevatedButton(
                  onPressed: () {
                    // Your logic for the Continue button
                    final int rentprice = int.parse(widget.price);
                    final int numbeds = int.parse(widget.numberofbeds);
                    //createapt(id,widget.address, rentprice, max:numbeds, rooms:widget.numberofrooms, bedrooms:numbeds, bathrooms'2','true',true);
                    createapt('661e130eba33d86fd2793ca0',widget.address,rentprice,numbeds,widget.numberofrooms,numbeds,2, true, true);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoommatePreferencePage(),
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
      ),
    );
  }
}
