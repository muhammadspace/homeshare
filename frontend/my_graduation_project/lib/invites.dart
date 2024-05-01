import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'config.dart';
import 'dart:convert';
Future<Map<String, dynamic>> inviteUser(String senderid, String reciverid,String aptid) async {
  //final apiUrl = 'http://192.168.1.95:3000/invite';

  final response = await http.post(
    Uri.parse(inviteurl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'to': reciverid, 'from': senderid, 'apt':aptid}),
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final rid = jsonResponse['to'];
    final sid = jsonResponse['from'];
    final apid = jsonResponse['apt'];
    final inviteid = jsonResponse['id'];
    print('from user $sid to user $rid for aprtment $apid using invite $inviteid');
    return {'sid': sid, 'rid': rid,'apid':apid,'inviteid':inviteid};
  } else {
    throw Exception('Failed to login');
  }
}
Future kickuser(String residentid,String aptid) async {
  //final apiUrl = 'http://192.168.1.95:3000/invite';

  final response = await http.post(
    Uri.parse(inviteurl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'resident': residentid, 'apt':aptid}),
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final message = jsonResponse['message'];
    final success = jsonResponse['success'];
  } else {
    throw Exception('Failed to login');
  }
}
Future<String> joinapt(String token, String aptid) async {
  //final String tokent = token["token"];
  final apiUrl = 'http://192.168.1.8:3000/apt/join/$aptid' ;
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json',
      'authorization':'Bearer $token'},
    //body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final  result = response.body;
    return result;
  } else {
    throw Exception('can not join the aprtment');
  }
}
Future<String> inviteinfo(String inviteid) async {
  //final String tokent = token["token"];
  final apiUrl = 'http://192.168.1.8:3000/invite/$inviteid' ;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    //body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final  result = response.body;
    return result;
  } else {
    throw Exception('can not join the aprtment');
  }
}
