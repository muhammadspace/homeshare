import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<Map<String, dynamic>> loginUser(String email, String password) async {
  //final apiUrl = 'http://192.168.1.95:3000/login';

  final response = await http.post(
    Uri.parse(loginuri),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final token = jsonResponse['token'];
    Map<String, dynamic> JwtDecodeToken = JwtDecoder.decode(token);
    Map<String, dynamic> id = {'id': JwtDecodeToken['id']};
    return {'token': token, 'id': id};
  } else {
    throw Exception('Failed to login');
  }
}