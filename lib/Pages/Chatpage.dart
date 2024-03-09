// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, file_names

// ignore: depend_on_referenced_packages
import '../consts.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final OpenAI _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 5),
    ),
    enableLog: true,
  );
  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'Jeeva', lastName: 'Unom');
  final ChatUser _chatBox =
      ChatUser(id: '2', firstName: 'Chat', lastName: 'Box');

  final List<ChatMessage> _messages = <ChatMessage>[];
  final List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 166, 126, 1),
          title: const Text('Chatbox', style: TextStyle(color: Colors.white)),
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          child: DashChat(
            currentUser: _currentUser,
            messageOptions: const MessageOptions(
              currentUserContainerColor: Colors.black,
              containerColor: Color.fromRGBO(0, 166, 126, 1),
              textColor: Colors.white,
            ),
            onSend: (ChatMessage m) {
              getChatResponse(m);
            },
            messages: _messages,
          ),
        ));
  }

  Future<void> getChatResponse(ChatMessage m) async {
    try {
      setState(() {
        _messages.insert(0, m);
        _typingUsers.add(_chatBox);
      });

      // Convert ChatMessage objects to Map<String, dynamic> for OpenAI API
      List<Map<String, dynamic>> _messagesHistory = _messages.reversed.map((m) {
        String role;
        if (m.user == _currentUser) {
          role = 'user';
        } else {
          role = 'assistant';
        }
        return {'role': role, 'content': m.text};
      }).toList();

      // Prepare request for OpenAI API
      final request = ChatCompleteText(
        model: GptTurbo0301ChatModel(),
        messages: _messagesHistory,
        maxToken: 2000,
      );

      // Call OpenAI API to get response
      final response = await _openAI.onChatCompletion(request: request);

      if (response != null && response.choices.isNotEmpty) {
        for (var element in response.choices) {
          if (element.message != null) {
            setState(() {
              _messages.insert(
                0,
                ChatMessage(
                  user: _chatBox,
                  createdAt: DateTime.now(),
                  text: element.message!.content,
                ),
              );
            });
          }
        }
      } else {
        print('No response from OpenAI.');
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error in getChatResponse: $e');
      //  show an error message to the user
    }
  }
}
