import 'package:flutter/material.dart';
import 'config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

  Future<Map<String, dynamic>> registerUser(String email, String password) async {
    final response = await http.post(
      Uri.parse(registration),
      body: json.encode({
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var myToken = data['token'];
      //prefs.setString('token', myToken);
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
