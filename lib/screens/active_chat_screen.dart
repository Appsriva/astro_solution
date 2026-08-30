import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class ActiveChatScreen extends StatefulWidget {
  final String astrologerName;
  final String specialty;
  final String packageName;
  final String durationText;

  const ActiveChatScreen({
    super.key,
    required this.astrologerName,
    required this.specialty,
    required this.packageName,
    required this.durationText,
  });

  @override
  State<ActiveChatScreen> createState() => _ActiveChatScreenState();
}

class _ActiveChatScreenState extends State<ActiveChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _sessionSeconds = 0;
  Timer? _sessionTimer;

  final supabase = Supabase.instance.client;
  final List<ChatMessage> _messages = [];

  final List<String> _quickPrompts = [
    "नमस्ते गुरु जी 🙏",
    "मेरा विवाह कब होगा?",
    "करियर व नौकरी में तरक्की के योग?",
    "क्या मुझ पर कोई ग्रह दोष है?",
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
    _loadInitialGreeting();
  }

  void _startTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _sessionSeconds++;
        });
      }
    });
  }

  void _loadInitialGreeting() {
    final greetingText =
        "नमस्ते! मैं ${widget.astrologerName} हूँ। आपका स्वागत है। कृपया अपना नाम, जन्म तिथि (DOB) और अपना मुख्य प्रश्न बताएं। 🚩";
    setState(() {
      _messages.add(
        ChatMessage(
          text: greetingText,
          isUser: false,
          time: _getCurrentTime(),
        ),
      );
    });
  }

  String _formatTimer(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }

  void _sendMessage([String? customText]) {
    final textToSend = (customText ?? _msgController.text).trim();
    if (textToSend.isEmpty) return;

    _msgController.clear();

    // 1. UI पर तुरंत मैसेज दिखाएं
    setState(() {
      _messages.add(
        ChatMessage(
          text: textToSend,
          isUser: true,
          time: _getCurrentTime(),
        ),
      );
    });
    _scrollToBottom();

    // 2. Supabase में बैकग्राउंड सेव
    final user = supabase.auth.currentUser;
    if (user != null) {
      supabase.from('chat_messages').insert({
        'sender_id': user.id,
        'receiver_name': widget.astrologerName,
        'message': textToSend,
        'is_astrologer': false,
      }).catchError((err) {
        debugPrint("Chat message save error: $err");
      });
    }

    // 3. ज्योतिषी का रियल-टाइम ऑटो उत्तर
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      final replyText =
          "मैंने आपकी बात नोट कर ली है। मैं आपकी कुंडली और ग्रहों की स्थिति का विश्लेषण कर रहा हूँ, कृपया 1 मिनट प्रतीक्षा करें...";

      setState(() {
        _messages.add(
          ChatMessage(
            text: replyText,
            isUser: false,
            time: _getCurrentTime(),
          ),
        );
      });
      _scrollToBottom();

      // ज्योतिषी का रिप्लाई भी डेटाबेस में सेव
      if (user != null) {
        supabase.from('chat_messages').insert({
          'sender_id': user.id,
          'receiver_name': widget.astrologerName,
          'message': replyText,
          'is_astrologer': true,
        }).catchError((err) {
          debugPrint("Astro reply save error: $err");
        });
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leadingWidth: 36,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: kTextColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 19,
                  backgroundColor: Color(0xFFFFF0E6),
                  child: Icon(Icons.person_rounded,
                      color: kPrimaryBhagwa, size: 24),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.shade700,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.astrologerName,
                    style: const TextStyle(
                        color: kTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "ऑनलाइन • ${widget.packageName}",
                    style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: kPrimaryBhagwa.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kPrimaryBhagwa.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined,
                    color: kPrimaryBhagwa, size: 13),
                const SizedBox(width: 4),
                Text(
                  _formatTimer(_sessionSeconds),
                  style: const TextStyle(
                      color: kPrimaryBhagwa,
                      fontWeight: FontWeight.bold,
                      fontSize: 11),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("चैट परामर्श समाप्त हुआ (Chat Ended)"),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            child: const Text(
              "समाप्त",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
            color: Colors.amber.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.verified_user_rounded, color: Colors.green, size: 13),
                SizedBox(width: 5),
                Text(
                  "100% सुरक्षित एवं निजी चैट परामर्श 🕉️",
                  style: TextStyle(
                      color: Color(0xFF5D4037),
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _quickPrompts.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(_quickPrompts[index]),
                    labelStyle: const TextStyle(
                        color: kTextColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.orange.shade200),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    onPressed: () => _sendMessage(_quickPrompts[index]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryBhagwa.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.attachment_rounded,
                          color: kPrimaryBhagwa, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("कुंडली/जन्म पत्रिका अटैच करें")),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F4F0),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _msgController,
                        style: const TextStyle(fontSize: 13, color: kTextColor),
                        decoration: const InputDecoration(
                          hintText: "अपना प्रश्न यहाँ टाइप करें...",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [kPrimaryBhagwa, kDeepSaffron],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.76),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        decoration: BoxDecoration(
          color: msg.isUser ? const Color(0xFFFFECE0) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
            bottomRight: Radius.circular(msg.isUser ? 4 : 16),
          ),
          border: Border.all(
            color: msg.isUser
                ? kPrimaryBhagwa.withValues(alpha: 0.3)
                : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: const TextStyle(
                  color: kTextColor, fontSize: 13, height: 1.35),
            ),
            const SizedBox(height: 4),
            Text(
              msg.time,
              style: TextStyle(
                  color: kSubTextColor.withValues(alpha: 0.7), fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}