import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'config.dart';
import 'dart:typed_data';
import 'home.dart';

class SavedPage extends StatefulWidget {
  final String id, type, token;

  SavedPage({required this.id, required this.type, required this.token});

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  String apt_location = '',
      apt_end = '',
      apt_start = '',
      apt_type = '',
      formattedendDate = '',
      formattedstartDate = '',
      usertype = '',
      apt_id_resident = '',
      owned_apt = '',
      admin_approval = '';
  int apt_bathrooms = 0,
      apt_bedrooms = 0,
      apt_max = 0,
      apt_price = 0,
      count = 0,
      count2 = 0;
  List<dynamic> apt_residents = [];
  var formatter = DateFormat('yyyy-MM-dd');
  List<Uint8List> imageBytesList = [];

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

  Future<Map<String, dynamic>> fetchUserownerData(String idt) async {
    final apiUrl = profiledataurl2 + idt;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['owned_apt'] != null) {
        setState(() {
          owned_apt = jsonResponse['owned_apt'];
        });
      }
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  Future<Map<String, dynamic>> fetchUserresidentData(String idt) async {
    final apiUrl = profiledataurl2 + idt;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['resident_apt'] != null) {
        setState(() {
          apt_id_resident = jsonResponse['resident_apt'];
        });
      }
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchResidentsData() async {
    List<Map<String, dynamic>> residentsData = [];
    count = 0;
    while (count < apt_residents.length) {
      final residentData = await fetchUserresidentData(apt_residents[count]);
      residentsData.add(residentData);
      count++;
    }
    return residentsData;
  }

  Future<void> fetchAptData(String idget) async {
    final apiUrl = aptdataurl + idget;

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        apt_location = jsonResponse['location'];
        apt_bathrooms = jsonResponse['bathrooms'];
        apt_bedrooms = jsonResponse['bedrooms'];
        //apt_end = jsonResponse['end_date'];
        // Check if dob is a string or DateTime and format accordingly
        if (jsonResponse['end_date'] is String) {
          try {
            DateTime date = DateTime.parse(jsonResponse['end_date']);
            formattedendDate = formatter.format(date);
          } catch (e) {
            formattedendDate = jsonResponse['end_date']; // If parsing fails, keep it as a string
          }
        } else if (jsonResponse['end_date'] is DateTime) {
          formattedendDate = formatter.format(jsonResponse['end_date']);
        }

        if (jsonResponse['start_date'] is String) {
          try {
            DateTime date = DateTime.parse(jsonResponse['start_date']);
            formattedstartDate = formatter.format(date);
          } catch (e) {
            formattedstartDate = jsonResponse['start_date']; // If parsing fails, keep it as a string
          }
        } else if (jsonResponse['start_date'] is DateTime) {
          formattedstartDate = formatter.format(jsonResponse['start_date']);
        }
        _retrieveaptImages(jsonResponse['pictures']);
        apt_max = jsonResponse['max'];
        apt_price = jsonResponse['price'];
        apt_residents = jsonResponse['residents'];
        apt_type = jsonResponse['property_type'];
        admin_approval = jsonResponse['admin_approval'];
      });
    } else {
      throw Exception('Failed to fetch apartment data');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.type == 'owner') {
      fetchUserownerData(widget.id).then((_) {
        if (owned_apt != '') {
          fetchAptData(owned_apt);
        }
      });
    } else if (widget.type == 'seeker') {
      fetchUserresidentData(widget.id).then((_) {
        if (apt_id_resident != '') {
          fetchAptData(apt_id_resident);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Properties'),
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
        ),
      ),
      body: Center(
        child: Visibility(
          visible: (apt_id_resident != '' || owned_apt != '') && admin_approval == 'approved',
          child: Card(
            elevation: 3,
            margin: EdgeInsets.all(16),
            child: InkWell(
              onTap: () async {
                List<Map<String, dynamic>> residents_data = await fetchResidentsData();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApartmentDetailsPage(
                      location: apt_location,
                      maxOccupants: apt_max,
                      price: apt_price,
                      bedrooms: apt_bedrooms,
                      bathrooms: apt_bathrooms,
                      propertyType: apt_type,
                      startDate: formattedstartDate,
                      endDate: formattedendDate,
                      residentsData: residents_data,
                      type: widget.type,
                      token: widget.token,
                      id: widget.id,
                      imageBytesList: imageBytesList,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location: $apt_location',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text('Max Occupants: $apt_max'),
                    Text('Number of Residents: ${apt_residents.length}'),
                    // Add more details as needed
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ApartmentDetailsPage extends StatelessWidget {
  final String location;
  final int maxOccupants;
  final int price;
  final int bedrooms;
  final int bathrooms;
  final String propertyType;
  final String startDate;
  final String endDate;
  final List<Map<String, dynamic>> residentsData;
  final String type;
  final String token;
  final String id;
  final List<Uint8List> imageBytesList;

  ApartmentDetailsPage({
    required this.location,
    required this.maxOccupants,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.propertyType,
    required this.startDate,
    required this.endDate,
    required this.residentsData,
    required this.type,
    required this.token,
    required this.id,
    required this.imageBytesList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apartment Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: $location'),
            Text('Max Occupants: $maxOccupants'),
            Text('Price: $price'),
            Text('Bedrooms: $bedrooms'),
            Text('Bathrooms: $bathrooms'),
            Text('Property Type: $propertyType'),
            Text('Start Date: $startDate'),
            Text('End Date: $endDate'),
            SizedBox(height: 20),
            if (imageBytesList.isNotEmpty)
              SizedBox(
                height: 200, // Set the height for the ListView
                child: ListView.builder(
                  itemCount: imageBytesList.length,
                  scrollDirection: Axis.horizontal, // Scroll horizontally
                  itemBuilder: (context, index) {
                    return Image.memory(imageBytesList[index]);
                  },
                ),
              ),
            Text('Residents Details:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            for (int i = 0; i < residentsData.length; i++)
              ListTile(
                title: Text('Resident ${i + 1}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResidentDetailsPage(
                        residentData: residentsData[i],
                        type: type,
                        token: token,
                        id: id,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class ResidentDetailsPage extends StatefulWidget {
  final Map<String, dynamic> residentData;
  final String type;
  final String token;
  final String id;

  ResidentDetailsPage({required this.residentData, required this.type, required this.token, required this.id});

  @override
  _ResidentDetailsPageState createState() => _ResidentDetailsPageState();
}

class _ResidentDetailsPageState extends State<ResidentDetailsPage> {
  Uint8List? image;

  @override
  void initState() {
    super.initState();
    _retrievecontractImage(widget.residentData['picture']);
  }

  Future<void> _retrievecontractImage(String imageId) async {
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
      appBar: AppBar(
        title: Text('Resident Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text('Name: ${widget.residentData['username']}'),
            Text('Email: ${widget.residentData['email']}'),
            Text('Gender: ${widget.residentData['gender']}'),
            Text('Job: ${widget.residentData['job']}'),
            Text('Hobbies & Pastimes: ${widget.residentData['hobbies_pastimes']}'),
            Text('Sports & Activities: ${widget.residentData['sports_activities']}'),
            Text('Cultural & Artistic: ${widget.residentData['cultural_artistic']}'),
            Text('Intellectual & Academic: ${widget.residentData['intellectual_academic']}'),
            Text('Value & Belief: ${widget.residentData['value_belief']}'),
            Text('Interpersonal Skills: ${widget.residentData['interpersonal_skill']}'),
            Text('Work Ethic: ${widget.residentData['work_ethic']}'),
            Text('Personality Trait: ${widget.residentData['personality_trait']}'),
            Text('id: ${widget.residentData['id']}'),
            Text('aptid: ${widget.residentData['resident_apt']}'),
            Visibility(
              visible: widget.type == 'owner',
              child: ElevatedButton(
                onPressed: () async {
                  final response = await http.post(
                    Uri.parse(kickurl),
                    headers: {'Content-Type': 'application/json', 'authorization': 'Bearer ${widget.token}'},
                    body: jsonEncode({'resident': widget.residentData['_id'], 'apt': widget.residentData['resident_apt']}),
                  );
                  if (response.statusCode == 200) {
                    print(json.decode(response.body));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SavedPage(
                          type: widget.type,
                          token: widget.token,
                          id: widget.id,
                        ),
                      ),
                    );
                  } else {
                    throw Exception('Failed to fetch user data');
                  }
                },
                child: Text('Remove'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
