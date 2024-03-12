import 'package:flutter/material.dart';

class CharacterTraitsPage extends StatefulWidget {
  @override
  _CharacterTraitsPageState createState() => _CharacterTraitsPageState();
}

class _CharacterTraitsPageState extends State<CharacterTraitsPage> {
  List<String> selectedPersonalityTraits = [];
  List<String> selectedValuesBeliefs = [];

  Map<String, List<String>> characterTraitsOptions = {
    'Personality Traits': [
      'Introverted',
      'Extroverted',
      'Optimistic',
      'Pessimistic',
      'Assertive',
      'Reserved',
      'Outgoing',
      'Adventurous',
      'Cautious',
      'Ambitious',
      'Easygoing',
      'Conscientious',
      'Spontaneous',
      'Analytical',
      'Creative',
      'Humble',
      'Confident',
      'Compassionate',
      'Independent',
      'Sensitive',
    ],
    'Values and Beliefs': [
      'Empathy',
      'Honesty',
      'Loyalty',
      'Respect',
      'Integrity',
      'Compassion',
      'Equality',
      'Justice',
      'Responsibility',
      'Tolerance',
      'Forgiveness',
      'Courage',
      'Generosity',
      'Gratitude',
      'Humility',
      'Environmentalism',
      'Spirituality',
      'Freedom',
      'Innovation',
      'Tradition',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Top Character Traits'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: characterTraitsOptions.keys.map((category) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select your character traits in $category:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: characterTraitsOptions[category]!.map((trait) {
                      return CheckboxListTile(
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
                        value: category == 'Personality Traits'
                            ? selectedPersonalityTraits.contains(trait)
                            : selectedValuesBeliefs.contains(trait),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              if (category == 'Personality Traits') {
                                selectedPersonalityTraits.add(trait);
                              } else {
                                selectedValuesBeliefs.add(trait);
                              }
                            } else {
                              if (category == 'Personality Traits') {
                                selectedPersonalityTraits.remove(trait);
                              } else {
                                selectedValuesBeliefs.remove(trait);
                              }
                            }
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: selectedPersonalityTraits.isNotEmpty &&
            selectedValuesBeliefs.isNotEmpty
            ? () {
          print('Selected Personality Traits: $selectedPersonalityTraits');
          print('Selected Values and Beliefs: $selectedValuesBeliefs');
          // انتقال إلى صفحة التوصيات
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopRecommendationsPage(),
            ),
          );
        }
            : null,
        label: Text('View Recommendation'),
        icon: Icon(Icons.arrow_forward),
        backgroundColor: selectedPersonalityTraits.isNotEmpty &&
            selectedValuesBeliefs.isNotEmpty
            ? Colors.orange
            : Colors.grey,
      ),
    );
  }
}

class TopRecommendationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Recommendations for You'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Top Recommendations for You',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            RecommendationCard(
              title: 'Recommendation 1',
              description: 'Description for Recommendation 1.',
            ),
            RecommendationCard(
              title: 'Recommendation 2',
              description: 'Description for Recommendation 2.',
            ),
            RecommendationCard(
              title: 'Recommendation 3',
              description: 'Description for Recommendation 3.',
            ),
          ],
        ),
      ),
    );
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