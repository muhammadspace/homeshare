import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_graduation_project/userata.dart';
import 'PropertyType.dart';
import 'preference.dart';
import 'ProfilePage.dart'; // Import the ProfilePage
import 'package:jwt_decoder/jwt_decoder.dart';
import 'userata.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:decimal/decimal.dart';
import 'config.dart';




Future <List<dynamic>> searchownerinterest(String sidsend) async {

  List<dynamic> dataowner = [];

  final ownerintUrl = 'http://10.0.2.2:5000/recommend/owners_interests' ;

  final response = await http.post(
    Uri.parse(ownerintUrl),
    body: json.encode({
      "seeker_id": sidsend,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final  result = response.body;
    final jsonResponse = json.decode(result);
    dataowner = jsonResponse;
    print(response.body);
    print(dataowner);
    return dataowner;
  } else {
    throw Exception('cant get the data');
  }
}
Future <List<dynamic>> searchownertraits(String sidsend) async {
  List<dynamic> dataowner = [];

  final ownertraUrl = 'https://homeshare-o76b.onrender.com/flask/recommend/owners_traits' ;

  final response = await http.post(
    Uri.parse(ownertraUrl),
    body: json.encode({
      "seeker_id": sidsend,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final  result = response.body;
    final jsonResponse = json.decode(result);
    dataowner = jsonResponse;
    print(response.body);
    print(dataowner);
    return dataowner;
  } else {
    throw Exception('cant get the data');
  }
}



Future <List<dynamic>> searchseekerinterest(String oidsend) async {
  List<dynamic> dataseeker = [];

  final seekersinturl = 'http://10.0.2.2:5000/recommend/seekers_interests' ;

  final response = await http.post(
    Uri.parse(seekersinturl),
    body: json.encode({
      "owner_id": oidsend,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final  result = response.body;
    final jsonResponse = json.decode(result);
    dataseeker = jsonResponse;
    print(response.body);
    print(dataseeker);
    return dataseeker;
  } else {
    throw Exception('cant get the data');
  }
}
Future <List<dynamic>> searchseekertraits(String oidsend) async {
  List<dynamic> dataseeker = [];

  final seekerstraurl = 'https://homeshare-o76b.onrender.com/flask/recommend/seekers_traits' ;

  final response = await http.post(
    Uri.parse(seekerstraurl),
    body: json.encode({
      "owner_id": oidsend,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final  result = response.body;
    final jsonResponse = json.decode(result);
    dataseeker = jsonResponse;
    print(response.body);
    print(dataseeker);
    return dataseeker;
  } else {
    throw Exception('cant get the data');
  }
}