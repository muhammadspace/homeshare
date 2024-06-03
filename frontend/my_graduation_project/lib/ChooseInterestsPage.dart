import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_graduation_project/login.dart';
import 'config.dart';
import 'home.dart';
import 'dart:convert';
import 'test.dart';

class ChooseInterestsPage extends StatefulWidget {
  final String username,
      email,
      password,
      job,
      gender,
      type,
      Personality,
      Value_and_Belief,
      Work_Ethic,
      Interpersonal_Skill,image;
  final DateTime? dob;

  ChooseInterestsPage({
    Key? key,
    required this.username,
    required this.email,
    required this.password,
    required this.image,
    required this.dob,
    required this.job,
    required this.gender,
    required this.type,
    required this.Interpersonal_Skill,
    required this.Personality,
    required this.Value_and_Belief,
    required this.Work_Ethic,
  }) : super(key: key);

  @override
  _ChooseInterestsPageState createState() => _ChooseInterestsPageState();
}

class _ChooseInterestsPageState extends State<ChooseInterestsPage> {
  String? selectedHobby;
  String? selectedSport;
  String? selectedCultural;
  String? selectedIntellectual;

  Map<String, List<String>> interestsOptions = {
    'Hobbies and Pastimes': [
      'Gardening',
      'Cooking',
      'Photography',
      'Painting',
      'Woodworking',
      'Reading',
      'Writing',
      'Playing guitar',
      'Sewing',
      'Knitting',
      'Birdwatching',
      'Hiking',
      'Cycling',
      'DIY projects',
      'Yoga',
      'Meditation',
      'Stamp collecting',
      'Coin collecting',
      'Antiques collecting',
      'Pottery',
      'Ceramics',
      'Astronomy',
      'Model building ',
      'Scuba diving',
      'Camping',
      'Fishing',
      'Playing chess',
      'Baking',
      'Scrapbooking',
      'Calligraphy',
    ],
    'Sports and Physical Activities': [
      'Soccer',
      'Basketball',
      'Tennis',
      'Swimming',
      'Running',
      'Cycling',
      'Golf',
      'Yoga',
      'Karate',
      'Judo',
      'Ballet',
      'Hip-hop dance',
      'Gymnastics',
      'Skiing',
      'Snowboarding',
      'Surfing',
      'Rock climbing',
      'Horseback riding',
      'Skateboarding',
      'Fencing',
      'Ultimate Frisbee',
      'Rowing',
      'Archery',
      'Martial arts',
      'Triathlons',
      'Volleyball',
      'Rugby',
      'Kickboxing',
      'Sailing',
      'Mountain biking',
    ],
    'Cultural and Artistic Pursuits': [
      'Theater',
      'Music concerts',
      'Art galleries',
      'Museums',
      'Film festivals',
      'Poetry readings',
      'Opera',
      'Ballet',
      'Symphony ',
      'Stand-up comedy shows',
      'Street art tours',
      'Cultural festivals',
      'Photography exhibitions',
      'Book clubs',
      'Live storytelling events',
      'Pottery workshops',
      'Sculpture gardens',
      'Poetry slams',
      'Calligraphy classes',
      'Indigenous art experiences',
      'Classical music appreciation',
      'Jazz clubs',
      'Opera appreciation',
      'Renaissance art appreciation',
      'Baroque music appreciation',
      'Film analysis clubs',
      'Impressionist art ',
      'World music concerts',
      'Theater workshops',
      'Shakespearean plays',
    ],
    'Intellectual and Academic Interests': [
      'Science fiction literature',
      'Philosophy discussions',
      'History lectures',
      'Political debates',
      'Psychology seminars',
      'Economics forums',
      'Linguistics workshops',
      'Mathematics competitions',
      'Computer programming',
      'Astronomy clubs',
      'Environmental sustainability',
      'Robotics competitions',
      'Bioinformatics symposiums',
      'Archaeological digs',
      'Sociology conferences',
      'Cultural anthropology',
      'Legal seminars',
      'Ethical debates',
      'Educational technology',
      'Literature appreciation',
      'Scientific research',
      'Academic publishing',
      'Data analysis workshops',
      'Chemistry experiments',
      'Physics lectures',
      'Climate change discussions',
      'Medical ethics debates',
      'Genetics research',
      'Linguistic analysis',
      'Political science forums',
    ],
  };

  Future<Map<String, dynamic>> registerUser(
      String hob, spor, clu, intel) async {
    String hobbies = hob,
        sports = spor,
        cultural = clu,
        intellectual = intel;
    final response = await http.post(
      Uri.parse(registration),
      body: json.encode({
        "username": widget.username,
        "email": widget.email,
        "password": widget.password,
        "dob": widget.dob?.toIso8601String(),
        "job": widget.job,
        "picture": widget.image,
        "gender": widget.gender,
        "type": widget.type,
        "hobbies_pastimes": hobbies,
        "sports_activities": sports,
        "cultural_artistic": cultural,
        "intellectual_academic": intellectual,
        "personality_trait": widget.Personality,
        "work_ethic": widget.Work_Ethic,
        "value_belief": widget.Value_and_Belief,
        "interpersonal_skill": widget.Interpersonal_Skill,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'status': true,
        'message': data['message'],
      };
    } else {
      final data = json.decode(response.body);
      return {
        'status': false,
        'message': data['message'],
      };
    }
  }

  bool canProceed() {
    return selectedHobby != null &&
        selectedSport != null &&
        selectedCultural != null &&
        selectedIntellectual != null;
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top + kToolbarHeight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Choose Your Interests'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://static.vecteezy.com/system/resources/previews/030/314/140/non_2x/house-model-on-wood-table-real-estate-agent-offer-house-property-insurance-vertical-mobile-wallpaper-ai-generated-free-photo.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: topPadding, left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: interestsOptions.keys.map((interest) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select your interest in $interest:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: interestsOptions[interest]!.map((subInterest) {
                          return RadioListTile(
                            title: Row(
                              children: [
                                Icon(Icons.star, color: Colors.orange),
                                SizedBox(width: 8),
                                Text(
                                  subInterest,
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ],
                            ),
                            value: subInterest,
                            groupValue: _getSelectedValue(interest),
                            onChanged: (value) {
                              setState(() {
                                _updateSelection(interest, value.toString());
                              });
                            },
                            activeColor: Colors.orange,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton(
          onPressed: canProceed()
              ? () {
            print('Selected Hobby: $selectedHobby');
            print('Selected Sport: $selectedSport');
            print('Selected Cultural: $selectedCultural');
            print('Selected Intellectual: $selectedIntellectual');
            registerUser('$selectedHobby', '$selectedSport',
                '$selectedCultural', '$selectedIntellectual');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignInPage(),
              ),
            );
          }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: canProceed() ? Colors.orange : Colors.grey,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            textStyle: TextStyle(fontSize: 18),
          ),
          child: Text('Continue'),
        ),
      ),
    );
  }

  String? _getSelectedValue(String category) {
    switch (category) {
      case 'Hobbies and Pastimes':
        return selectedHobby;
      case 'Sports and Physical Activities':
        return selectedSport;
      case 'Cultural and Artistic Pursuits':
        return selectedCultural;
      case 'Intellectual and Academic Interests':
        return selectedIntellectual;
      default:
        return null;
    }
  }

  void _updateSelection(String category, String value) {
    setState(() {
      switch (category) {
        case 'Hobbies and Pastimes':
          selectedHobby = value;
          break;
        case 'Sports and Physical Activities':
          selectedSport = value;
          break;
        case 'Cultural and Artistic Pursuits':
          selectedCultural = value;
          break;
        case 'Intellectual and Academic Interests':
          selectedIntellectual = value;
          break;
      }
    });
  }
}