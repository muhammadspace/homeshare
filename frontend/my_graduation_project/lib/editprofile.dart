import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'config.dart';
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
class EditBirthdayPage extends StatefulWidget {
  final token;
  EditBirthdayPage({required this.token});
  @override
  _EditBirthdayPageState createState() => _EditBirthdayPageState();
}

class _EditBirthdayPageState extends State<EditBirthdayPage> {

  late String username;
  Future<void> edit(String token) async {
    //void userdata(String token, Map<String, dynamic> id) async {
    final response = await http.post(
      Uri.parse(updprourl),
      headers: {'Content-Type': 'application/json','authorization':'Bearer $token'},
      body: jsonEncode({'username': username}),
    );

    if (response.statusCode == 200) {
      //return result;
      //,intrests:$intrests,traits:$traits
    } else {
      throw Exception('cant get the data');
    }
  }

  TextEditingController _birthdayController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Date of Birth'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _birthdayController,
                  decoration: InputDecoration(
                    labelText: 'New Date of Birth',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String newBirthday = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                print('New Date of Birth: $newBirthday');
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      });
    }
  }
}

class EditPhoneNumberPage extends StatefulWidget {
  final token;
  EditPhoneNumberPage({required this.token});
  @override
  _EditPhoneNumberPageState createState() => _EditPhoneNumberPageState();
}

class _EditPhoneNumberPageState extends State<EditPhoneNumberPage> {
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'New Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String newPhoneNumber = _phoneNumberController.text;
                print('New Phone Number: $newPhoneNumber');
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditEmailPage extends StatefulWidget {
  final token;
  EditEmailPage({required this.token});
  @override
  _EditEmailPageState createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'New Email Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async{
                String newEmail = _emailController.text;
                final String Token = widget.token;
                final response = await http.post(
                  Uri.parse(updprourl),
                  headers: {'Content-Type': 'application/json','authorization':'Bearer $Token'},
                  body: jsonEncode({'email': newEmail}),
                );
                if (response.statusCode == 200) {
                  final jsonResponse = json.decode(response.body);
                  final email = jsonResponse['email'];
                  print('New Email Address: $email');
                } else {
                  throw Exception('cant get the data');
                }
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditUserNamePage extends StatefulWidget {
  final token;
  EditUserNamePage({required this.token});
  @override
  _EditUserNamePageState createState() => _EditUserNamePageState();
}

class _EditUserNamePageState extends State<EditUserNamePage> {
  TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'New User Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async{
                String newUsername = _usernameController.text;
                final String Token = widget.token;
                final response = await http.post(
               Uri.parse(updprourl),
               headers: {'Content-Type': 'application/json','authorization':'Bearer $Token'},
               body: jsonEncode({'username': newUsername}),
             );
             if (response.statusCode == 200) {
               final jsonResponse = json.decode(response.body);
               final username = jsonResponse['username'];
               print('New User Name: $username');
             } else {
               throw Exception('cant get the data');
             }
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  final token;
  EditProfilePage({required this.token});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePhotoPage(token:token)),
                );
              },
              child: Text('Edit Profile Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditUserNamePage(token:token)),
                );
              },
              child: Text('Edit User Name', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditBirthdayPage(token:token)),
                );
              },
              child: Text('Edit Date of Birth', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditPhoneNumberPage(token:token)),
                );
              },
              child: Text('Edit Phone Number', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditEmailPage(token:token)),
                );
              },
              child: Text('Edit Email', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Handle "Save" button click
              },
              child: Text('Save', style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePhotoPage extends StatefulWidget {
  final token;
  EditProfilePhotoPage({required this.token});
  @override
  _EditProfilePhotoPageState createState() => _EditProfilePhotoPageState();
}

class _EditProfilePhotoPageState extends State<EditProfilePhotoPage> {
  File? _image;

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : CircleAvatar(
              radius: 100,
              backgroundImage: FileImage(_image!),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Select Photo'),
            ),
          ],
        ),
      ),
    );
  }
}