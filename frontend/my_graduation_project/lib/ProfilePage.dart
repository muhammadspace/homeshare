import 'package:flutter/material.dart';
import 'package:my_graduation_project/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'userata.dart';
import 'editprofile.dart';


class ProfilePage extends StatefulWidget {
  final dynamic token;
  final Map<String, dynamic> id;

  ProfilePage({required this.id, required this.token});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String name = '';
  String DOB = '';
  String job = '';
  String gender = '';
  String type = '';
  String hobbies ='';
  String sports ='' ;
  String cultural ='';
  String intellectual ='' ;

  Future<void> fetchUserData() async {
    final String idt = widget.id["id"];
    final apiUrl = 'http://192.168.1.8:3000/user/$idt'; // Replace with your actual API URL

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        DOB = jsonResponse['dob'];
        name = jsonResponse['username'];
      });
      print('name: $name, DOB: $DOB');
      print(response.body);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage(token: widget.token)),
    );

    // Handle the result returned from the edit page
    if (result == true) {
      // Refresh the user data
      fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Values for consistent styling
    const double avatarRadius = 50.0;
    const double fontSizeTitle = 32.0;
    const double fontSizeInfo = 20.0;
    const double buttonHeight = 60.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: ListView(
        children: [
          // Upper part of the profile
          Card(
            color: Colors.blue,
            elevation: 8.0,
            margin: EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/147/147140.png'),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '$name',
                    style: TextStyle(fontSize: fontSizeTitle, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8.0),
                  buildInfoRow(Icons.cake, 'Date of Birth: $DOB', fontSizeInfo, Colors.white),
                  buildInfoRow(Icons.phone, 'Phone Number: 123-456-7890', fontSizeInfo, Colors.white),
                  buildInfoRow(Icons.email, 'Email: user@example.com', fontSizeInfo, Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: screenWidth,
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: navigateToEditProfile,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            backgroundColor: Colors.orange,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, size: 24),
              SizedBox(width: 8),
              Text(
                'Edit Profile',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String text, double fontSize, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        SizedBox(width: 8.0),
        Text(
          text,
          style: TextStyle(fontSize: fontSize, color: color),
        ),
      ],
    );
  }
}