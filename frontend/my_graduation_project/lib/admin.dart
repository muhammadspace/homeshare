import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'config.dart'; // Make sure this imports the URLs correctly
import 'clusterpage.dart';
import 'notification.dart';
import 'ProfilePage.dart';
import 'fadelinleft.dart';
import 'login.dart';

class AdminPage extends StatefulWidget {
  final String Token;
  final String id;

  AdminPage({required this.Token, required this.id});

  @override
  _AdminPage createState() => _AdminPage();
}

class _AdminPage extends State<AdminPage> {
  List<dynamic> pendingaptdata = [];

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
    ) ??
        false;
  }

  Future<void> pending(String action, String aptid) async {
    final apiUrl = '$admin_approve_reject_url$action';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${widget.Token}'},
      body: jsonEncode({'aptid': aptid}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      await pendingapt(); // Refresh the pending list
    } else {
      throw Exception('Failed to perform the action');
    }
  }

  Future<void> pendingapt() async {
    final response = await http.get(
      Uri.parse(pendingapturl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.Token}'
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        pendingaptdata = result;
      });
    } else {
      throw Exception('Cannot fetch pending apartments');
    }
  }

  @override
  void initState() {
    super.initState();
    pendingapt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
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
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClusterPage(Token: widget.Token, id: widget.id),
                ),
              );
            },
            child: Text('Clustering'),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://i.pinimg.com/736x/43/0f/6e/430f6ecd9ea1bc9ec7913684e9a4f3fe.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: pendingaptdata.length,
          itemBuilder: (context, index) {
            final aptData = pendingaptdata[index];
            return PropertyItem(
              aptData: aptData,
              onApprove: () => pending('approve', aptData['_id']),
              onDecline: () => pending('reject', aptData['_id']),
              onDetails: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyDetailPage(aptData: aptData),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PropertyItem extends StatelessWidget {
  final Map<String, dynamic> aptData;
  final VoidCallback onApprove;
  final VoidCallback onDecline;
  final VoidCallback onDetails;

  PropertyItem({
    required this.aptData,
    required this.onApprove,
    required this.onDecline,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          title: Text(
            aptData['location'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Max Occupancy: ${aptData['max']}'),
          onTap: onDetails,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: onApprove,
                child: Text('Approve'),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: onDecline,
                child: Text('Decline'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PropertyDetailPage extends StatefulWidget {
  final Map<String, dynamic> aptData;

  PropertyDetailPage({required this.aptData});

  @override
  _PropertyDetailPageState createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  List<Uint8List> imageBytesList = [];
  Uint8List? contract;

  @override
  void initState() {
    super.initState();
    if (widget.aptData['pictures'] != null) {
      _retrieveaptImages(widget.aptData['pictures']);
    }
    if (widget.aptData['contract'] != null) {
      _retrievecontractImage(widget.aptData['contract']);
    }
  }

  Future<void> _retrieveaptImages(List<dynamic> imageIds) async {
    for (String imageId in imageIds) {
      String url = '$getimageurl$imageId'; // Replace with your server URL
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

  Future<void> _retrievecontractImage(String imageId) async {
    String url = '$getimageurl$imageId'; // Replace with your server URL
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          contract = response.bodyBytes;
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
        title: Text('Property Details'),

      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://i.pinimg.com/736x/43/0f/6e/430f6ecd9ea1bc9ec7913684e9a4f3fe.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Property Details',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Location: ${widget.aptData['location']}',
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                    Text(
                      'Owner ID: ${widget.aptData['owner']}',
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                    Text(
                      'Max Occupancy: ${widget.aptData['max']}',
                      style: TextStyle(fontSize: 25.0, color: Colors.black),
                    ),
                    Text(
                      'Bedrooms: ${widget.aptData['bedrooms']}',
                      style: TextStyle(fontSize: 25.0, color: Colors.black),
                    ),
                    Text(
                      'Bathrooms: ${widget.aptData['bathrooms']}',
                      style: TextStyle(fontSize: 25.0, color: Colors.black),
                    ),
                    Text(
                      'Property Type: ${widget.aptData['property_type']}',
                      style: TextStyle(fontSize: 25.0, color: Colors.black),
                    ),
                    Text(
                      'Price: \$${widget.aptData['price']} per month',
                      style: TextStyle(fontSize: 25.0, color: Colors.black),
                    ),
                    if (imageBytesList.isNotEmpty && contract != null)
                      SizedBox(height: 16.0) else SizedBox(height: 500.0),
                    if (imageBytesList.isNotEmpty) ...[
                      Text(
                        'Apartment Pictures',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.0),
                      Column(
                        children: imageBytesList.map((imageBytes) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.memory(
                                imageBytes,
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    if (contract != null) ...[
                      Text(
                        'Contract Image',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.memory(
                          contract!,
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
