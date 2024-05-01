import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List of property notifications (replace with actual data from database)
    List<Map<String, dynamic>> notifications = [
      {
        'message': 'Your request for Property #1 has been approved.',
        'date': 'April 21, 2024',
      },
      {
        'message': 'Property #2 information has been updated.',
        'date': 'April 20, 2024',
      },
      // More notifications can be added here
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blue, // Changing the background color of the app bar
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3, // Adding elevation to the card
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjusting card margins
            child: ListTile(
              leading: Icon(Icons.notifications), // Notification icon
              title: Text(
                notifications[index]['message'],
                style: TextStyle(fontSize: 18), // Increasing text size
              ),
              subtitle: Text(
                notifications[index]['date'],
                style: TextStyle(fontSize: 16), // Increasing text size
              ),
            ),
          );
        },
      ),
    );
  }
}