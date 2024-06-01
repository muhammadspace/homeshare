import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'config.dart';

class TopRecommendationseekers extends StatefulWidget {
  final List<dynamic> recommendations;
  final String senderid, token;

  TopRecommendationseekers({required this.recommendations, required this.senderid, required this.token});

  @override
  _TopRecommendationseekersState createState() => _TopRecommendationseekersState();
}

class _TopRecommendationseekersState extends State<TopRecommendationseekers> {
  final DateFormat _formatter = DateFormat('yyyy-MM-dd');

  Future<Map<String, dynamic>> _fetchUserData(String dataOwnerId) async {
    final apiUrl = profiledataurl2 + dataOwnerId;
    final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user data: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> _fetchAptData(String dataAptId) async {
    final apiUrl = aptdataurl + dataAptId;
    final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch apartment data: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> _joinSomeone(String aptId, String ownerId) async {
    final inviteUrl = joinapturl + aptId;
    final response = await http.post(
      Uri.parse(inviteUrl),
      headers: {'Content-Type': 'application/json', 'authorization': 'Bearer ${widget.token}'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to send invitation: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendations for You'),
      ),
      body: ListView.builder(
        itemCount: widget.recommendations.length,
        itemBuilder: (context, index) {
          final recommendation = widget.recommendations[index];
          final dataOwnerId = '${recommendation['owner_id']}';
          final dataAptId = '${recommendation['apt']}';

          return FutureBuilder<Map<String, dynamic>>(
            future: _fetchUserData(dataOwnerId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final userData = snapshot.data!;
                return FutureBuilder<Map<String, dynamic>>(
                  future: _fetchAptData(dataAptId),
                  builder: (context, aptSnapshot) {
                    if (aptSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (aptSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${aptSnapshot.error}'),
                      );
                    } else {
                      final aptData = aptSnapshot.data!;
                      List<dynamic>? residents = aptData['residents']; // Declare residents as nullable
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: userData['picture'] != null
                                  ? NetworkImage(userData['picture'])
                                  : NetworkImage('https://cdn-icons-png.flaticon.com/512/147/147140.png'),
                            ),
                            title: Text('Name: ${userData['username']}'),
                            subtitle: Text('Job: ${userData['job']}'),
                            trailing: (aptData['max'] > (residents?.length ?? 0)) // Use null-aware operator to handle null residents
                                ? ElevatedButton(
                              onPressed: () {
                                _showInviteDialog(context, userData['username'], dataAptId, dataOwnerId);
                              },
                              child: Text('Join'),
                            )
                                : Text('Fulled'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecommendationDetailPage(userDetails: userData, aptData: aptData),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _showInviteDialog(BuildContext context, String username, String aptId, String ownerId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invite Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to join $username home?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Join'),
              onPressed: () async {
                try {
                  await _joinSomeone(aptId, ownerId);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invitation sent to $username'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  print('Error: $e');
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to send invitation: $e'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class RecommendationDetailPage extends StatelessWidget {
  final userDetails;
  final aptData;

  RecommendationDetailPage({required this.userDetails, required this.aptData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendation Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            CircleAvatar(
              radius: 50,
              backgroundImage: userDetails['picture'] != null
                  ? NetworkImage(userDetails['picture'])
                  : NetworkImage('https://cdn-icons-png.flaticon.com/512/147/147140.png'),
            ),
            SizedBox(height: 16),
            Text(
              'Apartment Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ..._userDetailsWidgets(),
            SizedBox(height: 16),
            ..._aptDetailsWidgets(),
          ],
        ),
      ),
    );
  }

  List<Widget> _userDetailsWidgets() {
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = '';

    // Check if dob is a string or DateTime and format accordingly
    if (userDetails['dob'] is String) {
      try {
        DateTime date = DateTime.parse(userDetails['dob']);
        formattedDate = formatter.format(date);
      } catch (e) {
        formattedDate = userDetails['dob']; // If parsing fails, keep it as a string
      }
    } else if (userDetails['dob'] is DateTime) {
      formattedDate = formatter.format(userDetails['dob']);
    }
    return [
      Text(
        'Name: ${userDetails['username']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Job: ${userDetails['job']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Date Of Birth: $formattedDate',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Gender: ${userDetails['gender']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Type: ${userDetails['type']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Hobbies Pastimes: ${userDetails['hobbies_pastimes']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Sports Activities: ${userDetails['sports_activities']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Cultural Artistic: ${userDetails['cultural_artistic']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Intellectual Academic: ${userDetails['intellectual_academic']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Personality Trait: ${userDetails['personality_trait']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Value Belief: ${userDetails['value_belief']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Interpersonal Skill: ${userDetails['interpersonal_skill']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Work Ethic: ${userDetails['work_ethic']}',
        style: TextStyle(fontSize: 18),
      ),
    ];
  }

  List<Widget> _aptDetailsWidgets() {
    return [
      Text(
        'Location: ${aptData['location']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Max Occupants: ${aptData['max']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Price: ${aptData['price']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Bedrooms: ${aptData['bedrooms']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Bathrooms: ${aptData['bathrooms']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Property Type: ${aptData['property_type']}',
        style: TextStyle(fontSize: 18),
      ),
    ];
  }
}
