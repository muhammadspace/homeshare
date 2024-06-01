import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_graduation_project/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'userata.dart';
import 'editprofile.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';

class ProfilePage extends StatefulWidget {
  final dynamic token;
  final String id;

  ProfilePage({required this.id, required this.token});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  String job='';
  String formattedDate = '';
  String gender = '';
  String type = '';
  String pictureData = '';
  String hobbies = '';
  String sports = '';
  String cultural = '';
  String intellectual = '';
  String personality_trait = '';
  String value_belief = '';
  String interpersonal_skill = '';
  String work_ethic = '';
  Uint8List? imageBytes;

  Future<void> _retrieveImage(String imageId) async {
    String url = getimageurl + imageId ; // Replace with your server URL
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          imageBytes = response.bodyBytes;
        });
      } else {
        print('Retrieve failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> fetchUserData() async {
    final String idt = widget.id;
    final apiUrl = profiledataurl2 + idt; // Replace with your actual API URL

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final jsonRes = json.decode(response.body);
      setState(() {
        name = jsonRes['username'];
        email = jsonRes['email'];
        gender = jsonRes['gender'];
        job=jsonRes['job'];
        type = jsonRes['type'];
        hobbies = jsonRes['hobbies_pastimes'];
        sports = jsonRes['sports_activities'];
        cultural = jsonRes['cultural_artistic'];
        intellectual = jsonRes['intellectual_academic'];
        personality_trait = jsonRes['personality_trait'];
        value_belief = jsonRes['value_belief'];
        interpersonal_skill = jsonRes['interpersonal_skill'];
        work_ethic = jsonRes['work_ethic'];
        if (jsonRes['dob'] is String) {
          try {
            DateTime date = DateTime.parse(jsonRes['dob']);
            formattedDate = DateFormat('yyyy-MM-dd').format(date);
          } catch (e) {
            formattedDate = jsonRes['dob'];
          }
        } else if (jsonRes['dob'] is DateTime) {
          formattedDate = DateFormat('yyyy-MM-dd').format(jsonRes['dob']);
        }
         pictureData = jsonRes['picture'];
        //_retrieveImage("pictureData");
        if (pictureData != null) {
          _retrieveImage(pictureData);
        } else {
          imageBytes = null;
        }
      });
      print('name: $name, DOB: $formattedDate');
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
      MaterialPageRoute(builder: (context) => ProfileEditPage(
        id: widget.id,
        token: widget.token,
        name: name,
        email: email,
        DOB: formattedDate,
        job: job,
        gender: gender,
        type: type,
        hobbies: hobbies,
        sports: sports,
        cultural: cultural,
        intellectual: intellectual,
        personality_trait: personality_trait,
        value_belief: value_belief,
        interpersonal_skill: interpersonal_skill,
        work_ethic: work_ethic,
      )),
    );

    if (result == true) {
      fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: ListView(
        children: [
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
                    radius: 50.0,
                    backgroundImage: imageBytes != null
                        ? MemoryImage(imageBytes!)
                        : NetworkImage('https://cdn-icons-png.flaticon.com/512/147/147140.png') as ImageProvider,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '$name',
                    style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8.0),
                  buildInfoRow(Icons.cake, 'Date of Birth: $formattedDate', 20.0, Colors.white),
                  buildInfoRow(Icons.email, '$email', 20.0, Colors.white),
                  buildInfoRow(Icons.person, 'Gender: $gender', 20.0, Colors.white),
                  buildInfoRow(Icons.label, 'Type: $type', 20.0, Colors.white),
                  buildInfoRow(Icons.label, 'Job: $job', 20.0, Colors.white),
                  buildInfoRow(Icons.sports_football, 'Hobbies Pastimes: $hobbies', 20.0, Colors.white),
                  buildInfoRow(Icons.sports_soccer, 'Sports Activities: $sports', 20.0, Colors.white),
                  buildInfoRow(Icons.palette, 'Cultural Artistic: $cultural', 20.0, Colors.white),
                  buildInfoRow(Icons.book, 'Intellectual Academic: $intellectual', 20.0, Colors.white),
                  buildInfoRow(Icons.label, 'Personality Trait: $personality_trait', 20.0, Colors.white),
                  buildInfoRow(Icons.label, 'Work Ethic: $work_ethic', 20.0, Colors.white),
                  buildInfoRow(Icons.label, 'Value Belief: $value_belief', 20.0, Colors.white),
                  buildInfoRow(Icons.label, 'Interpersonal Skill: $interpersonal_skill', 20.0, Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: screenWidth,
        height: 60.0,
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
              Text('Edit Profile', style: TextStyle(fontSize: 20)),
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
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, color: color),
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }
}

