import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'job.dart';

class RegisterPage extends StatefulWidget {
  String username , email , password;
  String image;
  RegisterPage({Key? key,required this.username,required this.email,required this.password,required this.image}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complete Your Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),

            buildDateOfBirth(),

            SizedBox(height: 500.0),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JobSelectionPage(username: widget.username, email: widget.email, password: widget.password,image: widget.image ,dob:selectedDate)),
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

            // Add a SizedBox for spacing
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget buildDateOfBirth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Date of Birth',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 20.0),
        ElevatedButton.icon(
          onPressed: () => _selectDate(context),
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
          ),
          icon: Icon(Icons.calendar_today, size: 24),
          label: Text(
            selectedDate != null
                ? formatDate(selectedDate!)
                : 'Select Date',
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
