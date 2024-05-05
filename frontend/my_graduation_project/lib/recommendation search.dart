import 'package:flutter/material.dart';
import 'recommendationsystem.dart';
import 'package:my_graduation_project/TopRecommendationsPage.dart';
import 'preference.dart';
import 'package:my_graduation_project/Toprecommendationforseekers.dart';

class SearchPage extends StatefulWidget {
  final String senderid, type, token;

  SearchPage({required this.type, required this.senderid, required this.token});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://i.pinimg.com/474x/ba/2b/e1/ba2be18dd28516a8a813b256dcf4fec2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  if (widget.type == 'owner') {
                    final List<dynamic> seekersdata = await searchseekerinterest(widget.senderid);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopRecommendationsPage(
                          recommendations: seekersdata,
                          senderid: widget.senderid,
                          token: widget.token,
                        ),
                      ),
                    );
                  } else if (widget.type == 'seeker') {
                    final List<dynamic> ownersdata = await searchownerinterest(widget.senderid);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopRecommendationseekers(
                          recommendations: ownersdata,
                          senderid: widget.senderid,
                          token: widget.token,
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  'Search with Interests',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  if (widget.type == 'owner') {
                    final List<dynamic> seekersdata = await searchseekertraits(widget.senderid);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopRecommendationsPage(
                          recommendations: seekersdata,
                          senderid: widget.senderid,
                          token: widget.token,
                        ),
                      ),
                    );
                  } else if (widget.type == 'seeker') {
                    final List<dynamic> ownersdata = await searchownertraits(widget.senderid);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopRecommendationseekers(
                          recommendations: ownersdata,
                          senderid: widget.senderid,
                          token: widget.token,
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  'Search with Traits',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}