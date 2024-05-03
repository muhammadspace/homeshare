import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import "package:http/http.dart" as http;
import "config.dart" as config;
import "login.dart";

String enteredEmail = "";
List<String> code = List.generate(6, (index) => "");

bool myAlertVisible = true;
String myAlertMessage = "";

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter your email address to reset your password',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              onChanged: (_) {
                enteredEmail = emailController.text;
              },
              decoration: InputDecoration(
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // send forgot password email
                final responseObj = await http.post(
                  Uri.parse("${config.url}reset_password"),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({"email": enteredEmail}),
                  );

                final response = jsonDecode(responseObj.body);
                if (response["success"]) 
                {
                  // display 6-digit pin code to reset password
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CodeVerificationPage()));
                }
                else 
                {
                  showDialog(context: context, builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Couldn't send email"),
                      icon: Icon(Icons.warning_amber),
                      content: Text(response["message"]),
                      actions: [
                        ElevatedButton(onPressed: () { Navigator.pop(context); }, child: Text("I'll try again"))
                      ],
                    );
                  });
                }

              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}

class CodeVerificationPage extends StatefulWidget {
  const CodeVerificationPage({super.key});

  @override
  State<CodeVerificationPage> createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  final String email = enteredEmail;
  String _alertText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter 6-Digit Code"),),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text("Enter the 6-digit code that was sent to your email address $email:"),
              const SizedBox(height: 20),
              Row(children: <Widget>[Pin(index: 0), Pin(index: 1), Pin(index: 2), Pin(index: 3), Pin(index: 4), Pin(index: 5)]),
              // MyAlert(cb: cb),
              Text(style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold), _alertText, textAlign: TextAlign.center,),
              const Expanded(child: Spacer()),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () async {
                if (code.any((element) => element == ""))
                {
                  print("aaa");
                  setState(() {
                    // cb("Please enter all 6 digits.", true);
                    _alertText = "Please enter all 6 digits.";
                  });
                  return;
                }

                // cb("", false);
                setState(() {
                  _alertText = "";
                });

                final body = {"email": email, "code": code};
                // print(body);
                final response = await http.post(
                  Uri.parse("${config.url}reset_password_confirm"),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode(body)
                  );

                final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
                print(responseBody);
                if (!responseBody['success'])
                  // cb(responseBody['message']!, true);
                  setState(() {
                    _alertText = responseBody['message'];
                  });
                else
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewPasswordPage()));
                }

              }, child: Text("Check"))),
              ],
          ),
        ),
      ),
    );
  }
}

void setCodeDigit(int index, String digit) {
  code[index] = digit;
}

class Pin extends StatefulWidget {
  final int index;
  const Pin({ super.key, required this.index });

  @override
  State<Pin> createState() => _PinState();
}

class _PinState extends State<Pin> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose()
  {
    controller.dispose();
    super.dispose();
  }

  void _setDigit()
  {
    final String digit = controller.text;
    setCodeDigit(widget.index, digit);
  }

  @override 
  Widget build(BuildContext context)
  {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: TextField(
          controller: controller,
          onChanged: (value) => _setDigit(),
          maxLength: 1,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: 2)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)),
            counterText: "",
          ),
        ),
      )
    )
  ;}
}

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String alertText = "";

  @override
  void initState()
  {
    super.initState();
    passwordController.addListener(checkMatch);
    confirmPasswordController.addListener(checkMatch);
  }

  @override 
  void dispose()
  {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool checkMatch()
  {
    print("insdie checkmatch");
    if (passwordController.text != confirmPasswordController.text)
    {
      setState(() {
        alertText = "Passwords don't match";
      });
      print("dont match");
      return false;
    }
    else
    {
      setState(() {
        alertText = "";
      });
      print("match");
      return true;
    }
  }

  void sendSetPasswordRequest() async
  {
    final resopnseObj = await http.post(
      Uri.parse("${config.url}set_new_password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({ "newPassword": passwordController.text, "email": enteredEmail })
      );

    final response = jsonDecode(resopnseObj.body);
    print(response);
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Set your new password")),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(width: double.infinity, child: Text("Enter your new password")),
            TextField(
              controller: passwordController,
              // onChanged: (value) { checkMatch(); },
              decoration: InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.password)),
            ),
            SizedBox(height: 20),
            TextField(
              controller: confirmPasswordController,
              // onChanged: (value) { checkMatch(); },
              decoration: InputDecoration(labelText: "Confirm password", prefixIcon: Icon(Icons.password)),
            ),
            Text(style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold), alertText),
            Spacer(),
            SizedBox(width: double.infinity, child: ElevatedButton(
              child: Text("Reset"),
              onPressed: () { 
                sendSetPasswordRequest();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInPage()), (route) => false);
                },
            ))
          ],
        ),
      ),
    );
  }
}