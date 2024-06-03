import 'package:flutter/material.dart';
import 'PropertyImagesPage.dart';

class PropertySizePage extends StatefulWidget {
  final String selectedPropertyType;
  final int numberofrooms;
  final id, token;
  PropertySizePage(
      {required this.selectedPropertyType,
        required this.numberofrooms,
        required this.id,
        required this.token});

  @override
  _PropertySizePageState createState() => _PropertySizePageState();
}

class _PropertySizePageState extends State<PropertySizePage> {
  TextEditingController sizeController = TextEditingController();
  TextEditingController bedsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Add Property Size',
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
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: kToolbarHeight + 20),
                  Text(
                    'Selected Property Type: ${widget.selectedPropertyType}',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: sizeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter Property Size',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'm²',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Enter the Number of Beds in the Property:',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: bedsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Number of Beds',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomAppBar(
              color: Colors.transparent,
              child: Container(
                height: 80.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    String propertySize = sizeController.text.toString();
                    String numberOfBeds = bedsController.text;

                    if (propertySize.isNotEmpty && numberOfBeds.isNotEmpty) {
                      print('Property Size: $propertySize m²');
                      print('Number of Beds: $numberOfBeds');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => contractImagesPage(
                              selectedPropertyType: widget.selectedPropertyType,
                              numberofrooms: widget.numberofrooms,
                              numberofbeds: numberOfBeds,
                              size: propertySize,
                              id: widget.id,
                              token: widget.token),
                        ),
                      );
                    } else {
                      print(
                          'Please enter both property size and number of beds');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    backgroundColor: Colors.transparent,
                    minimumSize: Size(double.infinity, 0),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.0),
                      color: Colors.orange,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(minHeight: 60),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}