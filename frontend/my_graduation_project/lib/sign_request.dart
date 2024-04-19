import 'package:flutter/material.dart';
import 'config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class post_request extends StatelessWidget {
  String username, email, password, job;
  DateTime? dob;

  post_request({
    Key? key,
    required this.username,
    required this.email,
    required this.password,
    required this.dob,
    required this.job,
  }) : super(key: key);

  Future<Map<String, dynamic>> registerUser() async {
    final response = await http.post(
      Uri.parse(registration),
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
        'dob': dob?.toIso8601String(),
        'job': job,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'status': true,
        'message': data['message'],
      };
    } else {
      final data = json.decode(response.body);
      return {
        'status': false,
        'message': data['message'],
      };
    }
  }



  @override
  Widget build(BuildContext context) {
    // Your widget code here
    return Container();
  }
}