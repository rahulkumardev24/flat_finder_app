import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dash_chat_2/dash_chat_2.dart';

import '../utils/custom_text_style.dart';
import '../utils/urls.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> messages = [];
  List<ChatUser> _typing = [];

  final ChatUser mySelf = ChatUser(id: "1", firstName: "Rahul");
  final ChatUser bot = ChatUser(id: "2", firstName: "flatFinder");

  Future<void> getData(ChatMessage m) async {
    _typing.add(bot);
    messages.insert(0, m);
    setState(() {});
    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };
    try {
      final response = await http.post(
        Uri.parse("${Urls.geminiBaseUrl}?key=${Urls.geminiApiKey}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result != null && result.containsKey('candidates')) {
          String botResponseText =
          result['candidates'][0]['content']['parts'][0]['text'];
          ChatMessage botMessage = ChatMessage(
            text: botResponseText,
            user: bot,
            createdAt: DateTime.now(),
          );
          messages.insert(0, botMessage);
        }
      } else {
        messages.insert(
          0,
          ChatMessage(
            text: "Error fetching response. Please try again!",
            user: bot,
            createdAt: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      messages.insert(
        0,
        ChatMessage(
          text: "Something went wrong! Check your internet connection.",
          user: bot,
          createdAt: DateTime.now(),
        ),
      );
    } finally {
      _typing.remove(bot);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /// ---- Appbar ----------///
      appBar: AppBar(
        title: Text(
          "Chat with bot",
          style: myTextStyle18(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,

        backgroundColor: Colors.tealAccent,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: DashChat(
                  typingUsers: _typing,
                  currentUser: mySelf,
                  onSend: (ChatMessage m) {
                    getData(m);
                  },
                  messages: messages,
                  inputOptions: InputOptions(
                    alwaysShowSend: true,
                    autocorrect: true,
                    inputTextStyle: const TextStyle(fontSize: 16),
                    cursorStyle: const CursorStyle(color: Colors.tealAccent),
                    inputDecoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.tealAccent.shade100,
                      hintText: "Type a message...",
                      hintStyle: myTextStyle15(),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  messageOptions: MessageOptions(
                    currentUserContainerColor: Colors.teal,
                    containerColor: Colors.black45,
                    textColor: Colors.white,
                    borderRadius: 12,
                    timePadding: const EdgeInsets.all(6),
                    avatarBuilder: (user, _, __) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                          backgroundColor:
                          user.id == mySelf.id ? Colors.black45 : Colors.black45,
                          child: Image.asset("assets/images/logo_nobg.png")
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
