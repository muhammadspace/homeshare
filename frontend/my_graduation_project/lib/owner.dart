import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'ChoseCharacterTraitsPage.dart';

class ProfileCompletionPage extends StatefulWidget {
  final String username, email, password, job, gender;
  final DateTime? dob;
  final String image;
  ProfileCompletionPage(
      {Key? key,
        required this.username,
        required this.email,
        required this.password,
        required this.image,
        required this.dob,
        required this.job,
        required this.gender})
      : super(key: key);
  @override
  _ProfileCompletionPageState createState() => _ProfileCompletionPageState();
}

class _ProfileCompletionPageState extends State<ProfileCompletionPage> {
  String userType = '';

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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://static.vecteezy.com/system/resources/previews/030/314/140/non_2x/house-model-on-wood-table-real-estate-agent-offer-house-property-insurance-vertical-mobile-wallpaper-ai-generated-free-photo.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: kToolbarHeight + 20), // Space for AppBar
                buildUserTypeSelection(),
                Spacer(),
                Container(
                  width: double.infinity, // Full width button
                  child: ElevatedButton(
                    onPressed: () {
                      if (userType.isNotEmpty) {
                        print('User type selected: $userType');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseCharacterTraitsPage(
                                  username: widget.username,
                                  email: widget.email,
                                  password: widget.password,
                                  image: widget.image,
                                  dob: widget.dob,
                                  job: widget.job,
                                  gender: widget.gender,
                                  type: userType)),
                        );
                      } else {
                        print('Please select your user type');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.orange,
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Space below the button
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Are you a property owner or a home seeker?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black,
                offset: Offset(5.0, 5.0),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.0),
        buildUserTypeRadioButton('Owner', Icons.home),
        buildUserTypeRadioButton('Seeker', Icons.search),
      ],
    );
  }

  Widget buildUserTypeRadioButton(String value, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Radio(
            value: value.toLowerCase(),
            groupValue: userType,
            onChanged: (String? newValue) {
              setState(() {
                userType = newValue!;
              });
            },
          ),
          Icon(icon, size: 30, color: Colors.orange),
          SizedBox(width: 12.0),
          Text(value, style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}