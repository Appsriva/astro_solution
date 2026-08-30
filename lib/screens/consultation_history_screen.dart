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

class ConsultationLogItem {
  final String id;
  final String astrologerName;
  final String astrologerSkill;
  final String type; // 'call' or 'chat'
  final String durationText;
  final String fullFormattedDate; // ई.ग. "शनिवार, 29 अगस्त 2026 • 10:45 AM"
  final String cost;
  final List<Map<String, String>> chatMessages;

  const ConsultationLogItem({
    required this.id,
    required this.astrologerName,
    required this.astrologerSkill,
    required this.type,
    required this.durationText,
    required this.fullFormattedDate,
    required this.cost,
    required this.chatMessages,
  });
}

class ConsultationHistoryScreen extends StatefulWidget {
  const ConsultationHistoryScreen({super.key});

  @override
  State<ConsultationHistoryScreen> createState() => _ConsultationHistoryScreenState();
}

class _ConsultationHistoryScreenState extends State<ConsultationHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<ConsultationLogItem> _historyLogs = [];

  static const List<String> _hindiWeekDays = [
    "सोमवार",
    "मंगलवार",
    "बुधवार",
    "गुरुवार",
    "शुक्रवार",
    "शनिवार",
    "रविवार"
  ];

  static const List<String> _hindiMonths = [
    "जनवरी",
    "फ़रवरी",
    "मार्च",
    "अप्रैल",
    "मई",
    "जून",
    "जुलाई",
    "अगस्त",
    "सितंबर",
    "अक्टूबर",
    "नवंबर",
    "दिसंबर"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchLiveConsultations();
  }

  String _formatFullDateHindi(DateTime dt) {
    final dayName = _hindiWeekDays[dt.weekday - 1];
    final monthName = _hindiMonths[dt.month - 1];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? "PM" : "AM";

    return "$dayName, ${dt.day} $monthName ${dt.year} • $hour:$minute $period";
  }

  Future<void> _fetchLiveConsultations() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() {
          _historyLogs = [];
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final List<ConsultationLogItem> loadedLogs = [];

      // 1. Fetch Real Call Logs (Filter: duration >= 1 second)
      final callData = await supabase
          .from('call_logs')
          .select()
          .eq('user_id', user.id)
          .gt('duration_seconds', 0) // फ़ालतू 0-सेकंड की कॉल्स नहीं आएँगी
          .order('created_at', ascending: false);

      for (var item in (callData as List)) {
        final totalSeconds = (item['duration_seconds'] ?? 0) as int;
        final mins = totalSeconds ~/ 60;
        final secs = totalSeconds % 60;
        final created = DateTime.tryParse(item['created_at'] ?? '')?.toLocal() ?? DateTime.now();

        String durationDisplay;
        if (mins > 0) {
          durationDisplay = "$mins मिनट $secs सेकंड";
        } else {
          durationDisplay = "$secs सेकंड";
        }

        final amountNum = item['amount_deducted'] ?? 0;

        loadedLogs.add(
          ConsultationLogItem(
            id: item['id'].toString(),
            astrologerName: item['astrologer_name'] ?? "वैदिक ज्योतिषी",
            astrologerSkill: "${item['call_type'] ?? 'Audio'} कॉल परामर्श",
            type: "call",
            durationText: durationDisplay,
            fullFormattedDate: _formatFullDateHindi(created),
            cost: "₹$amountNum",
            chatMessages: [],
          ),
        );
      }

      // 2. Fetch Real Chat Messages grouped by Astrologer
      final chatData = await supabase
          .from('chat_messages')
          .select()
          .eq('sender_id', user.id)
          .order('created_at', ascending: true);

      final Map<String, List<Map<String, String>>> groupedChats = {};
      final Map<String, DateTime> chatLatestDates = {};

      for (var item in (chatData as List)) {
        final astro = item['receiver_name'] ?? 'ज्योतिषी';
        final isAstro = item['is_astrologer'] ?? false;
        final created = DateTime.tryParse(item['created_at'] ?? '')?.toLocal() ?? DateTime.now();

        groupedChats.putIfAbsent(astro, () => []);
        groupedChats[astro]!.add({
          "sender": isAstro ? "astrologer" : "user",
          "text": item['message'] ?? "",
        });
        chatLatestDates[astro] = created;
      }

      groupedChats.forEach((astroName, messages) {
        if (messages.isNotEmpty) {
          final lastDate = chatLatestDates[astroName] ?? DateTime.now();
          loadedLogs.add(
            ConsultationLogItem(
              id: "chat_${astroName.hashCode}",
              astrologerName: astroName,
              astrologerSkill: "चैट परामर्श एवं संपूर्ण कुंडली मार्गदर्शन",
              type: "chat",
              durationText: "${messages.length} संदेश आदान-प्रदान",
              fullFormattedDate: _formatFullDateHindi(lastDate),
              cost: "सफल सत्र",
              chatMessages: messages,
            ),
          );
        }
      });

      if (mounted) {
        setState(() {
          _historyLogs = loadedLogs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _historyLogs = [];
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openChatHistoryViewer(ConsultationLogItem log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.78,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFFFFF0E6),
                    child: Icon(Icons.chat_bubble_rounded, color: kPrimaryBhagwa, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(log.astrologerName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor)),
                        Text(log.fullFormattedDate, style: const TextStyle(fontSize: 10.5, color: kSubTextColor)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: kTextColor),
                  ),
                ],
              ),
              const Divider(height: 16),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: log.chatMessages.length,
                  itemBuilder: (context, index) {
                    final msg = log.chatMessages[index];
                    final isUser = msg["sender"] == "user";

                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isUser ? const Color(0xFFFFF3E0) : const Color(0xFFF5F5F5),
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
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final callLogs = _historyLogs.where((l) => l.type == "call").toList();
    final chatLogs = _historyLogs.where((l) => l.type == "chat").toList();

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
          "परामर्श इतिहास (Call & Chat Logs) 📜",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: kPrimaryBhagwa),
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchLiveConsultations();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: kPrimaryBhagwa,
          unselectedLabelColor: kSubTextColor,
          indicatorColor: kPrimaryBhagwa,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "सभी इतिहास"),
            Tab(text: "कॉल लॉग्स 📞"),
            Tab(text: "चैट इतिहास 💬"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryBhagwa))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildLogsList(_historyLogs),
                _buildLogsList(callLogs),
                _buildLogsList(chatLogs),
              ],
            ),
    );
  }

  Widget _buildLogsList(List<ConsultationLogItem> logs) {
    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.history_toggle_off_rounded, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text("कोई परामर्श इतिहास उपलब्ध नहीं है!",
                style: TextStyle(fontSize: 13, color: kSubTextColor, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final isCall = log.type == "call";

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kCardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFFFE0B2)),
            boxShadow: const [
              BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isCall ? const Color(0xFFFFF3E0) : const Color(0xFFE3F2FD),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCall ? Icons.phone_in_talk_rounded : Icons.chat_bubble_rounded,
                      color: isCall ? kPrimaryBhagwa : Colors.blue.shade700,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              log.astrologerName,
                              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: kTextColor),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isCall ? Colors.orange.shade50 : Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isCall ? "ऑडियो/वीडियो कॉल" : "चैट परामर्श",
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: isCall ? Colors.orange.shade800 : Colors.blue.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(log.astrologerSkill, style: const TextStyle(fontSize: 11, color: kSubTextColor)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9F4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFCC80)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 13, color: kPrimaryBhagwa),
                        const SizedBox(width: 5),
                        Text("बातचीत का समय: ${log.durationText}",
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: kTextColor)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined, size: 13, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(log.fullFormattedDate,
                            style: const TextStyle(fontSize: 10.5, color: kSubTextColor, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("शुल्क: ${log.cost}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                  if (!isCall)
                    OutlinedButton.icon(
                      onPressed: () => _openChatHistoryViewer(log),
                      icon: const Icon(Icons.forum_rounded, size: 13, color: kPrimaryBhagwa),
                      label: const Text("चैट इतिहास देखें",
                          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: kPrimaryBhagwa),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        minimumSize: const Size(80, 26),
                      ),
                    )
                  else
                    const Text("सत्र पूर्ण ✅",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}