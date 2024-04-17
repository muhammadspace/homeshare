import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_graduation_project/userata.dart';
import 'PropertyType.dart';
import 'preference.dart';
import 'ProfilePage.dart'; // Import the ProfilePage
import 'package:jwt_decoder/jwt_decoder.dart';
import 'userata.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

//class HomeScreen extends StatefulWidget {
  class HomeScreen extends StatelessWidget {
    final Token;
    final id;
    String name = '';
    String DOB = '';
    String job = '';
    List<String> interests = [];
    String gender = '';
    String type = '';
    List<String> traits = [];



   HomeScreen({required this.Token, required this.id});

     /*data() async {

      try {
        final String userData = await userdata(Token, id);

        // Split the userData string into individual parts
        final List<String> userDataParts = userData.split(',');

        // Declare variables

        // Extract values from userDataParts and assign them to variables
        for (var part in userDataParts) {
          final List<String> keyValue = part.split(':');
          final String key = keyValue[0].trim();
          final String value = keyValue[1].trim();

          if (key == 'name') {
            name = value;
          } else if (key == 'DOB') {
            DOB = value;
          } else if (key == 'job') {
            job = value;
          } else if (key == 'intrests') {
            interests = value.split(';').map((e) => e.trim()).toList();
          } else if (key == 'gender') {
            gender = value;
          } else if (key == 'type') {
            type = value;
          } else if (key == 'traits') {
            traits = value.split(';').map((e) => e.trim()).toList();
          }
        }

        // Use the assigned variables as needed
        print('Name: $name');
        print('DOB: $DOB');
        print('Job: $job');
        print('Interests: $interests');
        print('Gender: $gender');
        print('Type: $type');
        print('Traits: $traits');
      } catch (e) {
        print('Error: $e');
      }
    }
*/
  /*@override
  State<HomeScreen> createState() => _HomeScreen();
}
class _HomeScreen extends State<HomeScreen>{
  late String id;
  void initState(){
    super.initState();
    Map<String,dynamic>JWTdecodertoken=JwtDecoder.decode(widget.token);
    id = JWTdecodertoken['_id'];
  }*/
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
            onPressed: () {
              /*// Handle "Profile" button click
              //var (name,DOB,job,intrests,gender,type,traits)=
              data();
              //userdata(Token,id);
              //final username = name;
              //final String username= await userdata(Token, id);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(name:name,DOB:DOB)),
                );*/
             /* userdata(Token, id).then((result){
                name = result['name'];
                DOB = result['DOB'];
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(name:name,DOB:DOB)),
                );
              });*/
              /*userdata(Token, id).then((result) {
                final Map<String, dynamic> jsonResponse = JwtDecoder.decode(result);

                name = jsonResponse['name'];
                DOB = jsonResponse['DOB'];

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(name: name, DOB: DOB)),
                );
              });*/
              userdata(Token, id);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(name: name, DOB: DOB)),
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
