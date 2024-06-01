import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'notification.dart';
import 'ProfilePage.dart';
import 'dart:convert';
import 'fadelinleft.dart';

class AdminPage extends StatefulWidget {
  final String Token;
  final String id;

  AdminPage({required this.Token, required this.id});

  @override
  _AdminPage createState() => _AdminPage();
}

class _AdminPage extends State<AdminPage> {
  List<dynamic> pendingaptdata = [];

  Future<void> pending(String action, String aptid) async {
    final apiUrl = 'https://homeshare-o76b.onrender.com/admin/apt/$action';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${widget.Token}'},
      body: jsonEncode({'aptid': aptid}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      await pendingapt();  // Refresh the pending list
    } else {
      throw Exception('Failed to perform the action');
    }
  }

  Future<void> pendingapt() async {
    final apiUrl = 'https://homeshare-o76b.onrender.com/admin/apt/pending';
    final response = await http.get(
      Uri.parse(apiUrl),
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    id: widget.id,
                    token: widget.Token,
                  ),
                ),
              );
            },
          ),
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

class PropertyDetailPage extends StatelessWidget {
  final Map<String, dynamic> aptData;

  PropertyDetailPage({required this.aptData});

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
                  'Location: ${aptData['location']}\n'
                      'Owner: ${aptData['owner']}\n'
                      'Max: ${aptData['max']}\n'
                      'Bedrooms: ${aptData['bedrooms']}\n'
                      'Bathrooms: ${aptData['bathrooms']}\n'
                      'Property Type: ${aptData['property_type']}\n'
                      'Price: ${aptData['price']}\n',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
