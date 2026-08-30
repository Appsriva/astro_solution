import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);

class CustomerSupportScreen extends StatefulWidget {
  const CustomerSupportScreen({super.key});

  @override
  State<CustomerSupportScreen> createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _chatController = TextEditingController();

  final List<Map<String, String>> _chatMessages = [
    {"sender": "support", "text": "नमस्ते! एस्टो सॉल्यूशन सपोर्ट में आपका स्वागत है। हम आपकी क्या सहायता कर सकते हैं?"},
  ];

  final String supportPhone = "+91 98765 43210";
  final String supportEmail = "support@astrosolution.app";
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _issueController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  Future<void> _submitProblemReport() async {
    final text = _issueController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("कृपया अपनी समस्या या विवरण दर्ज करें!"), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        // Insert ticket into Supabase support_tickets table
        await supabase.from('support_tickets').insert({
          'user_id': user.id,
          'category': 'App Support Query',
          'message': text,
          'status': 'Pending',
        });
      }
    } catch (_) {}

    _issueController.clear();
    FocusScope.of(context).unfocus();

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("टिकट सफलतापूर्वक दर्ज हुई! 🎫", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: const Text("हमारी सपोर्ट टीम को आपकी समस्या मिल गई है। 15 मिनट के भीतर हमारी टीम आपसे संपर्क करेगी।", style: TextStyle(fontSize: 12, height: 1.4)),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBhagwa, foregroundColor: Colors.white),
            child: const Text("ठीक है"),
          ),
        ],
      ),
    );
  }

  void _sendChatMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _chatMessages.add({"sender": "user", "text": text});
      _chatController.clear();

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _chatMessages.add({"sender": "support", "text": "धन्यवाद जानकारी देने के लिए। इस पर तुरंत कार्रवाई की जा रही है।"});
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPrimaryBhagwa, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "24x7 ग्राहक सहायता (Support) 🎧",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: kPrimaryBhagwa,
          unselectedLabelColor: kSubTextColor,
          indicatorColor: kPrimaryBhagwa,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "रिपोर्ट समस्या ⚠️"),
            Tab(text: "लाइव चैट 💬"),
            Tab(text: "कॉल सपोर्ट 📞"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Report a Problem
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.report_problem_rounded, color: kPrimaryBhagwa, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "क्या आपको पेमेंट, रिचार्ज, पंडित बुकिंग या आर्डर में कोई दिक्कत आ रही है? यहाँ रिपोर्ट करें।",
                          style: TextStyle(fontSize: 11.5, color: kTextColor, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text("समस्या का विवरण (Describe your issue):", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                const SizedBox(height: 8),
                TextField(
                  controller: _issueController,
                  maxLines: 5,
                  style: const TextStyle(fontSize: 12, color: kTextColor),
                  decoration: InputDecoration(
                    hintText: "यहाँ अपनी समस्या विस्तार से लिखें...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.orange.shade200)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.orange.shade200)),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitProblemReport,
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: const Text("समस्या दर्ज करें (Submit Ticket)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBhagwa,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab 2: Live Chat with Support
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: _chatMessages.length,
                  itemBuilder: (context, index) {
                    final msg = _chatMessages[index];
                    final isUser = msg["sender"] == "user";

                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isUser ? const Color(0xFFFFF3E0) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isUser ? Colors.orange.shade200 : Colors.grey.shade300),
                        ),
                        child: Text(
                          msg["text"] ?? "",
                          style: const TextStyle(fontSize: 12, color: kTextColor, height: 1.3),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.orange.shade200))),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        style: const TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: "सपोर्ट एजेंट से कुछ पूछें...",
                          filled: true,
                          fillColor: const Color(0xFFFFF9F4),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: kPrimaryBhagwa,
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                        onPressed: _sendChatMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Tab 3: Call Support
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFFFCC80)),
                    boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 3))],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(color: Color(0xFFFFF0E6), shape: BoxShape.circle),
                        child: const Icon(Icons.phone_in_talk_rounded, color: kPrimaryBhagwa, size: 36),
                      ),
                      const SizedBox(height: 14),
                      const Text("कस्टमर केयर हेल्पलाइन नंबर", style: TextStyle(fontSize: 13, color: kSubTextColor, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        supportPhone,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPrimaryBhagwa, letterSpacing: 1.1),
                      ),
                      const SizedBox(height: 8),
                      const Text("समय: सुबह 08:00 AM से रात्रि 10:00 PM तक (24x7 इमरजेंसी सपोर्ट उपलब्ध)", textAlign: TextAlign.center, style: TextStyle(fontSize: 10.5, color: Colors.grey)),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("कॉल कनेक्ट हो रही है: $supportPhone"), backgroundColor: Colors.green.shade700),
                            );
                          },
                          icon: const Icon(Icons.call_rounded, size: 18),
                          label: const Text("अभी कॉल करें (Direct Call)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9F4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.email_outlined, color: kPrimaryBhagwa, size: 22),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("ईमेल सहायता:", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kSubTextColor)),
                          Text(supportEmail, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}