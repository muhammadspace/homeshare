import 'package:flutter/material.dart';
import 'selectGender.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class JobSelectionPage extends StatefulWidget {
  final String username, email, password;
  final DateTime? dob;
  final String image;

  JobSelectionPage({
    Key? key,
    required this.username,
    required this.email,
    required this.password,
    required this.image,
    required this.dob,
  }) : super(key: key);

  @override
  _JobSelectionPageState createState() => _JobSelectionPageState();
}

class _JobSelectionPageState extends State<JobSelectionPage> {
  String selectedJob = '';
  TextEditingController otherJobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complete Your Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: kToolbarHeight + 40),
                  buildJobSelection(),
                  if (selectedJob == 'Other') buildOtherJobTextField(),
                  SizedBox(height: 20.0),
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
                          builder: (context) => GenderSelectionPage(
                            username: widget.username,
                            email: widget.email,
                            password: widget.password,
                            image: widget.image,
                            dob: widget.dob,
                            job: selectedJob,
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
                      style: TextStyle(fontSize: 18),
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

  Widget buildJobSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Select Your Job',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        SizedBox(height: 20.0),
        buildJobRadioButton('Software Engineer', Icons.code),
        buildJobRadioButton('Teacher', Icons.school),
        buildJobRadioButton('Doctor', Icons.local_hospital),
        buildJobRadioButton('Designer', Icons.palette),
        buildJobRadioButton('Salesperson', Icons.shopping_cart),
        buildJobRadioButton('Other', Icons.work),
      ],
    );
  }

  Widget buildJobRadioButton(String value, IconData icon) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: selectedJob,
          onChanged: (String? newValue) {
            setState(() {
              selectedJob = newValue!;
            });
          },
          activeColor: Colors.orange,
        ),
        Icon(icon, color: Colors.white),
        SizedBox(width: 8.0),
        Text(value, style: TextStyle(fontSize: 18, color: Colors.white)),
      ],
    );
  }

  Widget buildOtherJobTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20.0),
        TextField(
          controller: otherJobController,
          decoration: InputDecoration(
            labelText: 'Enter Your Job',
            labelStyle: TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}