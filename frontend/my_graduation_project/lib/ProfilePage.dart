import 'package:flutter/material.dart';
import 'package:my_graduation_project/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'userata.dart';
import 'editprofile.dart';

class ProfilePage extends StatelessWidget {

  String name ,DOB ,job,gender ,type ;
  List<dynamic> interests , traits ;
  final token;



  ProfilePage({required this.name, required this.DOB , required this.job,required this.type,required this.traits,required this.gender,required this.interests,required this.token});

  /*void loginUser(String userid) async {
    final response = await http.post(
      Uri.parse(profileuri),
      body: json.encode({
        'id': userid,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    var jsonResponse = jsonDecode(response.body);
    if(jsonResponse['status']){
      var name = jsonResponse['name'];
      var number = jsonResponse['number'];
      var age = jsonResponse['age'];
      //var name = jsonResponse['name'];
    }
  }*/

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
          onPressed: () {

            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
          },
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
