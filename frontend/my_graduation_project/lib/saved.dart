import 'package:flutter/material.dart';

class SavedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> savedProperties = [
      {
        'image': 'https://images.skynewsarabia.com/images/v1/2019/07/31/1272390/1200/630/1-1272390.jpg',
        'title': 'giza',
        'beds': 3,
      },
      {
        'image': 'https://images.skynewsarabia.com/images/v1/2019/07/31/1272390/1200/630/1-1272390.jpg',
        'title': 'nasir city',
        'beds': 2,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Properties'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: savedProperties.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PropertyDetailsPage(
                    property: savedProperties[index],
                  ),
                ),
              );
            },
            child: Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // تعديل هوامش البطاقة
              child: ListTile(
                leading: Image.network(
                  savedProperties[index]['image'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  savedProperties[index]['title'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // تكبير النص وجعله بالخط العريض
                ),
                subtitle: Text(
                  'Available Beds: ${savedProperties[index]['beds']}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// صفحة عرض تفاصيل العقار
class PropertyDetailsPage extends StatelessWidget {
  final Map<String, dynamic> property;

  PropertyDetailsPage({required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Details'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              property['image'],
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              property['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black), // تكبير النص وجعله بالخط العريض وتغيير لونه
            ),
            SizedBox(height: 10),
            Text(
              'Available Beds: ${property['beds']}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}