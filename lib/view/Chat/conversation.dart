import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawasul_application/view/Chat/chat.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final List<Map<String, dynamic>> _messages = [
    {'text': '👋 Hello! I\'m TawaBot, your virtual assistant.', 'isBot': true},
    {
      'text':
          'How can I help you today?\n• Return or Exchange\n• FAQs\n• Contact Support',
      'isBot': true,
    },
  ];

  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isBot': false});
    });

    _controller.clear();

    // Simulate bot response
    Future.delayed(const Duration(milliseconds: 600), () {
      _handleBotResponse(text.toLowerCase());
    });
  }

  void _handleBotResponse(String userInput) {
    String response;

    if (userInput.contains('return')) {
      response = '''Our return policy is simple:
• Timeframe: You can return items within 14 days of delivery.
• Condition: Items must be unused and in their original packaging.
• Process: Initiate a return via your Order History or contact support.

Would you like to start a return request?''';
    } else {
      response = 'Got it! Let me know if you need anything else. 😊';
    }

    setState(() {
      _messages.add({'text': response, 'isBot': true});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF008AD2),
      appBar: AppBar(
        backgroundColor: Color(0xFF008AD2),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15, top: 15),
          child: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF008AD2),
              ),
              onPressed: () => Chat(),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Chat with Tawasul',
            style: TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment:
                      message['isBot']
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        message['isBot']
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                    children: [
                      if (message['isBot'])
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Image.asset(
                            'assets/images/chat.png',
                            height: 30,
                          ),
                        ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(
                                message['isBot'] ? 0 : 16,
                              ),
                              bottomRight: Radius.circular(
                                message['isBot'] ? 16 : 0,
                              ),
                            ),
                          ),
                          child: Text(message['text']),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Row(
        children: [
          Container(
            width: 268.w,
            height: 45.h,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF008AD2),
                  radius: 16,
                  child: Icon(
                    Icons.add,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write your message',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              _sendMessage(_controller.text);
            },
            child: Icon(
              Icons.send,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 47,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
