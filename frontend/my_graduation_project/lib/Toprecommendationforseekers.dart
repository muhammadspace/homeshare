import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'config.dart';
import 'dart:typed_data';
import 'recommendation search.dart';


class TopRecommendationseekers extends StatefulWidget {
  final List<dynamic> recommendations;
  final String senderid, token,type;

  TopRecommendationseekers({required this.recommendations, required this.senderid, required this.token,required this.type});

  @override
  _TopRecommendationseekersState createState() => _TopRecommendationseekersState();
}

class _TopRecommendationseekersState extends State<TopRecommendationseekers> {

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

  Future<Uint8List?> _retrieveContractImage(String imageId) async {
    String url = getimageurl + imageId; // Replace with your server URL
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
        title: Text('Recommendation For You', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage(type: widget.type, senderid: widget.senderid, token: widget.token)),
            );
          },
        ),
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
                        List<dynamic>? residents = aptData['residents'];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
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
                                      backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/147/147140.png'),
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
                                'Name: ${userData['username']}',
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                'Job: ${userData['job']}',
                                style: TextStyle(fontSize: 18),
                              ),
                              trailing: (aptData['max'] > (residents?.length ?? 0))
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
      ),
    );
  }

  Future<void> _showInviteDialog(BuildContext context, String username, String aptId, String ownerId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Join Confirmation'),
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
                      content: Text('You have joined $username\'s apartment'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopRecommendationseekers(
                        recommendations: widget.recommendations,
                        senderid: widget.senderid,
                        token: widget.token,
                        type: widget.type,
                      ),
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
  final Map<String, dynamic> userDetails;
  final Map<String, dynamic> aptData;

  RecommendationDetailPage({required this.userDetails, required this.aptData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Recommendation Detail', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://static.vecteezy.com/system/resources/previews/030/314/140/non_2x/house-model-on-wood-table-real-estate-agent-offer-house-property-insurance-vertical-mobile-wallpaper-ai-generated-free-photo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80), // Spacer to push content below the AppBar
                  Text(
                    'User Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: userDetails['picture'] != null
                          ? NetworkImage(userDetails['picture'])
                          : NetworkImage('https://cdn-icons-png.flaticon.com/512/147/147140.png'),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Apartment Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  ..._userDetailsWidgets(),
                  SizedBox(height: 16),
                  ..._aptDetailsWidgets(),
                ],
              ),
            ),
          ),
        ],
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
      _buildDetailText('Name: ${userDetails['username']}'),
      _buildDetailText('Job: ${userDetails['job']}'),
      _buildDetailText('Date Of Birth: $formattedDate'),
      _buildDetailText('Gender: ${userDetails['gender']}'),
      _buildDetailText('Type: ${userDetails['type']}'),
      _buildDetailText('Hobbies Pastimes: ${userDetails['hobbies_pastimes']}'),
      _buildDetailText('Sports Activities: ${userDetails['sports_activities']}'),
      _buildDetailText('Cultural Artistic: ${userDetails['cultural_artistic']}'),
      _buildDetailText('Intellectual Academic: ${userDetails['intellectual_academic']}'),
      _buildDetailText('Personality Trait: ${userDetails['personality_trait']}'),
      _buildDetailText('Value Belief: ${userDetails['value_belief']}'),
      _buildDetailText('Interpersonal Skill: ${userDetails['interpersonal_skill']}'),
      _buildDetailText('Work Ethic: ${userDetails['work_ethic']}'),
    ];
  }

  List<Widget> _aptDetailsWidgets() {
    return [
      _buildDetailText('Location: ${aptData['location']}'),
      _buildDetailText('Max Occupants: ${aptData['max']}'),
      _buildDetailText('Price: ${aptData['price']}'),
      _buildDetailText('Bedrooms: ${aptData['bedrooms']}'),
      _buildDetailText('Bathrooms: ${aptData['bathrooms']}'),
      _buildDetailText('Property Type: ${aptData['property_type']}'),
    ];
  }

  Widget _buildDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
