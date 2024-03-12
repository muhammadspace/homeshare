import 'package:flutter/material.dart';
import 'selectGender.dart';

class JobSelectionPage extends StatefulWidget {
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildJobSelection(),

              if (selectedJob == 'Other') buildOtherJobTextField(),

              SizedBox(height: 300.0),

              ElevatedButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenderSelectionPage()),
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
            ],
          ),
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: 20.0),
        // Job RadioButtons
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
        ),
        Icon(icon),
        SizedBox(width: 8.0),
        Text(value),
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
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}