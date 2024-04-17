import 'package:http/http.dart' as http;
final url = 'http://192.168.41.207:3000/';
//final url = 'https://homeshare-o76b.onrender.com/';
final registration = url + "registration";
final loginuri = url + "login";
final owner = url +"recommend/owner";
final seeker =url +"recommend/seeker";
final profileuri = url+"GET /user/:id";
final apturi = url+"apt";