import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'home.dart';
//final url = 'http://192.168.1.8:3000/';
import 'home.dart';
String uid = '', utoken ='';
void ip (String id , String token){
  uid=id;
  utoken=token;
  print("user id is $id and user token is $token");
  //return 'https://homeshare-o76b.onrender.com/$id';
}
//final url = 'https://homeshare-o76b.onrender.com/';

final url = 'http://192.168.1.53:3000/';
final registration = url +"registration";
final loginuri = url +"login";
final owner = url +"recommend/owners";
final seeker =url +"recommend/seekers";
final profileuri = url+"GET /user/:id";
final apturi = url+"apt";
final userdataurl = url+"user";
final updpro_url = url+"profile";
final inviteurl = url+"invite";
//final testuserdata = url+"/user/$id";

