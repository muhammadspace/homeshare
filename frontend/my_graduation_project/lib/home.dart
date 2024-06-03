import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'PropertyType.dart';
import 'ProfilePage.dart';
import 'notification.dart';
import 'saved.dart';
import 'recommendation search.dart';
import 'chatbox.dart'; // Import the new chat page
import 'config.dart';
import 'login.dart'; // Import the SignInPage

class HomeScreen extends StatefulWidget {
  final String Token;
  final String id;

  HomeScreen({required this.Token, required this.id});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String type = '';
  String answer = '';
  String aptid = '';
  List<dynamic> invitesids = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    ip(widget.id, widget.Token);
  }

  Future<void> fetchData() async {
    final String idt = widget.id;
    final typeurl = profiledataurl2 + idt;
    try {
      final response = await http.get(
        Uri.parse(typeurl),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${widget.Token}',
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

  Future<bool> _showLogoutConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Exit'),
        content: Text('Are you sure you want to exit?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    ) ?? Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldLeave = await _onBackPressed();
        if (shouldLeave) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignInPage(),
            ),
          );
        }
        return shouldLeave;
      },
      child: Scaffold(
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
          leading: IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              bool shouldLogout = await _showLogoutConfirmationDialog();
              if (shouldLogout) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              }
            },
          ),
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
              image: NetworkImage('https://static.vecteezy.com/system/resources/previews/030/314/140/non_2x/house-model-on-wood-table-real-estate-agent-offer-house-property-insurance-vertical-mobile-wallpaper-ai-generated-free-photo.jpg'),
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
                      MaterialPageRoute(builder: (context) => PropertyTypePage(id: widget.id, token: widget.Token)),
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
                        'Create and Edit your apartment',
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
                      'Search for People',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage(token: widget.Token)),
            );
          },
          child: Icon(Icons.message),
          backgroundColor: Colors.blue,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apartment),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),*/
                    ),
                  ),
                  Icon(Icons.archive),
                ],
              ),
              label: 'Invitations',
            ),
          ],
          onTap: (int index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedPage(id: widget.id, type: type, token: widget.Token)),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage(token: widget.Token, invitesids: invitesids, type: type,id:widget.id)),
              );
            }
          },
        ),
      ),
    );
  }
}
