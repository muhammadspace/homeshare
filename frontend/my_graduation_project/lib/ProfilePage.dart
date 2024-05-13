import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_graduation_project/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'userata.dart';
import 'editprofile.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final dynamic token;
  final String id;

  ProfilePage({required this.id, required this.token});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String name = '';
  String email ='';
  String DOB = '';
  String job = '';
  String gender = '';
  String type = '';
  String hobbies ='';
  String sports ='' ;
  String cultural ='';
  String intellectual ='' ;
  String personality_trait = '';
  String value_belief = '';
  String interpersonal_skill= '';
  String work_ethic='';
  String formattedDate = '';
  String apt_location ='', apt_id = '', apt_type = '', apt_start ='', apt_end='' ;
  int apt_max = 0, apt_price = 0, apt_bedrooms = 0, apt_bathrooms = 0;
  List<dynamic> apt_residents = [], apt_invites = [];

  Future<void> fetchUserData() async {
    final String idt = widget.id;
    final apiUrl = 'https://homeshare-o76b.onrender.com/user/$idt'; // Replace with your actual API URL

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
        DOB = jsonRes['dob'];
        name = jsonRes['username'];
        email = jsonRes['email'];
        job = jsonRes['job'];
        gender = jsonRes['gender'];
        type = jsonRes['type'];
        hobbies = jsonRes['hobbies_pastimes'];
        sports = jsonRes['sports_activities'];
        cultural = jsonRes['cultural_artistic'];
        intellectual = jsonRes['intellectual_academic'];
        DateTime date = DateTime.parse(DOB);
        var formatter = DateFormat('yyyy-MM-dd');
        formattedDate = formatter.format(date);
        personality_trait = jsonRes['personality_trait'];
        value_belief = jsonRes['value_belief'];
        interpersonal_skill = jsonRes['interpersonal_skill'];
        work_ethic = jsonRes['work_ethic'];

      });
      if (type == 'owner') {
        fetchaptData();
      }
      print('name: $name, DOB: $DOB');
      print(response.body);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  Future<void> fetchaptData() async {
    final String idt = widget.id;
    final apiUrl = 'https://homeshare-o76b.onrender.com/apt/$idt'; // Corrected API URL

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
        apt_location = jsonResponse['location'];
        apt_bathrooms = jsonResponse['bathrooms'];
        apt_bedrooms = jsonResponse['bedrooms'];
        apt_id = jsonResponse['_id'];
        apt_end = jsonResponse['end_date'];
        apt_start = jsonResponse['start_date'];
        apt_max = jsonResponse['max'];
        apt_price = jsonResponse['price'];
        apt_invites = jsonResponse['invites'];
        apt_residents = jsonResponse['residents'];
        apt_type = jsonResponse['property_type'];
      });
      print('apt_id: $apt_id, location: $apt_location');
      print(response.body);
    } else {
      throw Exception('Failed to fetch apartment data');
    }
  }


  @override

  void initState() {
    super.initState();
    fetchUserData();//.then((_) {
      /*if(type=='owner')
        fetchaptData();
    });*/
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
        personality_trait : personality_trait,
        value_belief : value_belief,
        interpersonal_skill : interpersonal_skill,
        work_ethic : work_ethic,
      )),
    );
    // Handle the result returned from the edit page
    if (result == true) {
      // Refresh the user data
      fetchUserData();//.then((_) {
       /* if(type=='owner')
          fetchaptData();
      });*/
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                  buildInfoRow(Icons.cake, 'Date of Birth: $formattedDate', fontSizeInfo, Colors.white),
                  //buildInfoRow(Icons.phone, 'Phone Number: 123-456-7890', fontSizeInfo, Colors.white),
                  buildInfoRow(Icons.email, '$email', fontSizeInfo, Colors.white),

                  // New information fields
                  buildInfoRow(Icons.person, 'Gender: $gender', fontSizeInfo, Colors.white),
                  buildInfoRow(Icons.label, 'Type: $type', fontSizeInfo, Colors.white),
                  buildInfoRow(Icons.sports_football, 'Hobbies Pastimes: $hobbies', fontSizeInfo, Colors.white),
                  buildInfoRow(Icons.sports_soccer, 'Sports Activities: $sports', fontSizeInfo, Colors.white),
                  buildInfoRow(Icons.palette, 'Cultural Artistic: $cultural', fontSizeInfo, Colors.white),
                  buildInfoRow(Icons.book, 'Intellectual Academic: $intellectual', fontSizeInfo, Colors.white),


                  buildInfoRow(Icons.label, 'personality trait: $personality_trait', fontSizeInfo, Colors.white),
                  buildInfoRow(Icons.label, 'work ethic: $work_ethic', fontSizeInfo, Colors.white),
                  buildInfoRow(Icons.label, 'value belief: $value_belief', fontSizeInfo, Colors.white),
                  buildInfoRow(Icons.label, 'interpersonal skill: $interpersonal_skill', fontSizeInfo, Colors.white),

                  if(type == 'owner')...[
                    buildInfoRow(
                        Icons.label, 'aprtment bathrooms: $apt_bathrooms',
                        fontSizeInfo, Colors.white),
                    buildInfoRow(
                        Icons.label, 'apt_bedrooms: $apt_bedrooms', fontSizeInfo,
                        Colors.white),
                    buildInfoRow(Icons.label, 'apt_max: $apt_max', fontSizeInfo,
                        Colors.white),
                    buildInfoRow(Icons.label, 'apt_type: $apt_type', fontSizeInfo,
                        Colors.white),

                    buildInfoRow(
                        Icons.label, 'apt_location: $apt_location', fontSizeInfo,
                        Colors.white),
                  ],
                  // buildInfoRow(Icons.label, 'Sports Activities: $apt_residents', fontSizeInfo, Colors.white),
                  //buildInfoRow(Icons.label, 'Cultural Artistic: $apt_invites', fontSizeInfo, Colors.white),
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
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, color: color),
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }}
