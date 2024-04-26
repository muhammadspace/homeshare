
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_graduation_project/userata.dart';
import 'PropertyType.dart';
import 'preference.dart';
import 'ProfilePage.dart'; // Import the ProfilePage
import 'package:jwt_decoder/jwt_decoder.dart';
import 'userata.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//class HomeScreen extends StatefulWidget {
class HomeScreen extends StatelessWidget {
  final Token;
  final id;
  String name = '';
  String DOB = '';
  String job = '';
  List<dynamic> interests = [];
  String gender = '';
  String type = '';
  List<dynamic> traits = [];



  HomeScreen({required this.Token, required this.id});

  Future<void> userdata(String token, Map<String, dynamic> id) async {
    //void userdata(String token, Map<String, dynamic> id) async {

    final String idt = id["id"] ;
    //final String tokent = token["token"];
    final apiUrl = 'http://192.168.1.8:3000/user/$idt' ; // Replace with your actual API URL
    //final dataurl = userdataurl + '$idt' ;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json',
        'authorization':'Bearer $token'},
      //body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final  result = response.body;
      final jsonResponse = json.decode(result);
       DOB = jsonResponse['dob'];
       name = jsonResponse['username'] ;
       job = jsonResponse['job'];
       gender = jsonResponse['gender'];
       type = jsonResponse['type'] ;
      interests = jsonResponse['interests'];
      traits = jsonResponse['traits'] ;
      print('name:$name,DOB:$DOB,interests:$interests');
      print(response.body);

      //return result;
      //,intrests:$intrests,traits:$traits
    } else {
      throw Exception('cant get the data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Elghool',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Billabong',
            fontSize: 32.0,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () async{
              await userdata(Token, id);
              Navigator.push(
                context ,
                MaterialPageRoute(builder: (context) => ProfilePage(name:'$name', DOB: DOB,job: job,gender: gender,type: type,interests: interests,traits:traits,token:Token )),
              );

            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              // Handle "Add" button click
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PropertyTypePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              minimumSize: Size(double.infinity, 0), // Set the width to the screen width
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 24, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Post Your Advertisement',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Handle "Search" button click
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PreferencePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              minimumSize: Size(double.infinity, 0), // Set the width to the screen width
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 24, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Search for Property',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Notifications',
          ),
        ],
        onTap: (int index) {
          if (index == 2) {
            // Handle notifications tab click
          }
        },
      ),
    );
  }
}
