import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'dart:typed_data';


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
    final apiUrl = invite_accept_reject_url+inviteId+'/reject';
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
    final apiUrl = invitedataurl+inviteId;
    final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json','Authorization': 'Bearer ${widget.token}'},
        body: jsonEncode({
          "markAsRead":true
        })
    );
    if (response.statusCode == 204) {
      print("mark as read");
    } else {
      throw Exception('error in marking the invitation');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Invitations', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(Token: widget.token, id: widget.id),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://static.vecteezy.com/system/resources/previews/030/314/140/non_2x/house-model-on-wood-table-real-estate-agent-offer-house-property-insurance-vertical-mobile-wallpaper-ai-generated-free-photo.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          invitesData.isEmpty
              ? Center(
            child: CircularProgressIndicator(),
          )
              : ListView.builder(
            itemCount: invitesData.length,
            itemBuilder: (context, index) {
              final invite = invitesData[index];
              final bool accepted = invite['accepted'] ?? false;
              final bool rejected = invite['rejected'] ?? false;
              if (widget.type == 'seeker') {
                if (!accepted && !rejected) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Icon(Icons.notifications),
                      title: FutureBuilder(
                        future: _fetchUserData(invite['from']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text('Loading...');
                          }
                          final ownerData = snapshot.data as Map<String, dynamic>;
                          return Text(
                            'You have been invited by ${ownerData['username']}',
                            style: TextStyle(fontSize: 18, color: Colors.black),
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
              } else if (widget.type == 'owner' && invite['markAsRead'] == false) {
                if (accepted || rejected) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Icon(Icons.notifications),
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
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            );
                          } else {
                            return Text(
                              'Your invite has been rejected by ${seekerData['username']}',
                              style: TextStyle(fontSize: 18, color: Colors.black),
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
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}


class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> ownerData;
  final Map<String, dynamic> aptData;

  DetailsPage({required this.ownerData, required this.aptData});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Uint8List? image;
  List<Uint8List> imageBytesList = [];

  @override

  void initState() {
    super.initState();
    if(widget.ownerData['picture'] != null)
      _retrieveImage(widget.ownerData['picture']);
    if(widget.aptData['pictures'] != null)
      _retrieveaptImages(widget.aptData['pictures']);
  }

  Future<void> _retrieveImage(String imageId) async {
    String url = getimageurl + imageId; // Replace with your server URL
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          image = response.bodyBytes;
        });
      } else {
        print('Retrieve failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _retrieveaptImages(List<dynamic> imageIds) async {
    for (String imageId in imageIds) {
      String url = getimageurl + imageId; // Replace with your server URL
      try {
        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          setState(() {
            imageBytesList.add(response.bodyBytes); // Store image bytes as needed
          });
        } else {
          print('Retrieve failed with status: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Details', style: TextStyle(color: Colors.white, fontSize: 24)),
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
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80), // Spacer to push content below the AppBar
                  Text('Owner Details:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: widget.ownerData['picture'] != null
                          ? image != null
                          ? MemoryImage(image!)
                          : NetworkImage('https://cdn-icons-png.flaticon.com/512/147/147140.png') as ImageProvider
                          : NetworkImage('https://cdn-icons-png.flaticon.com/512/147/147140.png'),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildDetailText('Name: ${widget.ownerData['username']}'),
                  _buildDetailText('Gender: ${widget.ownerData['gender']}'),
                  _buildDetailText('Job: ${widget.ownerData['job']}'),
                  _buildDetailText('Hobbies & Pastimes: ${widget.ownerData['hobbies_pastimes']}'),
                  _buildDetailText('Sports & Activities: ${widget.ownerData['sports_activities']}'),
                  _buildDetailText('Cultural & Artistic: ${widget.ownerData['cultural_artistic']}'),
                  _buildDetailText('Intellectual & Academic: ${widget.ownerData['intellectual_academic']}'),
                  _buildDetailText('Value & Belief: ${widget.ownerData['value_belief']}'),
                  _buildDetailText('Interpersonal Skills: ${widget.ownerData['interpersonal_skill']}'),
                  _buildDetailText('Work Ethic: ${widget.ownerData['work_ethic']}'),
                  _buildDetailText('Personality Trait: ${widget.ownerData['personality_trait']}'),
                  SizedBox(height: 20),
                  Text('Apartment Details:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  _buildDetailText('Location: ${widget.aptData['location']}'),
                  _buildDetailText('Max Occupants: ${widget.aptData['max']}'),
                  _buildDetailText('Residents: ${widget.aptData['residents'].length}'),
                  _buildDetailText('Price: ${widget.aptData['price']}'),
                  _buildDetailText('Bedrooms: ${widget.aptData['bedrooms']}'),
                  _buildDetailText('Bathrooms: ${widget.aptData['bathrooms']}'),
                  _buildDetailText('Property Type: ${widget.aptData['property_type']}'),
                  //_buildDetailText('Start Date: ${widget.aptData['start_date']}'),
                  //_buildDetailText('End Date: ${widget.aptData['end_date']}'),
                  SizedBox(height: 20),
                  if (imageBytesList.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: imageBytesList.length,
                        itemBuilder: (context, index) {
                          return Image.memory(imageBytesList[index]);
                        },
                      ),
                    ),
                  Text('Residents:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  for (int i = 0; i < widget.aptData['residents'].length; i++)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          final residentData = await _fetchUserData(widget.aptData['residents'][i]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResidentDetailsPage(residentData: residentData),
                            ),
                          );
                        },
                        child: Text('Resident ${i + 1}', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
class ResidentDetailsPage extends StatefulWidget {
  final Map<String, dynamic> residentData;

  ResidentDetailsPage({required this.residentData});

  @override
  _ResidentDetailsPage createState() => _ResidentDetailsPage();
}

class _ResidentDetailsPage extends State<ResidentDetailsPage> {

  Uint8List? image;
  void initState() {
    super.initState();
    _retrieveImage(widget.residentData['picture']);
  }

  Future<void> _retrieveImage(String imageId) async {
    String url = getimageurl + imageId; // Replace with your server URL
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          image = response.bodyBytes;
        });
      } else {
        print('Retrieve failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Resident Details', style: TextStyle(color: Colors.white, fontSize: 24)),
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
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80), // Spacer to push content below the AppBar
                  Text('Resident Details:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: widget.residentData['picture'] != null
                          ? image != null
                          ? MemoryImage(image!)
                          : NetworkImage('https://cdn-icons-png.flaticon.com/512/147/147140.png') as ImageProvider
                          : NetworkImage('https://cdn-icons-png.flaticon.com/512/147/147140.png'),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildDetailText('Name: ${widget.residentData['username']}'),
                  _buildDetailText('Gender: ${widget.residentData['gender']}'),
                  _buildDetailText('Job: ${widget.residentData['job']}'),
                  _buildDetailText('Hobbies & Pastimes: ${widget.residentData['hobbies_pastimes']}'),
                  _buildDetailText('Sports & Activities: ${widget.residentData['sports_activities']}'),
                  _buildDetailText('Cultural & Artistic: ${widget.residentData['cultural_artistic']}'),
                  _buildDetailText('Intellectual & Academic: ${widget.residentData['intellectual_academic']}'),
                  _buildDetailText('Value & Belief: ${widget.residentData['value_belief']}'),
                  _buildDetailText('Interpersonal Skills: ${widget.residentData['interpersonal_skill']}'),
                  _buildDetailText('Work Ethic: ${widget.residentData['work_ethic']}'),
                  _buildDetailText('Personality Trait: ${widget.residentData['personality_trait']}'),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ResidentDetailsPage(
      residentData: {
        'username': 'John Doe',
        'gender': 'Male',
        'job': 'Software Engineer',
        'hobbies_pastimes': 'Reading, Coding',
        'sports_activities': 'Football, Running',
        'cultural_artistic': 'Painting, Music',
        'intellectual_academic': 'Physics, Mathematics',
        'value_belief': 'Honesty, Integrity',
        'interpersonal_skill': 'Communication, Teamwork',
        'work_ethic': 'Hardworking, Punctual',
        'personality_trait': 'Friendly, Thoughtful',
        'picture': null, // You can replace this with a valid URL to test the image loading
      },
    ),
  ));
}