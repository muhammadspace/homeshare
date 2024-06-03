import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';


Future<Map<String, dynamic>> inviteinfo(String inviteid, String token) async {
  final apiUrl = invitedataurl+inviteid;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    final jsonRes = json.decode(response.body);
    print(jsonRes);
    return jsonRes;
  } else {
    throw Exception('could not find the invite info');
  }
}

Future<Map<String, dynamic>> _fetchAptData(String dataAptId) async {
  final apiUrl = aptdataurl+dataAptId;
  final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'});
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to fetch apartment data: ${response.reasonPhrase}');
  }
}

Future<Map<String, dynamic>> _fetchUserData(String dataOwnerId) async {
  final apiUrl = profiledataurl2+dataOwnerId;
  final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'});
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to fetch user data: ${response.reasonPhrase}');
  }
}

class NotificationsPage extends StatefulWidget {
  final String token,id;
  final List<dynamic> invitesids;
  final String type;

  NotificationsPage({required this.invitesids, required this.token, required this.type,required this.id});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> invitesData = []; // Initialize as empty list
  late SharedPreferences prefs; // Declare SharedPreferences object

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      prefs = value; // Initialize SharedPreferences instance
      _fetchInviteData();
    });
  }

  Future<void> _fetchInviteData() async {
    List<Map<String, dynamic>> fetchedData = [];
    for (int i = 0; i < widget.invitesids.length; i++) {
      final inviteData = await inviteinfo(widget.invitesids[i], widget.token);
      fetchedData.add(inviteData);
    }
    setState(() {
      invitesData = fetchedData; // Update invitesData once all data is fetched
    });
  }

  Future<void> _acceptInvitation(String inviteId) async {
    final apiUrl = invite_accept_reject_url+inviteId+'/accept';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${widget.token}'},
    );
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      // Refresh the page after accepting invitation
      _fetchInviteData();
    } else {
      throw Exception('error in accepting the invite');
    }
  }

  Future<void> _rejectInvitation(String inviteId) async {
    final apiUrl = invite_accept_reject_url+inviteId+'reject';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${widget.token}'},
    );
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      // Refresh the page after rejecting invitation
      _fetchInviteData();
    } else {
      throw Exception('error in rejecting the invite');
    }
  }

  Future<void> _markAsRead(String inviteId) async {
    // Save the inviteId to local storage
    await prefs.setString(inviteId, 'read');
    // Refresh the page to reflect changes
    setState(() {
      invitesData.removeWhere((element) => element['invite_id'] == inviteId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(Token: widget.token, id: widget.id),
              ),
            );
          },
        ),// Changing the background color of the app bar
      ),
      body: invitesData.isEmpty
          ? Center(
        child: CircularProgressIndicator(), // Displaying a loading indicator
      )
          : ListView.builder(
        itemCount: invitesData.length,
        itemBuilder: (context, index) {
          final invite = invitesData[index];
          final bool accepted = invite['accepted'] ?? false;
          final bool rejected = invite['rejected'] ?? false;
          final bool markedAsRead = prefs.getString(invite['invite_id']) == 'read'; // Check if invitation is marked as read
          if (widget.type == 'seeker') {
            if (!accepted && !rejected) {
              return Card(
                elevation: 3,
                // Adding elevation to the card
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                // Adjusting card margins
                child: ListTile(
                  leading: Icon(Icons.notifications), // Notification icon
                  title: FutureBuilder(
                    future: _fetchUserData(invite['from']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      }
                      final ownerData = snapshot.data as Map<String, dynamic>;
                      return Text(
                        'You have been invited by ${ownerData['username']}',
                        style: TextStyle(fontSize: 18), // Increasing text size
                      );
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          _acceptInvitation(invite['invite_id']);
                        },
                        child: Text('Accept'),
                      ),
                      SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          _rejectInvitation(invite['invite_id']);
                        },
                        child: Text('Reject'),
                      ),
                    ],
                  ),
                  onTap: () async {
                    final ownerData = await _fetchUserData(invite['from']);
                    final aptData = await _fetchAptData(invite['apt']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(ownerData: ownerData, aptData: aptData),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          } else if (widget.type == 'owner' && !markedAsRead) { // Check if owner and not marked as read
            if (accepted || rejected) {
              return Card(
                elevation: 3,
                // Adding elevation to the card
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                // Adjusting card margins
                child: ListTile(
                  leading: Icon(Icons.notifications), // Notification icon
                  title: FutureBuilder(
                    future: _fetchUserData(invite['to']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      }
                      final seekerData = snapshot.data as Map<String, dynamic>;
                      if (accepted) {
                        return Text(
                          'Your invite has been accepted by ${seekerData['username']}',
                          style: TextStyle(fontSize: 18), // Increasing text size
                        );
                      } else {
                        return Text(
                          'Your invite has been rejected by ${seekerData['username']}',
                          style: TextStyle(fontSize: 18), // Increasing text size
                        );
                      }
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          _markAsRead(invite['invite_id']).then((_) {
                            _fetchInviteData(); // Refresh page after marking as read
                          });
                        },
                        child: Text('Mark as read'),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          } else {
            return Container(); // Handle other cases if necessary
          }
        },
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> ownerData;
  final Map<String, dynamic> aptData;

  DetailsPage({required this.ownerData, required this.aptData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Owner Details:'),
            Text('Username: ${ownerData['username']}'),
            Text('DOB: ${ownerData['dob']}'),
            Text('Gender: ${ownerData['gender']}'),
            SizedBox(height: 20),
            Text('Apartment Details:'),
            Text('Max: ${aptData['max']}'),
            Text('Price: ${aptData['price']}'),
            Text('Residents: ${aptData['residents'].length}'),
            SizedBox(height: 20),
            Text('Residents:'),
            for (int i = 0; i < aptData['residents'].length; i++)
              InkWell(
                onTap: () async {
                  final residentData = await _fetchUserData(aptData['residents'][i]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResidentDetailsPage(residentData: residentData),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Resident ${i + 1}'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ResidentDetailsPage extends StatelessWidget {
  final Map<String, dynamic> residentData;

  ResidentDetailsPage({required this.residentData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resident Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${residentData['username']}'),
            Text('DOB: ${residentData['dob']}'),
            Text('Gender: ${residentData['gender']}'),
          ],
        ),
      ),
    );
  }
}