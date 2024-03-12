import 'package:flutter/material.dart';
import 'InterestsPage.dart';
import 'PriceRangePage.dart';
class PreferencePage extends StatefulWidget {
  @override
  _PreferencePageState createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  String? selectedPreference;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Preference'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Choose how you want to search for properties:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          _buildPreferenceButton('By Price', Icons.attach_money, Colors.orange),
          _buildPreferenceButton('By Location', Icons.location_on, Colors.orange),
          _buildPreferenceButton('By Interests', Icons.favorite, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildPreferenceButton(String preference, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedPreference = preference;
          });

          if (preference == 'By Price') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PriceRangePage()),
            );
          } else if (preference == 'By Location') {

          } else if (preference == 'By Interests') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InterestsPage()),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(24),
          backgroundColor: selectedPreference == preference
              ? Colors.blue[300]
              : color,
          minimumSize: Size(double.infinity, 80),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 30),
                SizedBox(width: 12),
                Text(
                  preference,
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
