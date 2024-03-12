import 'package:flutter/material.dart';

class InterestsPage extends StatefulWidget {
  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  String? selectedHobby;
  String? selectedSport;
  String? selectedCultural;
  String? selectedIntellectual;

  Map<String, List<String>> interestsOptions = {
    'Hobbies and Pastimes': [
      'Gardening', 'Cooking', 'Photography', 'Painting', 'Woodworking', 'Reading', 'Writing', 'Playing guitar', 'Sewing',
      'Knitting', 'Birdwatching', 'Hiking', 'Cycling', 'DIY projects', 'Yoga', 'Meditation', 'Stamp collecting',
      'Coin collecting', 'Antiques collecting', 'Pottery', 'Ceramics', 'Astronomy', 'Model building ',
      'Scuba diving', 'Camping', 'Fishing', 'Playing chess', 'Baking', 'Scrapbooking', 'Calligraphy',
    ],
    'Sports and Physical Activities': [
      'Soccer', 'Basketball', 'Tennis', 'Swimming', 'Running', 'Cycling', 'Golf', 'Yoga', 'Karate', 'Judo',
      'Ballet', 'Hip-hop dance', 'Gymnastics', 'Skiing', 'Snowboarding', 'Surfing', 'Rock climbing', 'Horseback riding',
      'Skateboarding', 'Fencing', 'Ultimate Frisbee', 'Rowing', 'Archery', 'Martial arts', 'Triathlons', 'Volleyball',
      'Rugby', 'Kickboxing', 'Sailing', 'Mountain biking',
    ],
    'Cultural and Artistic Pursuits': [
      'Theater', 'Music concerts', 'Art galleries', 'Museums', 'Film festivals', 'Poetry readings', 'Opera', 'Ballet',
      'Symphony ', 'Stand-up comedy shows', 'Street art tours', 'Cultural festivals', 'Photography exhibitions',
      'Book clubs', 'Live storytelling events', 'Pottery workshops', 'Sculpture gardens', 'Poetry slams', 'Calligraphy classes',
      'Indigenous art experiences', 'Classical music appreciation', 'Jazz clubs', 'Opera appreciation', 'Renaissance art appreciation',
      'Baroque music appreciation', 'Film analysis clubs', 'Impressionist art ', 'World music concerts', 'Theater workshops',
      'Shakespearean plays',
    ],
    'Intellectual and Academic Interests': [
      'Science fiction literature', 'Philosophy discussions', 'History lectures', 'Political debates', 'Psychology seminars',
      'Economics forums', 'Linguistics workshops', 'Mathematics competitions', 'Computer programming', 'Astronomy clubs',
      'Environmental sustainability', 'Robotics competitions', 'Bioinformatics symposiums', 'Archaeological digs',
      'Sociology conferences', 'Cultural anthropology', 'Legal seminars', 'Ethical debates', 'Educational technology',
      'Literature appreciation', 'Scientific research', 'Academic publishing', 'Data analysis workshops', 'Chemistry experiments',
      'Physics lectures', 'Climate change discussions', 'Medical ethics debates', 'Genetics research', 'Linguistic analysis',
      'Political science forums',
    ],
  };

  bool canProceed() {
    return selectedHobby != null &&
        selectedSport != null &&
        selectedCultural != null &&
        selectedIntellectual != null;
  }

  bool showFab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Interests'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            if (scrollNotification.metrics.pixels > 100) {
              setState(() {
                showFab = false;
              });
            } else {
              setState(() {
                showFab = true;
              });
            }
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                      ),
                    ),
                    Column(
                      children: interestsOptions[interest]!.map((subInterest) {
                        return RadioListTile(
                          title: Row(
                            children: [
                              Icon(Icons.star),
                              SizedBox(width: 8),
                              Text(
                                subInterest,
                                style: TextStyle(fontSize: 18),
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
      ),
      floatingActionButton: showFab
          ? FloatingActionButton.extended(
        onPressed: canProceed()
            ? () {
          // Perform actions when the button is pressed
          print('Selected Hobby: $selectedHobby');
          print('Selected Sport: $selectedSport');
          print('Selected Cultural: $selectedCultural');
          print('Selected Intellectual: $selectedIntellectual');

          // Navigate to the recommendation page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewRecommendationPage(),
            ),
          );
        }
            : null,
        label: Text('View Recommendation'),
        icon: Icon(Icons.arrow_forward),
        backgroundColor: Colors.orange,
      )
          : null,
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

class ViewRecommendationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Recommendations'),
      ),
      body: Center(
        child: Text('Your Recommendations will be displayed here.'),
      ),
    );
  }
}
