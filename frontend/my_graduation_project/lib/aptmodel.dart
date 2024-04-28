import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

Future<String> createapt(String id, String location,int price,int max,int bedrooms, int bathrooms,String Start,String End,String type) async {

  final response = await http.post(
    //Uri.parse(apturi),
    Uri.parse('https://homeshare-o76b.onrender.com/apt'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "location": location,
      "owner": id,
      "price": price,
      "max": max,
      "property_type": type,
      "bedrooms": bedrooms,
      "bathrooms": bathrooms,
      "start_date":Start,
      "end_date":End,
      }),
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return jsonResponse['owner'];
  } else {
    throw Exception('Failed to create and apartment');
  }
}