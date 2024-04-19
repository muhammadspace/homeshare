import 'package:http/http.dart' as http;
//import 'config.dart';
import 'dart:convert';

import 'package:my_graduation_project/config.dart';


//(String,String,String,String,String,List<String>,List<String>)
Future<String> userdata(String token, Map<String, dynamic> id) async {
   final String idt = id["id"] ;
   //final String tokent = token["token"];
  final apiUrl = 'http://192.168.1.95:3000/user/$idt' ; // Replace with your actual API URL
  //final dataurl = userdataurl + '$idt' ;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json',
    'authorization':'Bearer $token'},
    //body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final  result = response.body;
    final jsonResponse = json.decode(result);
    /*final DOB = jsonResponse['DOB'];
    final name = jsonResponse['username'] ;
    final job = jsonResponse['job'];
    final gender = jsonResponse['gender'];
    final type = jsonResponse['type'] ;*/
    //List<String> intrests = jsonResponse['interests'];
    //List<String> traits = jsonResponse['traits'] ;
    print(response.body);
    return result;
   //,intrests:$intrests,traits:$traits
  } else {
    throw Exception('cant get the data');
  }
}