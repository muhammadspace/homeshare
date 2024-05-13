import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_graduation_project/recommendation%20search.dart';
import 'dart:convert';
import 'package:my_graduation_project/userata.dart';
import 'PropertyType.dart';
import 'preference.dart';
import 'ProfilePage.dart';
import 'TopRecommendationsPage.dart';
import 'notification.dart';
import 'saved.dart';
import 'recommendationsystem.dart';

class HomeScreen extends StatefulWidget {
  final String Token;
  final String id;

  HomeScreen({required this.Token, required this.id});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String type = '';
  List<dynamic> invitesids = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final String idt = widget.id;
    final typeurl = 'https://homeshare-o76b.onrender.com/user/$idt';
    try {
      final response = await http.get(
        Uri.parse(typeurl),
        headers: {
          'Content-Type': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        final result = response.body;
        final jsonResponse = json.decode(result);
        setState(() {
          type = jsonResponse['type'];
          invitesids = jsonResponse['invites'];
        });
        print(invitesids);
        print(type);
      } else {
        throw Exception('Cannot get the data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Home Harmony',
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(id: widget.id, token: widget.Token),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://www.mobilesmspk.net/user/images/upload_images/2020/05/7/mobilesmspk.net_home-image-1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (type == 'owner') ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PropertyTypePage(id: widget.id,token: widget.Token)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  minimumSize: Size(double.infinity, 0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 24, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Create an apartment',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
            ],
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage(type: type, senderid: widget.id, token: widget.Token)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                minimumSize: Size(double.infinity, 0),
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
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SavedPage(id:widget.id,type:type,token: widget.Token,)),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsPage(token: widget.Token,invitesids:invitesids,type: type)),
            );
          }
        },
      ),
    );
  }
}
