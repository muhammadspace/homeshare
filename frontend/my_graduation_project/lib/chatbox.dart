import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final String token;

  ChatPage({required this.token});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class ChatMessage {
  String text;
  bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _controller = TextEditingController();
  List<ChatMessage> messages = [];

  Future<void> chatbox(String sentence) async {
    final typeurl = 'http://10.0.2.2:5000/chat';
    setState(() {
      messages.add(ChatMessage(text: sentence, isUser: true));
    });
    try {
      final response = await http.post(
        Uri.parse(typeurl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'message': sentence}),
      );
      print('Request sent: $sentence');
      if (response.statusCode == 200) {
        final result = response.body;
        final jsonResponse = json.decode(result);
        setState(() {
          messages.add(ChatMessage(text: jsonResponse['response'], isUser: false));
        });
        print('Response received: ${jsonResponse['response']}');
      } else {
        print('Server error: ${response.statusCode} ${response.reasonPhrase}');
        throw Exception('Error in the chat box: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: message.isUser
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: message.isUser ? Colors.blueAccent : Colors.grey[300],
        borderRadius: message.isUser
            ? BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        )
            : BorderRadius.only(
          topRight: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0),
        ),
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: message.isUser ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Box'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessage(messages[index]);
                },
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Type your message',
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                if (_controller.text.trim().isNotEmpty) {
                  await chatbox(_controller.text);
                  setState(() {
                    _controller.clear();
                  });
                }
              },
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
