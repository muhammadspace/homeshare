import 'package:http/http.dart' as http;
//import 'config.dart';
import 'dart:convert';


//(String,String,String,String,String,List<String>,List<String>)
Future<String> userdata(Map<String, dynamic> token, Map<String, dynamic> id) async {
   /*var id ;
   var token;*/
  final apiUrl = 'http://192.168.1.95:3000/user/$id'; // Replace with your actual API URL
  //final dataurl = apiUrl + id ;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json',
    'authorization':'Bearer $token'},
    //body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final DOB = jsonResponse['DOB'];
    final name = jsonResponse['username'] ;
    final job = jsonResponse['job'];
    final gender = jsonResponse['gender'];
    final type = jsonResponse['type'] ;
    List<String> intrests = jsonResponse['interests'];
    List<String> traits = jsonResponse['traits'] ;
    print(response.body);
    return 'name:$name,DOB:$DOB,job:$job,intrests:$intrests,gender:$gender,type:$type,traits:$traits';
  } else {
    throw Exception('cant get the data');
  }
}