import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'config.dart';
import 'dart:typed_data';

class TopRecommendationsPage extends StatefulWidget {
  final List<dynamic> recommendations;
  final String senderid, token;

  TopRecommendationsPage({
    required this.recommendations,
    required this.senderid,
    required this.token,
  });

  @override
  _TopRecommendationsPageState createState() => _TopRecommendationsPageState();
}

class _TopRecommendationsPageState extends State<TopRecommendationsPage> {
  var formatter = DateFormat('yyyy-MM-dd');
  Map<String, dynamic> ownerdata = {};

  Future<Map<String, dynamic>> fetchUserData(String dataid) async {
    final apiUrl = profiledataurl2 + dataid;
    final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  Future<Map<String, dynamic>> invitesomeone(String senderid, String reciverid, String aptid) async {
    final response = await http.post(
      Uri.parse(inviteurl),
      body: json.encode({"to": reciverid, "from": senderid, "apt": aptid}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to invite user');
    }
  }

  Future<Uint8List?> _retrieveContractImage(String imageId) async {
    String url = getimageurl + imageId;
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Retrieve failed with status: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Recommendation For You',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://static.vecteezy.com/system/resources/previews/030/314/140/non_2x/house-model-on-wood-table-real-estate-agent-offer-house-property-insurance-vertical-mobile-wallpaper-ai-generated-free-photo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: widget.recommendations.length,
          itemBuilder: (context, index) {
            final recommendation = widget.recommendations[index];
            final dataid = '${recommendation['seeker_id']}';

            return FutureBuilder<Map<String, dynamic>>(
              future: fetchUserData(dataid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final userData = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        leading: FutureBuilder<Uint8List?>(
                          future: _retrieveContractImage(userData['picture'] ?? ''),
                          builder: (context, imageSnapshot) {
                            if (imageSnapshot.connectionState == ConnectionState.waiting) {
                              return CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey.shade200,
                              );
                            } else if (imageSnapshot.hasError || imageSnapshot.data == null) {
                              return CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    'https://cdn-icons-png.flaticon.com/512/147/147140.png'),
                              );
                            } else {
                              return CircleAvatar(
                                radius: 30,
                                backgroundImage: MemoryImage(imageSnapshot.data!),
                              );
                            }
                          },
                        ),
                        title: Text(
                          'Name: ${userData['username'] ?? ''}',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        subtitle: Text(
                          'Job: ${userData['job'] ?? ''}',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            ownerdata = await fetchUserData(widget.senderid);
                            _showInviteDialog(
                                context, userData['username'], widget.senderid, dataid, ownerdata['owned_apt']);
                          },
                          child: Text('Invite'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                            Colors.white,
                            backgroundColor:
                            Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecommendationDetailPage(userdetails: userData),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _showInviteDialog(
      BuildContext context, String username, String sendid, String recid, aptid) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invite Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to invite $username to your home?'),
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
              child: Text('Invite'),
              onPressed: () {
                invitesomeone(sendid, recid, aptid);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Invitation sent to $username'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class RecommendationDetailPage extends StatelessWidget {
  final Map<String, dynamic> userdetails;

  RecommendationDetailPage({required this.userdetails});

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = '';

    // Check if dob is a string or DateTime and format accordingly
    if (userdetails['dob'] is String) {
      try {
        DateTime date = DateTime.parse(userdetails['dob']);
        formattedDate = formatter.format(date);
      } catch (e) {
        formattedDate = userdetails['dob']; // If parsing fails, keep it as a string
      }
    } else if (userdetails['dob'] is DateTime) {
      formattedDate = formatter.format(userdetails['dob']);
    }

    return Scaffold(
      appBar: AppBar
        (
        title: Text('Recommendation Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: userdetails['picture'] != null
                  ? NetworkImage(userdetails['picture'])
                  : NetworkImage('https://cdn-icons-png.flaticon.com/512/147/147140.png'),
            ),
            SizedBox(height: 16),
            Text(
              'Name: ${userdetails['username']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 16),
            Text(
              'Job: ${userdetails['job']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Date Of Birth: $formattedDate',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Gender: ${userdetails['gender']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Type: ${userdetails['type']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Hobbies Pastimes: ${userdetails['hobbies_pastimes']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Sports Activities: ${userdetails['sports_activities']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Cultural Artistic: ${userdetails['cultural_artistic']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Intellectual Academic: ${userdetails['intellectual_academic']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Personality Trait: ${userdetails['personality_trait']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Value Belief: ${userdetails['value_belief']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Interpersonal Skill: ${userdetails['interpersonal_skill']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Work Ethic: ${userdetails['work_ethic']}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}