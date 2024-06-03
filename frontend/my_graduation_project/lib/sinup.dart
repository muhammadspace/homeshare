import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'login.dart';
import 'profilePhoto.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://static.vecteezy.com/system/resources/previews/030/314/140/non_2x/house-model-on-wood-table-real-estate-agent-offer-house-property-insurance-vertical-mobile-wallpaper-ai-generated-free-photo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 60.0),
                    const Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create your account",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(height: 40),
                Column(
                  children: <Widget>[
                    _buildTextField(_usernameController, "Username", Icons.person),
                    const SizedBox(height: 20),
                    _buildTextField(_emailController, "Email", Icons.email),
                    const SizedBox(height: 20),
                    _buildTextField(_passwordController, "Password", Icons.password, obscureText: true),
                    const SizedBox(height: 20),
                    _buildTextField(_confirmPasswordController, "Confirm Password", Icons.password, obscureText: true),
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: ElevatedButton(
                    onPressed: () async {
                      final username = _usernameController.text;
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      final confirmPassword = _confirmPasswordController.text;

                      if (password == confirmPassword) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePicturePage(
                                  username: username,
                                  email: email,
                                  password: password)),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Sign Up Error'),
                            content: const Text('Passwords do not match'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?", style: TextStyle(color: Colors.white)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.orange),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData prefixIcon, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white, fontSize: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.white.withOpacity(0.3),
        filled: true,
        prefixIcon: Icon(prefixIcon, color: Colors.white),
      ),
      obscureText: obscureText,
      style: TextStyle(color: Colors.white, fontSize: 18),
    );
  }
}