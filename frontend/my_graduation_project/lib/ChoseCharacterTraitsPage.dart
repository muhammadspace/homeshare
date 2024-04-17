import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'ChooseInterestsPage.dart';

class ChooseCharacterTraitsPage extends StatefulWidget {
  String username , email , password,job,gender,type;
  DateTime? dob;
  File? image;
  ChooseCharacterTraitsPage({Key? key,required this.username,required this.email,required this.password,required this.image,required this.dob,required this.job,required this.gender,required this.type}) : super(key: key);
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
      'Introverted', 'Extroverted', 'Optimistic', 'Pessimistic', 'Assertive', 'Reserved', 'Outgoing', 'Adventurous',
      'Cautious', 'Ambitious', 'Easygoing', 'Conscientious', 'Spontaneous', 'Analytical', 'Creative', 'Humble', 'Confident',
      'Compassionate', 'Independent', 'Sensitive',
    ],
    'Values and Beliefs': [
      'Empathy', 'Honesty', 'Loyalty', 'Respect', 'Integrity', 'Compassion', 'Equality', 'Justice', 'Responsibility',
      'Tolerance', 'Forgiveness', 'Courage', 'Generosity', 'Gratitude', 'Humility', 'Environmentalism', 'Spirituality',
      'Freedom', 'Innovation', 'Tradition',
    ],
    'Work Ethic': [
      'Diligence', 'Reliability', 'Discipline', 'Motivation', 'Initiative', 'Time management', 'Perseverance', 'Accountability',
      'Efficiency', 'Professionalism', 'Organization', 'Focus', 'Goal-oriented', 'Resilience', 'Consistency', 'Independence',
      'Resourcefulness', 'Commitment', 'Adaptability', 'Ethical conduct',
    ],
    'Interpersonal Skills': [
      'Communication', 'Active listening', 'Collaboration', 'Diplomacy', 'Negotiation', 'Empathy', 'Conflict resolution',
      'Teamwork', 'Leadership', 'Networking', 'Persuasion', 'Flexibility', 'Patience', 'Tact', 'Adaptability',
      'Relationship-building', 'Social intelligence', 'Cultural sensitivity', 'Assertiveness', 'Feedback acceptance',
    ],
  };




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose the personality traits of the residents in your property',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
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
                      ),
                    ),
                    Column(
                      children: characterTraitsOptions[category]!.map((trait) {
                        return RadioListTile(
                          title: Row(
                            children: [
                              Icon(Icons.star),
                              SizedBox(width: 8),
                              Text(
                                trait,
                                style: TextStyle(fontSize: 18),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: selectedPersonalityTrait != null &&
            selectedValueBelief != null &&
            selectedWorkEthic != null &&
            selectedInterpersonalSkill != null
            ? () {
          print('Selected Personality Trait: $selectedPersonalityTrait');
          print('Selected Value and Belief: $selectedValueBelief');
          print('Selected Work Ethic: $selectedWorkEthic');
          print('Selected Interpersonal Skill: $selectedInterpersonalSkill');
          List<String> characterTraits = ['$selectedPersonalityTrait','$selectedValueBelief','$selectedWorkEthic','$selectedInterpersonalSkill'];
          // Navigate to the recommendation page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChooseInterestsPage(username: widget.username, email: widget.email, password: widget.password,image: widget.image , dob:widget.dob,job:widget.job,gender:widget.gender,type:widget.type,traitsarray:characterTraits),
            ),
          );
        }
            : null,
        label: Text('View Recommendation'),
        icon: Icon(Icons.arrow_forward),
        backgroundColor: selectedPersonalityTrait != null &&
            selectedValueBelief != null &&
            selectedWorkEthic != null &&
            selectedInterpersonalSkill != null
            ? Colors.orange
            : Colors.grey,
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
