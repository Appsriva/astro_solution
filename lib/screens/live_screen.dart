import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'active_live_stream_screen.dart';
import 'astrologer_detail_screen.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);

const List<BoxShadow> kCardShadow = [
  BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  ),
];

class LiveSessionItem {
  final String id;
  final String name;
  final String title;
  final String skills;
  final String rating;
  final String experience;
  final String ratePerMin;
  final String viewers;
  final String imageUrl;
  final String topic;
  final bool isLiveNow;
  final String upcomingTime;

  const LiveSessionItem({
    required this.id,
    required this.name,
    required this.title,
    required this.skills,
    required this.rating,
    required this.experience,
    required this.ratePerMin,
    required this.viewers,
    required this.imageUrl,
    required this.topic,
    this.isLiveNow = true,
    this.upcomingTime = "",
  });
}

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  int _selectedTabIndex = 0; // 0 = Live Now, 1 = Upcoming
  
  // Supabase Realtime Integration Variables
  final supabase = Supabase.instance.client;
  bool _isLoading = false;

  static const List<LiveSessionItem> _liveSessions = [
    LiveSessionItem(
      id: "live_1",
      name: "पूनम शर्मा",
      title: "पूनम जी",
      skills: "टैरो रीडर एवं लव एक्सपर्ट",
      rating: "4.9",
      experience: "12+ वर्ष",
      ratePerMin: "18",
      viewers: "1.4k",
      imageUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80",
      topic: "लव लाइफ एवं शादी पर सीधा सवाल पूछें 💖",
      isLiveNow: true,
    ),
    LiveSessionItem(
      id: "live_2",
      name: "पं. मयंक शास्त्री",
      title: "पं. मयंक शास्त्री",
      skills: "वैदिक ज्योतिष एवं कुंडली विशेषज्ञ",
      rating: "5.0",
      experience: "16+ वर्ष",
      ratePerMin: "22",
      viewers: "2.1k",
      imageUrl: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&auto=format&fit=crop&q=80",
      topic: "सरकारी नौकरी और व्यापार में सफलता के योग 💼",
      isLiveNow: true,
    ),
    LiveSessionItem(
      id: "live_3",
      name: "एस्ट्रो ऊर्जा",
      title: "एस्ट्रो ऊर्जा",
      skills: "अंकशास्त्र एवं वास्तु",
      rating: "4.8",
      experience: "9+ वर्ष",
      ratePerMin: "15",
      viewers: "890",
      imageUrl: "https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?w=200&auto=format&fit=crop&q=80",
      topic: "घर में सुख-शांति एवं आर्थिक तंगी दूर करने के उपाय 🪔",
      isLiveNow: true,
    ),
    LiveSessionItem(
      id: "live_4",
      name: "पलक वेद",
      title: "पलक वेद",
      skills: "नाड़ी ज्योतिष एवं हस्तरेखा",
      rating: "4.9",
      experience: "14+ वर्ष",
      ratePerMin: "20",
      viewers: "1.8k",
      imageUrl: "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200&auto=format&fit=crop&q=80",
      topic: "हस्तरेखा देखकर जानें अपना सही करियर व भाग्य ✋",
      isLiveNow: true,
    ),
  ];

  static const List<LiveSessionItem> _upcomingSessions = [
    LiveSessionItem(
      id: "up_1",
      name: "आचार्य विद्याधर",
      title: "आचार्य विद्याधर",
      skills: "वैदिक कर्मकांड एवं महामृत्युंजय",
      rating: "5.0",
      experience: "22+ वर्ष",
      ratePerMin: "25",
      viewers: "0",
      imageUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80",
      topic: "संध्या आरती एवं विशेष महामृत्युंजय अनुष्ठान 🔱",
      isLiveNow: false,
      upcomingTime: "आज शाम 07:00 PM",
    ),
    LiveSessionItem(
      id: "up_2",
      name: "टैरो नेहा",
      title: "टैरो नेहा",
      skills: "टैरो कार्ड व एंजल गाइडेंस",
      rating: "4.8",
      experience: "8+ वर्ष",
      ratePerMin: "16",
      viewers: "0",
      imageUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80",
      topic: "कल का दिन कैसा रहेगा? जानिए अपना सटीक भविष्य 🔮",
      isLiveNow: false,
      upcomingTime: "आज रात 08:30 PM",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkDatabaseConnection();
  }

  Future<void> _checkDatabaseConnection() async {
    setState(() => _isLoading = true);
    try {
      // Optional: Fetch live sessions from Supabase if table exists, else fallback gracefully
      await supabase.from('profiles').select('id').limit(1);
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  // 🌟 Open Astrologer Bio Data Screen (Photo/Name Click)
  void _openAstrologerBio(LiveSessionItem session) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AstrologerDetailScreen(
          name: session.name,
          imageUrl: session.imageUrl,
          experience: session.experience,
          skills: session.skills,
          rating: session.rating,
          ratePerMin: session.ratePerMin,
        ),
      ),
    );
  }

  // 🔴 Open Live Stream Screen
  void _joinLiveStream(LiveSessionItem session) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ActiveLiveStreamScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryBhagwa))
          : SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Segment Switcher: लाइव सेशन / आगामी
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTabIndex = 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              gradient: _selectedTabIndex == 0
                                  ? const LinearGradient(colors: [kPrimaryBhagwa, kDeepSaffron])
                                  : null,
                              color: _selectedTabIndex == 0 ? null : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedTabIndex == 0 ? kPrimaryBhagwa : Colors.orange.shade200,
                              ),
                              boxShadow: _selectedTabIndex == 0 ? kCardShadow : [],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.sensors_rounded,
                                  size: 16,
                                  color: _selectedTabIndex == 0 ? Colors.white : kPrimaryBhagwa,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "लाइव सेशन (Live Now)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedTabIndex == 0 ? Colors.white : kTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTabIndex = 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              gradient: _selectedTabIndex == 1
                                  ? const LinearGradient(colors: [kPrimaryBhagwa, kDeepSaffron])
                                  : null,
                              color: _selectedTabIndex == 1 ? null : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedTabIndex == 1 ? kPrimaryBhagwa : Colors.orange.shade200,
                              ),
                              boxShadow: _selectedTabIndex == 1 ? kCardShadow : [],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.alarm_rounded,
                                  size: 16,
                                  color: _selectedTabIndex == 1 ? Colors.white : kPrimaryBhagwa,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "आगामी (Upcoming)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedTabIndex == 1 ? Colors.white : kTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Session List
                  if (_selectedTabIndex == 0)
                    ..._liveSessions.map((session) => _buildLiveCard(session)).toList()
                  else
                    ..._upcomingSessions.map((session) => _buildUpcomingCard(session)).toList(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildLiveCard(LiveSessionItem session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.orange.shade100),
        boxShadow: kCardShadow,
      ),
      child: Column(
        children: [
          // Top Astrologer Profile Section (Clickable to Bio Data)
          GestureDetector(
            onTap: () => _openAstrologerBio(session),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF7A00), Color(0xFFFF4D00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Row(
                children: [
                  // Photo
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        session.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.white,
                          child: const Icon(Icons.person_rounded, color: kPrimaryBhagwa, size: 36),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Astrologer Name & Details (Clickable)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          session.skills,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: kGoldAccent, size: 14),
                            const SizedBox(width: 3),
                            Text(
                              session.rating,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Live Viewers Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(160),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white38),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "LIVE (${session.viewers})",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Topic and Join Stream Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    session.topic,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _joinLiveStream(session),
                  icon: const Icon(Icons.play_arrow_rounded, size: 16),
                  label: const Text("जुड़ें (Join)", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryBhagwa,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    elevation: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard(LiveSessionItem session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade100),
        boxShadow: kCardShadow,
      ),
      child: Row(
        children: [
          // Photo (Clickable to Bio)
          GestureDetector(
            onTap: () => _openAstrologerBio(session),
            child: CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(session.imageUrl),
              backgroundColor: const Color(0xFFFFF0E6),
            ),
          ),

          const SizedBox(width: 12),

          // Name and Details (Clickable to Bio)
          Expanded(
            child: GestureDetector(
              onTap: () => _openAstrologerBio(session),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0E6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      session.upcomingTime,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryBhagwa,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    session.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor),
                  ),
                  Text(
                    session.topic,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: kSubTextColor),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${session.name} के लाइव सेशन का रिमाइंडर सेट हो गया है! 🔔"),
                  backgroundColor: kPrimaryBhagwa,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFF0E6),
              foregroundColor: kPrimaryBhagwa,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              elevation: 0,
            ),
            child: const Text("रिमाइंडर", style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}