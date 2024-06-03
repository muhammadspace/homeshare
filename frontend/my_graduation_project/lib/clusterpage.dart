import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'config.dart';
import 'fadelinleft.dart';

class ClusterPage extends StatefulWidget {
  final String Token;
  final String id;

  ClusterPage({required this.Token, required this.id});

  @override
  _ClusterPageState createState() => _ClusterPageState();
}

class _ClusterPageState extends State<ClusterPage> {
  List<dynamic> clusteringData = [];

  Future<void> clustering() async {
    final response = await http.get(
      Uri.parse(clustersurl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.Token}'
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        clusteringData = result;
      });
    } else {
      throw Exception('Cannot fetch pending apartments');
    }
  }

  @override
  void initState() {
    super.initState();
    clustering();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clustering Page'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://i.pinimg.com/736x/43/0f/6e/430f6ecd9ea1bc9ec7913684e9a4f3fe.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                child: clusteringData.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Number of Clusters',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Number of People',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    for (int i = 0; i < clusteringData.length; i++)
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Cluster number ${i + 1}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'The number of people in this cluster is ${clusteringData[i]}'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
