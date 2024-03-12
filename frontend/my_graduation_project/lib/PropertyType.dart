import 'package:flutter/material.dart';

import 'PropertySize.dart';

class PropertyTypePage extends StatefulWidget {
  @override
  _PropertyTypePageState createState() => _PropertyTypePageState();
}

class _PropertyTypePageState extends State<PropertyTypePage> {
  String selectedPropertyType = '';
  int numberOfRooms = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Property'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Property Type:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              _buildPropertyTypeTile('Flat', Icons.home),
              _buildPropertyTypeTile('House', Icons.house),
              _buildPropertyTypeTile('Room', Icons.bed),
              if (selectedPropertyType != 'Room' || numberOfRooms > 0)
                _buildNumberOfRoomsField(),
              SizedBox(height: 350.0),
              ElevatedButton(
                onPressed: () {
                  if (selectedPropertyType.isNotEmpty) {
                    print('Selected Property Type: $selectedPropertyType');
                    if (selectedPropertyType == 'Room' && numberOfRooms > 0) {
                      print('Number of Rooms: $numberOfRooms');
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertySizePage(
                          selectedPropertyType: selectedPropertyType,
                        ),
                      ),
                    );
                  } else {
                    print('Please select a property type');
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

  Widget _buildPropertyTypeTile(String value, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        value,
        style: TextStyle(fontSize: 18),
      ),
      tileColor: selectedPropertyType == value ? Colors.grey[300] : null,
      onTap: () {
        setState(() {
          selectedPropertyType = value;
          if (selectedPropertyType != 'Room') {
            // Reset number of rooms if property type is not 'Room'
            numberOfRooms = 0;
          }
        });
      },
    );
  }

  Widget _buildNumberOfRoomsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter the number of rooms:',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        TextFormField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              numberOfRooms = int.tryParse(value) ?? 0;
            });
          },
          decoration: InputDecoration(
            labelText: 'Number of Rooms',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
