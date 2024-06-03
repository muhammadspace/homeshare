import 'package:flutter/material.dart';
import 'recommendationsystem.dart';
import 'package:my_graduation_project/TopRecommendationsPage.dart';
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
      extendBodyBehindAppBar: true, // To make the AppBar transparent over the background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Search', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://static.vecteezy.com/system/resources/previews/030/314/140/non_2x/house-model-on-wood-table-real-estate-agent-offer-house-property-insurance-vertical-mobile-wallpaper-ai-generated-free-photo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
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
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
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
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}