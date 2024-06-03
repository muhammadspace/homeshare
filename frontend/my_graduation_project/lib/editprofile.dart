import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_graduation_project/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'home.dart';
import 'dart:typed_data';


class ProfileEditPage extends StatefulWidget {
  final String id, token, name, email, DOB, job, gender, type, hobbies, sports, cultural, intellectual,
      value_belief, interpersonal_skill, work_ethic, personality_trait,image_id;
  Uint8List? your_image;

  ProfileEditPage({
    required this.id,
    required this.token,
    required this.name,
    required this.email,
    required this.DOB,
    required this.job,
    required this.gender,
    required this.type,
    required this.hobbies,
    required this.sports,
    required this.cultural,
    required this.intellectual,
    required this.work_ethic,
    required this.interpersonal_skill,
    required this.value_belief,
    required this.personality_trait,
    required this.your_image,
    required this.image_id
  });

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  String image_id = '';
  File? _imageFile;

  Future<void> uploadImage(File imageFile) async {
    //String url = "http://192.168.1.53:3000/uploads";
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
        image_id = decodedResp['_id'];
      });
      print('Upload success: $image_id');
      print(decodedResp);
    } else {
      print('Upload failed with status: ${response.statusCode}');
    }
  }

  Future<void> edit(String token) async {
    String checkifnull = image_id;
    if(image_id=='x'){
      checkifnull='';
    }
    final response = await http.post(
      Uri.parse(updpro_url),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({
        if(_usernameController.text!='')
        'username': _usernameController.text,
        if(_selectedDOB.toString()!='')
        'dob': _selectedDOB.toString(),
        if(_emailController.text!='')
        'email': _emailController.text,
        if(_selectedGender.toString()!='')
        'gender': _selectedGender.toString(),
        if(_selectedType.toString()!='')
        'type': _selectedType.toString(),
        if(_selectedCultural.toString()!='')
        'cultural_artistic': _selectedCultural.toString(),
        if(_selectedIntellectual.toString()!='')
        'intellectual_academic': _selectedIntellectual.toString(),
        if(_selectedHobby.toString()!='')
        'hobbies_pastimes': _selectedHobby.toString(),
        if(_selectedSport.toString()!='')
        'sports_activities': _selectedSport.toString(),
        if(_selectedpersonality_trait.toString()!='')
        'personality_trait': _selectedpersonality_trait.toString(),
        if(_selectedvalue_belief.toString()!='')
        'value_belief': _selectedvalue_belief.toString(),
        if(_selectedinterpersonal_skill.toString()!='')
        'interpersonal_skill': _selectedinterpersonal_skill.toString(),
        if(_selectedwork_ethic.toString()!='')
        'work_ethic': _selectedwork_ethic.toString(),
        if(checkifnull!='')
        'picture': checkifnull, // Add this line to update the image ID
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
    } else {
      throw Exception('Cannot update the data');
    }
  }

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
    // List of hobbies
  ];

  @override
  void initState() {
    super.initState();
      image_id = widget.image_id;
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
    _selectedpersonality_trait = widget.personality_trait;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await uploadImage(_imageFile!);
    }
  }

  @override
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
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: widget.your_image != null
                      ? MemoryImage(widget.your_image!)
                      : NetworkImage('https://cdn-icons-png.flaticon.com/512/147/147140.png')as ImageProvider,
                  child: _imageFile == null && widget.your_image == null
                      ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildTextField("Username", _usernameController),
            _buildDateField("Date of Birth", _dobController),
            _buildEmailField("Email", _emailController),
            _buildGenderField("Gender"),
            //_buildTypeField("Type"),
            _buildHobbiesField("Hobbies & Pastimes"),
            _buildSportsField("Sports and Physical Activities"),
            _buildCulturalField("Cultural & Artistic"),
            _buildIntellectualField("Intellectual & Academic"),
            _buildpersonality_traitField("Personality & Trait"),
            _buildinterpersonal_skillField("Interpersonal & Skill"),
            _buildwork_ethicField("Work & Ethic"),
            _buildvalue_beliefField("Value & Belief"),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  edit(widget.token);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(id: widget.id, Token: widget.token)),
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