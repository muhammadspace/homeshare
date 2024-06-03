import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'owner.dart';

class GenderSelectionPage extends StatefulWidget {
  final String username, email, password, job;
  final DateTime? dob;
  final String image;

  GenderSelectionPage({
    Key? key,
    required this.username,
    required this.email,
    required this.password,
    required this.image,
    required this.dob,
    required this.job,
  }) : super(key: key);

  @override
  _GenderSelectionPageState createState() => _GenderSelectionPageState();
}

class _GenderSelectionPageState extends State<GenderSelectionPage> {
  String selectedGender = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complete Your Profile',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://static.vecteezy.com/system/resources/previews/030/314/140/non_2x/house-model-on-wood-table-real-estate-agent-offer-house-property-insurance-vertical-mobile-wallpaper-ai-generated-free-photo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: kToolbarHeight + 40),
                  buildGenderSelection(),
                  SizedBox(height: 450.0),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                widthFactor: 1.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileCompletionPage(
                            username: widget.username,
                            email: widget.email,
                            password: widget.password,
                            image: widget.image,
                            dob: widget.dob,
                            job: widget.job,
                            gender: selectedGender,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.orange,
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Select Your Gender',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        SizedBox(height: 20.0),
        buildGenderRadioButton('Male', Icons.male),
        buildGenderRadioButton('Female', Icons.female),
        buildGenderRadioButton('Other', Icons.person),
      ],
    );
  }

  Widget buildGenderRadioButton(String value, IconData icon) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: selectedGender,
          onChanged: (String? newValue) {
            setState(() {
              selectedGender = newValue!;
            });
          },
          activeColor: Colors.orange,
        ),
        Icon(icon, size: 30, color: Colors.white),
        SizedBox(width: 12.0),
        Text(value, style: TextStyle(fontSize: 20, color: Colors.white)),
      ],
    );
  }
}