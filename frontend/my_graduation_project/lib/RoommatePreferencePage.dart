import 'package:flutter/material.dart';
import 'CharacterTraitsPage.dart';
import 'Interests.dart';

class RoommatePreferencePage extends StatefulWidget {
  @override
  _RoommatePreferencePageState createState() =>
      _RoommatePreferencePageState();
}

class _RoommatePreferencePageState extends State<RoommatePreferencePage> {
  String selectedPreference = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roommate Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Would you like to choose your roommate / flatmates based on:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            _buildPreferenceButton('Interests', Icons.favorite),
            _buildPreferenceButton('Character Traits', Icons.person),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceButton(String preference, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedPreference = preference;
          });

          if (preference == 'Interests') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => YourInterestsPage(),
              ),
            );
          } else if (preference == 'Character Traits') {
            // إضافة الملاحظات: تأكد من استيراد CharacterTraitsPage في الأعلى
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CharacterTraitsPage(),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.all(16),
          backgroundColor: selectedPreference == preference
              ? Colors.blue[300]
              : Colors.orange,
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
                  style: TextStyle(fontSize: 18),
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
