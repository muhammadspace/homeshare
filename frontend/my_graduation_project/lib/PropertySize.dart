import 'package:flutter/material.dart';
import 'PropertyImagesPage.dart';

class PropertySizePage extends StatefulWidget {
  final String selectedPropertyType;
  final int numberofrooms;

  PropertySizePage({required this.selectedPropertyType,required this.numberofrooms});

  @override
  _PropertySizePageState createState() => _PropertySizePageState();
}

class _PropertySizePageState extends State<PropertySizePage> {
  TextEditingController sizeController = TextEditingController();
  TextEditingController bedsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Property Size'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Selected Property Type: ${widget.selectedPropertyType}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: sizeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter Property Size',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'm²',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Enter the Number of Beds in the Property:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: bedsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of Beds',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 450.0),
              ElevatedButton(
                onPressed: () {
                  // Validate and process the property size and number of beds
                  String propertySize = sizeController.text.toString();
                  String numberOfBeds = bedsController.text;

                  if (propertySize.isNotEmpty && numberOfBeds.isNotEmpty) {
                    print('Property Size: $propertySize m²');
                    print('Number of Beds: $numberOfBeds');

                    // Continue to the next page (PropertyImagesPage in this case)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyImagesPage(selectedPropertyType: widget.selectedPropertyType,
                          numberofrooms: widget.numberofrooms,numberofbeds:numberOfBeds,size:propertySize),
                      ),
                    );
                  } else {
                    print('Please enter both property size and number of beds');
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
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
        ),
      ),
    );
  }
}
