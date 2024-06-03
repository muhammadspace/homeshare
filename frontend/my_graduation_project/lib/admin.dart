import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'config.dart';
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
    ) ?? false;
  }

  Future<void> pending(String action, String aptid) async {
    final apiUrl = admin_approve_reject_url + action;
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
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Text(aptData['location']),
          subtitle: Text('Owner: ${aptData['owner']}'),
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
    _retrieveaptImages(widget.aptData['pictures']);
    _retrievecontractImage(widget.aptData['contract']);
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

  Future<void> _retrievecontractImage(String imageId) async {
    String url = getimageurl + imageId; // Replace with your server URL
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  'Location: ${widget.aptData['location']}\n'
                      'Owner: ${widget.aptData['owner']}\n'
                      'Max: ${widget.aptData['max']}\n'
                      'Bedrooms: ${widget.aptData['bedrooms']}\n'
                      'Bathrooms: ${widget.aptData['bathrooms']}\n'
                      'Property Type: ${widget.aptData['property_type']}\n'
                      'Price: ${widget.aptData['price']}\n',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
            if (imageBytesList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: imageBytesList.length,
                itemBuilder: (context, index) {
                  return Image.memory(imageBytesList[index]);
                },
              ),
            ),
            if (contract != null)
              Expanded(
                child: Image.memory(contract!),
              ),
          ],
        ),
      ),
    );
  }
}
