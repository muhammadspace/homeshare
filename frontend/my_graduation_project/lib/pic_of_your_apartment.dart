import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'config.dart';
import 'PropertyAddressPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PropertyImagesPage extends StatefulWidget {
  final String selectedPropertyType;
  final int numberofrooms;
  final String numberofbeds;
  final String size;
  final String id, token,contract_id;

  PropertyImagesPage(
      {required this.selectedPropertyType,
        required this.numberofrooms,
        required this.numberofbeds,
        required this.size,
        required this.id,
        required this.token,
        required this.contract_id});

  @override
  _PropertyImagesPageState createState() => _PropertyImagesPageState();
}

class _PropertyImagesPageState extends State<PropertyImagesPage> {
  List<File> propertyImages = [];
  List<String> imageIds = [];

  Future<void> uploadImage(File imageFile) async {
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
        imageIds.add(decodedResp['_id']);
      });
      print('Upload success: ${decodedResp['_id']}');
      print(decodedResp);
      print(imageIds);
    } else {
      print('Upload failed with status: ${response.statusCode}');
    }
  }

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await ImagePicker().pickMultiImage();

      if (pickedFiles != null) {
        setState(() {
          propertyImages.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
        });
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  Future<void> _uploadAllImages() async {
    for (File image in propertyImages) {
      await uploadImage(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Property Images',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://static.vecteezy.com/system/resources/previews/030/314/140/non_2x/house-model-on-wood-table-real-estate-agent-offer-house-property-insurance-vertical-mobile-wallpaper-ai-generated-free-photo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: propertyImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 200.0,
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(propertyImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _pickImages();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        'Choose Images',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await _uploadAllImages();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PropertyAddressPage(
                              selectedPropertyType: widget.selectedPropertyType,
                              numberofrooms: widget.numberofrooms,
                              numberofbeds: widget.numberofbeds,
                              size: widget.size,
                              id: widget.id,
                              token: widget.token,
                              contract_id: widget.contract_id,
                              apt_images_id: imageIds,

                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        backgroundColor: Colors.orange,
                      ),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Continue',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
