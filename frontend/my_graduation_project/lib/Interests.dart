import 'package:flutter/material.dart';

class YourInterestsPage extends StatefulWidget {
  @override
  _YourInterestsPageState createState() => _YourInterestsPageState();
}

class _YourInterestsPageState extends State<YourInterestsPage> {
  List<String> selectedWorkEthic = [];
  List<String> selectedInterpersonalSkills = [];

  Map<String, List<String>> interestOptions = {
    'Work Ethic': [
      'Diligence',
      'Reliability',
      'Discipline',
      'Motivation',
      'Initiative',
      'Time management',
      'Perseverance',
      'Accountability',
      'Efficiency',
      'Professionalism',
      'Organization',
      'Focus',
      'Goal-oriented',
      'Resilience',
      'Consistency',
      'Independence',
      'Resourcefulness',
      'Commitment',
      'Adaptability',
      'Ethical conduct',
    ],
    'Interpersonal Skills': [
      'Communication',
      'Active listening',
      'Collaboration',
      'Diplomacy',
      'Negotiation',
      'Empathy',
      'Conflict resolution',
      'Teamwork',
      'Leadership',
      'Networking',
      'Persuasion',
      'Flexibility',
      'Patience',
      'Tact',
      'Adaptability',
      'Relationship-building',
      'Social intelligence',
      'Cultural sensitivity',
      'Assertiveness',
      'Feedback acceptance',
    ],
  };

  bool canProceed() {
    return selectedWorkEthic.isNotEmpty && selectedInterpersonalSkills.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Top Interests'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: interestOptions.keys.map((interest) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select your interests in $interest:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: interestOptions[interest]!.map((subInterest) {
                      return CheckboxListTile(
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
                        value: interest == 'Work Ethic'
                            ? selectedWorkEthic.contains(subInterest)
                            : selectedInterpersonalSkills.contains(subInterest),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              if (interest == 'Work Ethic') {
                                selectedWorkEthic.add(subInterest);
                              } else {
                                selectedInterpersonalSkills.add(subInterest);
                              }
                            } else {
                              if (interest == 'Work Ethic') {
                                selectedWorkEthic.remove(subInterest);
                              } else {
                                selectedInterpersonalSkills.remove(subInterest);
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
      floatingActionButton: canProceed()
          ? FloatingActionButton.extended(
        onPressed: () {
          // القيام بإجراء عند الضغط على الزر
          print('Selected Interests: $selectedWorkEthic, $selectedInterpersonalSkills');
          // نقل المستخدم إلى صفحة TopRecommendationsPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopRecommendationsPage(),
            ),
          );
        },
        label: Text('View Recommendation'),
        icon: Icon(Icons.arrow_forward),
        backgroundColor: Colors.orange,
      )
          : null,
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
            // أعلى التوصيات هنا
            Text(
              'Top Recommendations for You',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            // يمكنك إضافة عناصر التوصية هنا
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