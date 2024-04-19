import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

Future<String> createapt(String id, String location,int price,int max,int rooms,int bedrooms, int bathrooms, bool furnished, bool available) async {

  final response = await http.post(
    Uri.parse(apturi),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "location": location,
      "owner": id,
      "price": price,
      "max": max,
      "rooms": rooms,
      "bedrooms": bedrooms,
      "bathrooms": bathrooms,
      "furnished": furnished,
      "available": available,
      }),
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return jsonResponse['owner'];
  } else {
    throw Exception('Failed to create and apartment');
  }
}