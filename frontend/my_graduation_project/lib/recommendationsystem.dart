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



Future <List<dynamic>> searchowner(String sidsend) async {
  String idown = '';
  String apts = '';
  int common_interests = 0;
  List<dynamic> dataowner = [];

  final ownerUrl = 'https://homeshare-o76b.onrender.com/flask/recommend/owners' ;

  final response = await http.post(
    Uri.parse(ownerUrl),
    body: json.encode({
      "seeker_id": sidsend,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final  result = response.body;
    final jsonResponse = json.decode(result);
    dataowner = jsonResponse;
    idown = jsonResponse[0]['owner_id'];
    common_interests = jsonResponse[0]['common_interests'];
    apts = jsonResponse[0]['apt'];
    print(response.body);
    print(dataowner);
    print('id:$idown,common interests:$common_interests,apts:$apts');
    return dataowner;
  } else {
    throw Exception('cant get the data');
  }
}




Future <List<dynamic>> searchseeker(String oidsend) async {
  String idsek;
  int common_interests ;
  Decimal similarity ;
  List<dynamic> dataseeker = [];

  final seekersurl = 'https://homeshare-o76b.onrender.com/flask/recommend/seekers' ;

  final response = await http.post(
    Uri.parse(seekersurl),
    body: json.encode({
      "owner_id": oidsend,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final  result = response.body;
    final jsonResponse = json.decode(result);
    dataseeker = jsonResponse;
    /*idsek = jsonResponse['seeker_id'];
    similarity = jsonResponse['similarity'];
    common_interests = jsonResponse['common_interests'];
    print('id:$idsek,common interests:$common_interests,similarity:$similarity');*/
    print(response.body);
    return dataseeker;
  } else {
    throw Exception('cant get the data');
  }
}