import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'ChooseInterestsPage.dart';

class ChooseCharacterTraitsPage extends StatefulWidget {
  final String username, email, password, job, gender, type;
  final DateTime? dob;
  final String image;

  ChooseCharacterTraitsPage({
    Key? key,
    required this.username,
    required this.email,
    required this.password,
    required this.image,
    required this.dob,
    required this.job,
    required this.gender,
    required this.type,
  }) : super(key: key);

  @override
  _ChooseCharacterTraitsPageState createState() => _ChooseCharacterTraitsPageState();
}

class _ChooseCharacterTraitsPageState extends State<ChooseCharacterTraitsPage> {
  String? selectedPersonalityTrait;
  String? selectedValueBelief;
  String? selectedWorkEthic;
  String? selectedInterpersonalSkill;

  Map<String, List<String>> characterTraitsOptions = {
    'Personality Traits': [
      "Humble",
      "Independent",
      "Spontaneous",
      "Analytical",
      "Sensitive",
      "Creative",
      "Ambitious",
      "Adventurous",
      "Confident",
      "Easygoing",
      "Reserved",
      "Conscientious",
      "Extroverted",
      "Assertive",
      "Compassionate",
      "Optimistic",
      "Introverted",
      "Pessimistic",
      "Outgoing",
      "Cautious",
    ],
    'Values and Beliefs': [
      "Tolerance",
      "Loyalty",
      "Equality",
      "Respect",
      "Forgiveness",
      "Gratitude",
      "Integrity",
      "Humility",
      "Spirituality",
      "Responsibility",
      "Environmentalism",
      "Compassion",
      "Justice",
      "Empathy",
      "Freedom",
      "Honesty",
      "Courage",
      "Generosity",
      "Innovation",
      "Tradition",
    ],
    'Work Ethic': [
      "Adaptability",
      "Time management",
      "Independence",
      "Perseverance",
      "Initiative",
      "Motivation",
      "Efficiency",
      "Commitment",
      "Resourcefulness",
      "Consistency",
      "Discipline",
      "Professionalism",
      "Reliability",
      "Focus",
      "Resilience",
      "Diligence",
      "Organization",
      "Goal-oriented",
      "Ethical conduct",
      "Accountability",
    ],
    'Interpersonal Skills': [
      "Patience",
      "Leadership",
      "Networking",
      "Negotiation",
      "Social intelligence",
      "Assertiveness",
      "Tact",
      "Active listening",
      "Feedback acceptance",
      "Empathy",
      "Adaptability",
      "Diplomacy",
      "Communication",
      "Relationship-building",
      "Cultural sensitivity",
      "Collaboration",
      "Persuasion",
      "Teamwork",
      "Flexibility",
      "Conflict resolution",
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Choose Character Traits',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: kToolbarHeight + 20), // Space for AppBar
                  Text(
                    'Choose the personality traits of the residents in your property',
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
                  SizedBox(height: 20.0),
                  ...characterTraitsOptions.keys.map((category) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select your top trait in $category:',
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
                          children: characterTraitsOptions[category]!.map((trait) {
                            return RadioListTile(
                              title: Row(
                                children: [
                                  Icon(Icons.star, color: Colors.orange),
                                  SizedBox(width: 8),
                                  Text(
                                    trait,
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ],
                              ),
                              value: trait,
                              groupValue: _getSelectedValue(category),
                              onChanged: (value) {
                                setState(() {
                                  _updateSelection(category, value.toString());
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
                ],
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
          onPressed: selectedPersonalityTrait != null &&
              selectedValueBelief != null &&
              selectedWorkEthic != null &&
              selectedInterpersonalSkill != null
              ? () {
            print('Selected Personality Trait: $selectedPersonalityTrait');
            print('Selected Value and Belief: $selectedValueBelief');
            print('Selected Work Ethic: $selectedWorkEthic');
            print('Selected Interpersonal Skill: $selectedInterpersonalSkill');
            List<String> characterTraits = [
              '$selectedPersonalityTrait',
              '$selectedValueBelief',
              '$selectedWorkEthic',
              '$selectedInterpersonalSkill'
            ];
            // Navigate to the recommendation page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChooseInterestsPage(
                  username: widget.username,
                  email: widget.email,
                  password: widget.password,
                  image: widget.image,
                  dob: widget.dob,
                  job: widget.job,
                  gender: widget.gender,
                  type: widget.type,
                  Interpersonal_Skill: '$selectedInterpersonalSkill',
                  Personality: '$selectedPersonalityTrait',
                  Value_and_Belief: '$selectedValueBelief',
                  Work_Ethic: '$selectedWorkEthic',
                ),
              ),
            );
          }
              : null,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: selectedPersonalityTrait != null &&
                selectedValueBelief != null &&
                selectedWorkEthic != null &&
                selectedInterpersonalSkill != null
                ? Colors.orange
                : Colors.grey,
          ),
          child: Text(
            'Continue',
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
        ),
      ),
    );
  }

  String? _getSelectedValue(String category) {
    switch (category) {
      case 'Personality Traits':
        return selectedPersonalityTrait;
      case 'Values and Beliefs':
        return selectedValueBelief;
      case 'Work Ethic':
        return selectedWorkEthic;
      case 'Interpersonal Skills':
        return selectedInterpersonalSkill;
      default:
        return null;
    }
  }

  void _updateSelection(String category, String value) {
    setState(() {
      switch (category) {
        case 'Personality Traits':
          selectedPersonalityTrait = value;
          break;
        case 'Values and Beliefs':
          selectedValueBelief = value;
          break;
        case 'Work Ethic':
          selectedWorkEthic = value;
          break;
        case 'Interpersonal Skills':
          selectedInterpersonalSkill = value;
          break;
      }
    });
  }
}

class RecommendationCard extends StatelessWidget {
  final String title;
  final String description;

  RecommendationCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}