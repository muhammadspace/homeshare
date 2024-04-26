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



Future<void> searchowner(int idsend) async {
  int idres;
  List<dynamic> apts = [];
  String common_interests ;

  final apiUrl = 'http://192.168.1.95:3000/flask/recommend/owner' ;

  final response = await http.post(
    Uri.parse(apiUrl),
    body: json.encode({
      "id": idsend,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final  result = response.body;
    final jsonResponse = json.decode(result);
    idres = jsonResponse['id'];
    common_interests = jsonResponse['common_interests'];
    apts = jsonResponse['apts'];
    print('id:$idres,common interests:$common_interests,apts:$apts');
    print(response.body);
  } else {
    throw Exception('cant get the data');
  }
}




Future<void> searchseeker(int idsend) async {
  final Token;
  int idres;
  List<dynamic> apts = [];
  var similarity ;

  final apiUrl = 'http://192.168.1.95:3000/flask/recommend/seeker' ;

  final response = await http.post(
    Uri.parse(apiUrl),
    body: json.encode({
      "id": idsend,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final  result = response.body;
    final jsonResponse = json.decode(result);
    idres = jsonResponse['id'];
    similarity = jsonResponse['similarity'];
    apts = jsonResponse['apts'];
    print('id:$idres,common interests:$similarity,apts:$apts');
    print(response.body);
  } else {
    throw Exception('cant get the data');
  }
}