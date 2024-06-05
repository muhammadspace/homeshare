import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'config.dart';
import 'pic_of_your_apartment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContractImagesPage extends StatefulWidget {
  final String selectedPropertyType;
  final int numberofrooms;
  final String numberofbeds;
  final String size;
  final String id, token;

  ContractImagesPage({
    required this.selectedPropertyType,
    required this.numberofrooms,
    required this.numberofbeds,
    required this.size,
    required this.id,
    required this.token,
  });

  @override
  _ContractImagesPageState createState() => _ContractImagesPageState();
}

class _ContractImagesPageState extends State<ContractImagesPage> {
  List<File> propertyImages = [];
  String contractId = '';

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
        contractId = decodedResp['_id'];
      });
      print('Upload success: $contractId');
      print(decodedResp);
    } else {
      print('Upload failed with status: ${response.statusCode}');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          File image = File(pickedFile.path);
          propertyImages.add(image);
          uploadImage(image);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Contract Image',
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
                        _pickImage(ImageSource.gallery);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        'Pick Apartment Contract Image',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PropertyImagesPage(
                              selectedPropertyType: widget.selectedPropertyType,
                              numberofrooms: widget.numberofrooms,
                              numberofbeds: widget.numberofbeds,
                              size: widget.size,
                              id: widget.id,
                              token: widget.token,
                              contract_id: contractId,
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
