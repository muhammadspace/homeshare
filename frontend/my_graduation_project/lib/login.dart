import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_graduation_project/sinup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:my_graduation_project/home.dart';
import 'test.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'forgetpassword.dart';
import 'admin.dart';
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}
class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;


  Future<String> fetchUserData(String id) async {

  final url = profiledataurl2 + id;
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final jsonRes = json.decode(response.body);

        String type = jsonRes['type'];

      print(response.body);
      return type;
    } else {
      throw Exception('Failed to fetch user data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://static.vecteezy.com/system/resources/previews/030/314/140/non_2x/house-model-on-wood-table-real-estate-agent-offer-house-property-insurance-vertical-mobile-wallpaper-ai-generated-free-photo.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(24),
          //margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(),
              _inputField(),
              _forgotPassword(),
              _signup(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Text(
          "Login",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          "Enter your credentials to login",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _inputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.3),
            prefixIcon: Icon(Icons.person, color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.3),
            prefixIcon: Icon(Icons.lock, color: Colors.white),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            //login();
            String email = emailController.text.trim();
            String password = passwordController.text.trim();
            loginUser(email, password).then((result) async{
              final token = result['token'];
              final id = result['id'];
              String lastid = id['id'];
              print('Token: $token');
              print('User ID: ${id['id']}');
              String y = await fetchUserData(lastid);
            if (email.endsWith('@fci.helwan.edu.eg') && y=='admin') {
              // Navigate to AdminPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        AdminPage(Token: token, id: lastid)),
                  );
            } else{
              // Login regular user
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen(Token: token, id: lastid)),
                );
            }
                  });
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.orange,
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }

  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
        );
      },
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.orange),
      ),
    );
  }

  Widget _signup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //const Text("Don't have an account? "),
        Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.white),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupPage()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.orange),
          ),
        )
      ],
    );
  }
}