import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_graduation_project/config.dart';
import 'dateOfBirth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

class ProfilePicturePage extends StatefulWidget {
  final String username, email, password;
  ProfilePicturePage({
    Key? key,
    required this.username,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  _ProfilePicturePageState createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> {
  File? selectedImage;
  String uploadimgpath = '';
  String image_id = '';

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        uploadImage(selectedImage!);
      });
    }
  }

  Future<void> uploadImage(File imageFile) async {
    //String url = "http://192.168.1.53:3000/uploads";
    var request = http.MultipartRequest('POST', Uri.parse(uploadimgurl));
    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // 'image' should match the key in your backend route
        imageFile.path,
      ),
    );

    var response = await request.send();

    if (response.statusCode == 201) {
      final respStr = await response.stream.bytesToString();
      final decodedResp = jsonDecode(respStr);
      setState(() {
        uploadimgpath = decodedResp['path'];
        image_id = decodedResp['_id'];
      });
      print('Upload success: $uploadimgpath');
      print(decodedResp);
    } else {
      print('Upload failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        // Change back arrow color to white
        titleTextStyle: TextStyle(color: Colors.white,
            fontSize: 20), // Change title text color to white
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://static.vecteezy.com/system/resources/previews/030/314/140/non_2x/house-model-on-wood-table-real-estate-agent-offer-house-property-insurance-vertical-mobile-wallpaper-ai-generated-free-photo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: kToolbarHeight + 20),
            // Adjust height to include AppBar height
            buildImagePicker(),
            Spacer(),
            // Add spacer to push the button to the bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RegisterPage(
                            username: widget.username,
                            email: widget.email,
                            password: widget.password,
                            image: image_id,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Select Your Profile Picture',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: _pickImage,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
          ),
          child: Text(
            selectedImage != null ? 'Image Selected' : 'Pick an Image',
            style: TextStyle(fontSize: 18),
          ),
        ),
        if (selectedImage != null)
          Container(
            margin: EdgeInsets.only(top: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(selectedImage!),
            ),
          ),
      ],
    );
  }
}