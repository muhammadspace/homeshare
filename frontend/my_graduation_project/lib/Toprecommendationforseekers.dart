import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class TopRecommendationseekers extends StatefulWidget {
  final List<dynamic> recommendations;
  final String senderid, token;

  TopRecommendationseekers({required this.recommendations, required this.senderid, required this.token});

  @override
  _TopRecommendationseekers createState() => _TopRecommendationseekers();
}

class _TopRecommendationseekers extends State<TopRecommendationseekers> {
  var formatter = DateFormat('yyyy-MM-dd');

  Future<Map<String, dynamic>> fetchUserData(String dataownerid) async {
    final apiUrl = 'https://homeshare-o76b.onrender.com/user/$dataownerid';
    final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  Future<Map<String, dynamic>> fetchAptData(String dataaptid) async {
    final apiUrl = 'https://homeshare-o76b.onrender.com/apt/$dataaptid';
    final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch apartment data');
    }
  }

  Future<Map<String, dynamic>> joinsomeone(String aptid, String reciverid) async {
    final inviteUrl = 'https://homeshare-o76b.onrender.com/apt/join/$aptid';
    final response = await http.post(
      Uri.parse(inviteUrl),
      headers: {'Content-Type': 'application/json', 'authorization': 'Bearer ${widget.token}'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to send invitation');
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
          final dataownerid = '${recommendation['owner_id']}';
          final dataaptid = '${recommendation['apt']}';

          return FutureBuilder<Map<String, dynamic>>(
            future: fetchUserData(dataownerid),
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
                  future: fetchAptData(dataaptid),
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
                            title: Text('Name: ${userData['username']}'),
                            subtitle: Text('Job: ${userData['job']}'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                _showInviteDialog(context, userData['username'], dataaptid, dataownerid);
                              },
                              child: Text('Invite'),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecommendationDetailPage(userdetails: userData, aptdata: aptData),
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

  Future<void> _showInviteDialog(BuildContext context, String username, String aptid, String recid) async {
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
                  await joinsomeone(aptid, recid);
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
                      content: Text('Failed to send invitation'),
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
  final userdetails;
  final aptdata;

  RecommendationDetailPage({required this.userdetails, required this.aptdata});

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
            Text(
              'Apartment Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...userDetailsWidgets(),
            SizedBox(height: 16),
            ...aptDetailsWidgets(),
          ],
        ),
      ),
    );
  }

  List<Widget> userDetailsWidgets() {
    var formatter = DateFormat('yyyy-MM-dd');
    DateTime date;
    String formattedDate = '', Stringdate;
    Stringdate = userdetails['dob'];
    date = DateTime.parse(Stringdate);
    formattedDate = formatter.format(date);
    return [
      Text(
        'Name: ${userdetails['username']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Job: ${userdetails['job']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Date Of Birth: $formattedDate',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Gender: ${userdetails['gender']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Type: ${userdetails['type']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Hobbies Pastimes: ${userdetails['hobbies_pastimes']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Sports Activities: ${userdetails['sports_activities']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Cultural Artistic: ${userdetails['cultural_artistic']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Intellectual Academic: ${userdetails['intellectual_academic']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Personality Trait: ${userdetails['personality_trait']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Value Belief: ${userdetails['value_belief']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Interpersonal Skill: ${userdetails['interpersonal_skill']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Work Ethic: ${userdetails['work_ethic']}',
        style: TextStyle(fontSize: 18),
      ),
    ];
  }

  List<Widget> aptDetailsWidgets() {
    return [
      Text(
        'Location: ${aptdata['location']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Max Occupants: ${aptdata['max']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Price: ${aptdata['price']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Bedrooms: ${aptdata['bedrooms']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Bathrooms: ${aptdata['bathrooms']}',
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Property Type: ${aptdata['property_type']}',
        style: TextStyle(fontSize: 18),
      ),
    ];
  }
}