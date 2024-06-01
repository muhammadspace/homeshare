import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_graduation_project/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ProfilePage.dart';
import 'home.dart';


class ProfileEditPage extends StatefulWidget {
  final String id,token , name ,email ,DOB ,job ,gender, type, hobbies, sports, cultural, intellectual,
      value_belief ,interpersonal_skill , work_ethic ,personality_trait;

  ProfileEditPage({required this.id, required this.token,required this.name,required this.email,required this.DOB
    ,required this.job,required this.gender,required this.type
    ,required this.hobbies,required this.sports,required this.cultural,required this.intellectual
    ,required this.work_ethic,required this.interpersonal_skill,required this.value_belief,required this.personality_trait});
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  Future<void> edit(String token) async {
    //void userdata(String token, Map<String, dynamic> id) async {
    final response = await http.post(
      Uri.parse(updpro_url),
      headers: {'Content-Type': 'application/json','Authorization':'Bearer $token'},
      body: jsonEncode({'username': _usernameController.text,
        'dob':_selectedDOB.toString(),
        'email':_emailController.text,
        'gender':_selectedGender.toString(),
        'type': _selectedType.toString(),
        'cultural_artistic':_selectedCultural.toString(),
        'intellectual_academic':_selectedIntellectual.toString(),
        'hobbies_pastimes' : _selectedHobby.toString(),
        'sports_activities': _selectedSport.toString(),
        'personality_trait': _selectedpersonality_trait.toString(),
        'value_belief' : _selectedvalue_belief.toString(),
        'interpersonal_skill' :_selectedinterpersonal_skill.toString(),
        'work_ethic':_selectedwork_ethic.toString()
      }),
    );

    if (response.statusCode == 200) {
      //return result;
      //,intrests:$intrests,traits:$traits
    } else {
      throw Exception('cant get the data');
    }
  }

/*
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _hobbiesController = TextEditingController();
  TextEditingController _sportsController = TextEditingController();
  TextEditingController _culturalController = TextEditingController();
  TextEditingController _intellectualController = TextEditingController();

  DateTime _selectedDOB = DateTime.parse(widget.DOB); // Initialize with current date
  String _selectedGender = widget.gender; // Variable to hold selected gender
  String _selectedType = widget.type; // Variable to hold selected type
  String _selectedCultural = widget.cultural; // Variable to hold selected cultural activity
  String _selectedIntellectual = widget.intellectual; // Variable to hold selected intellectual interest

  String? _selectedHobby = widget.hobbies; // Variable to hold selected hobby
  String? _selectedSport = widget.sports; // Variable to hold selected sport*/

  // List of hobbies and pastimes options
  late TextEditingController _usernameController;
  late TextEditingController _dobController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _hobbiesController;
  late TextEditingController _sportsController;
  late TextEditingController _culturalController;
  late TextEditingController _intellectualController;

  late DateTime _selectedDOB;
  late String _selectedGender;
  late String _selectedType;
  late String _selectedCultural;
  late String _selectedIntellectual;
  String? _selectedHobby;
  String? _selectedSport;

  late String _selectedpersonality_trait;
  late String _selectedvalue_belief;
  String? _selectedinterpersonal_skill;
  String? _selectedwork_ethic;

  List<String> _hobbiesOptions = [
    "Hiking",
    "Playing chess",
    "Fishing",
    "Yoga",
    "Playing guitar",
    "Stamp collecting",
    "Knitting",
    "Woodworking",
    "Reading",
    "Sewing",
    "Birdwatching",
    "Scrapbooking",
    "Astronomy",
    "Calligraphy",
    "DIY projects",
    "Coin collecting",
    "Pottery",
    "Baking",
    "Meditation",
    "Painting",
    "Camping",
    "Ceramics",
    "Cooking",
    "Cycling",
    "Photography",
    "Antiques collecting",
    "Gardening",
    "Model building (e.g., airplanes, ships)",
    "Scuba diving",
    "Writing",
  ];

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController(text: widget.name);
    _dobController = TextEditingController(text: widget.DOB);
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController(text: widget.email);
    _hobbiesController = TextEditingController();
    _sportsController = TextEditingController();
    _culturalController = TextEditingController();
    _intellectualController = TextEditingController();

    _selectedDOB = DateTime.parse(widget.DOB);
    _selectedGender = widget.gender;
    _selectedType = widget.type;

    _selectedCultural = widget.cultural;
    _selectedIntellectual = widget.intellectual;
    _selectedHobby = widget.hobbies;
    _selectedSport = widget.sports;

    _selectedwork_ethic = widget.work_ethic;
    _selectedinterpersonal_skill = widget.interpersonal_skill;
    _selectedvalue_belief = widget.value_belief;
    _selectedpersonality_trait= widget.personality_trait;

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Username", _usernameController),
            _buildDateField("Date of Birth", _dobController),
            _buildEmailField("Email", _emailController),
            _buildGenderField("Gender"),
            //_buildTypeField("Type"),
            _buildHobbiesField("Hobbies & Pastimes"),
            _buildSportsField("Sports and Physical Activities"),
            _buildCulturalField("Cultural & Artistic"),
            _buildIntellectualField("Intellectual & Academic"),
            _buildpersonality_traitField("personality & trait"),
            _buildinterpersonal_skillField("interpersonal & skill"),
            _buildwork_ethicField("work & ethic"),
            _buildvalue_beliefField("value & belief"),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  edit(widget.token);
                  Navigator.push(
                    context ,
                    MaterialPageRoute(builder: (context) =>HomeScreen(id: widget.id, Token: widget.token)),//ProfilePage(name:'$name', DOB: DOB,job: job,gender: gender,type: type,sports: sports,hobbies:hobbies,intellectual:intellectual ,cultural:cultural ,token:Token )),
                  );
                  // Save functionality
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12),
              hintText: 'Enter $label',
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () {
            _selectDate(context, controller);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: IgnorePointer(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  hintText: 'Select $label',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDOB,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDOB) {
      setState(() {
        _selectedDOB = picked;
        controller.text = "${picked.day}/${picked.month}/${picked.year}"; // Format date as desired
      });
    }
  }



  Widget _buildEmailField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12),
              hintText: 'Enter $label',
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildGenderField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text('Male'),
                value: 'Male',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('Female'),
                value: 'Female',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTypeField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text('owner'),
                value: 'owner',
                groupValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('seeker'),
                value: 'seeker',
                groupValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHobbiesField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _hobbiesOptions.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _selectedHobby,
              onChanged: (String? value) {
                setState(() {
                  _selectedHobby = value!;
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSportsField(String label) {
    // List of sports options
    List<String> _sportsOptions = [
      "Soccer",
      "Horseback riding",
      "Karate",
      "Mountain biking",
      "Rowing",
      "Ballet",
      "Running",
      "Hip-hop dance",
      "Judo",
      "Volleyball",
      "Sailing",
      "Gymnastics",
      "Rock climbing",
      "Martial arts",
      "Snowboarding",
      "Rugby",
      "Kickboxing",
      "Skateboarding",
      "Ultimate Frisbee",
      "Cycling",
      "Surfing",
      "Archery",
      "Tennis",
      "Swimming",
      "Skiing",
      "Yoga",
      "Triathlons",
      "Fencing",
      "Basketball",
      "Golf",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _sportsOptions.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _selectedSport,
              onChanged: (String? value) {
                setState(() {
                  _selectedSport = value!;
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCulturalField(String label) {
    // List of cultural and artistic pursuits options
    List<String> _culturalOptions = [
      "Poetry readings",
      "Live storytelling events",
      "Jazz clubs",
      "Opera appreciation",
      "Film analysis clubs",
      "Opera",
      "Music concerts",
      "Stand-up comedy shows",
      "Theater workshops",
      "Indigenous art experiences",
      "Shakespearean plays",
      "Renaissance art appreciation",
      "Theater",
      "Pottery workshops",
      "Classical music appreciation",
      "Book clubs",
      "Cultural festivals",
      "Impressionist art appreciation",
      "Art galleries",
      "Ballet",
      "Street art tours",
      "Film festivals",
      "Photography exhibitions",
      "Poetry slams",
      "Museums",
      "Symphony orchestra performances",
      "Baroque music appreciation",
      "Calligraphy classes",
      "Sculpture gardens",
      "World music concerts",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _culturalOptions.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _selectedCultural,
              onChanged: (String? value) {
                setState(() {
                  _selectedCultural = value!;
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildIntellectualField(String label) {
    // List of intellectual and academic interests options
    List<String> _intellectualOptions = [
      "Educational technology conferences",
      "Data analysis workshops",
      "Mathematics competitions",
      "Ethical debates",
      "Political debates",
      "Physics lectures",
      "Academic publishing",
      "History lectures",
      "Genetics research",
      "Robotics competitions",
      "Computer programming hackathons",
      "Astronomy clubs",
      "Chemistry experiments",
      "Environmental sustainability workshops",
      "Political science forums",
      "Philosophy discussions",
      "Bioinformatics symposiums",
      "Legal seminars",
      "Science fiction literature",
      "Climate change discussions",
      "Linguistic analysis",
      "Sociology conferences",
      "Psychology seminars",
      "Medical ethics debates",
      "Archaeological digs",
      "Literature appreciation groups",
      "Scientific research",
      "Linguistics workshops",
      "Cultural anthropology lectures",
      "Economics forums",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _intellectualOptions.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _selectedIntellectual,
              onChanged: (String? value) {
                setState(() {
                  _selectedIntellectual = value!;
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }
  /*'personality_trait':
                        'value_belief' :
                        'interpersonal_skill' :
                        'work_ethic'*/
  Widget _buildpersonality_traitField(String label) {
    // List of cultural and artistic pursuits options
    List<String> _personality_trait = [
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
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _personality_trait.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _selectedpersonality_trait,
              onChanged: (String? value) {
                setState(() {
                  _selectedpersonality_trait = value!;
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }
  Widget _buildinterpersonal_skillField(String label) {
    // List of cultural and artistic pursuits options
    List<String> interpersonal_skill = [
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
      "Conflict resolution"
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: interpersonal_skill.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _selectedinterpersonal_skill,
              onChanged: (String? value) {
                setState(() {
                  _selectedinterpersonal_skill = value!;
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }
  Widget _buildwork_ethicField(String label) {
    // List of cultural and artistic pursuits options
    List<String> work_ethic = [
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
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: work_ethic.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _selectedwork_ethic,
              onChanged: (String? value) {
                setState(() {
                  _selectedwork_ethic = value!;
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }
  Widget _buildvalue_beliefField(String label) {
    // List of cultural and artistic pursuits options
    List<String> value_belief = [
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
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: value_belief.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _selectedvalue_belief,
              onChanged: (String? value) {
                setState(() {
                  _selectedvalue_belief = value!;
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}