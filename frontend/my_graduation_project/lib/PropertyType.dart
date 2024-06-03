import 'package:flutter/material.dart';
import 'PropertySize.dart';

class PropertyTypePage extends StatefulWidget {
  final id, token;
  PropertyTypePage({required this.id, required this.token});
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
        title: Text(
          'Add Property',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // تحديد لون الرموز داخل ال AppBar
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://static.vecteezy.com/system/resources/previews/030/314/140/non_2x/house-model-on-wood-table-real-estate-agent-offer-house-property-insurance-vertical-mobile-wallpaper-ai-generated-free-photo.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPropertyTypeTile('Flat', Icons.home),
                    _buildPropertyTypeTile('House', Icons.house),
                    _buildPropertyTypeTile('Room', Icons.bed),
                    if (selectedPropertyType != 'Room' || numberOfRooms > 0)
                      _buildNumberOfRoomsField(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: ElevatedButton(
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
                            numberofrooms: numberOfRooms,
                            id: widget.id,
                            token: widget.token),
                      ),
                    );
                  } else {
                    print('Please select a property type');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  textStyle: TextStyle(fontSize: 24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyTypeTile(String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, size: 36, color: Colors.white), // تغيير لون الرموز هنا
      title: Text(
        value,
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
      onTap: () {
        setState(() {
          selectedPropertyType = value;
          if (selectedPropertyType != 'Room') {
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
        SizedBox(height: 20),
        Text(
          'Enter the number of rooms:',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              numberOfRooms = int.tryParse(value) ?? 0;
            });
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Number of Rooms',
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}