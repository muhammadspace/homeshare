import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'home.dart';
import 'home.dart';
String uid = '', utoken ='';
void ip (String id , String token){
  uid=id;
  utoken=token;
  print("user id is $id and user token is $token");

}
//final url = 'https://homeshare-o76b.onrender.com/';
final url = 'http://192.168.1.77:3000/';//change based on your ip type ipconfig in the cmd
final url2 = 'http://10.0.2.2:5000/';
//post api

final loginuri = url +"login";
final registration = url +"registration";
final updpro_url = url+"profile";//edit profile
final inviteurl = url+"invite";

final invite_accept_reject_url = url +"invite/";//inviteid/accept or reject
final create_edit_apturl = url+"apt";
final joinapturl = url+"apt/join/";//aptid
final kickurl = url + "apt/kick";
/*
final owners_interestsurl = url +"flask/recommend/owners_interests";
final seekers_interestsurl = url +"flask/recommend/seekers_interests";
final seekers_traitsurl = url +"flask/recommend/seekers_traits";
final owners_traitsurl = url +"flask/recommend/owners_traits";
*/

final owners_interestsurl = url2 +"recommend/owners_interests";
final seekers_interestsurl = url2 +"recommend/seekers_interests";
final seekers_traitsurl = url2 +"recommend/seekers_traits";
final owners_traitsurl = url2 +"recommend/owners_traits";
final admin_approve_reject_url = url+"admin/apt/";//approve or reject
//final admin_approve_url = url+"admin/apt/approve";
//final admin_rejecturl = url+"admin/apt/reject";
//final chaturl = url + "chat";
final chaturl = url2 + "chat";
final uploadimgurl = url+ "uploads";

//get api
final invitedataurl = url+"invite/";//inviteid
final profiledataurl = url+"user/$uid";
final profiledataurl2 = url+"user/";//user id
final aptdataurl =url+"apt/";//aptid or ownerid
final getimageurl=url+"uploads/";//imageId
final pendingapturl = url +"admin/apt/pending";
final clustersurl=url2+"admin/clusters";



