import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'astro_orders_screen.dart';
import 'astro_shop_screen.dart';
import 'astrologer_detail_screen.dart';
import 'call_screen.dart';
import 'chat_screen.dart';
import 'consultation_history_screen.dart';
import 'customer_support_screen.dart';
import 'join_as_astrologer_screen.dart';
import 'kundli_screen.dart';
import 'live_darshan_screen.dart';
import 'live_screen.dart';
import 'login_screen.dart';
import 'matching_screen.dart';
import 'panchang_screen.dart';
import 'pandit_bookings_history_screen.dart';
import 'pandit_detail_screen.dart';
import 'puja_booking_screen.dart';
import 'puja_bookings_history_screen.dart';
import 'rashifal_screen.dart';
import 'refer_and_earn_screen.dart';
import 'remedies_screen.dart';
import 'wallet_history_screen.dart';
import 'wallet_screen.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);
const Color kNavBgColor = Colors.white;

const List<BoxShadow> kCardShadow = [
  BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  ),
];

class BannerItem {
  final String badge;
  final String title;
  final String subtitle;
  final String btnText;
  final String imageUrl;
  final List<Color> gradient;

  const BannerItem({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.btnText,
    required this.imageUrl,
    required this.gradient,
  });
}

class LiveAstrologer {
  final String name;
  final String nameHi;
  final String rating;
  final String type;
  final String viewers;
  final String imageUrl;

  const LiveAstrologer({
    required this.name,
    required this.nameHi,
    required this.rating,
    required this.type,
    required this.viewers,
    required this.imageUrl,
  });
}

class RecentSessionAstrologer {
  final String name;
  final String skills;
  final String rating;
  final String rate;
  final String imageUrl;
  final String lastConnected;

  const RecentSessionAstrologer({
    required this.name,
    required this.skills,
    required this.rating,
    required this.rate,
    required this.imageUrl,
    required this.lastConnected,
  });
}

class AstrologyBlog {
  final String title;
  final String titleHi;
  final String category;
  final String categoryHi;
  final String readTime;
  final String date;
  final String imageUrl;
  final String content;
  final String contentHi;

  const AstrologyBlog({
    required this.title,
    required this.titleHi,
    required this.category,
    required this.categoryHi,
    required this.readTime,
    required this.date,
    required this.imageUrl,
    required this.content,
    required this.contentHi,
  });
}

class PanditBookingItem {
  final String id;
  final String name;
  final String city;
  final String rituals;
  final String exp;
  final String dakshina;
  final double rating;
  final String reviews;
  final String tradition;
  final String imageUrl;

  const PanditBookingItem({
    required this.id,
    required this.name,
    required this.city,
    required this.rituals,
    required this.exp,
    required this.dakshina,
    required this.rating,
    required this.reviews,
    required this.tradition,
    required this.imageUrl,
  });
}

class HomeScreen extends StatefulWidget {
  final String? userName;

  const HomeScreen({super.key, this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isEnglish = false;
  String _selectedCity = "दिल्ली NCR";

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  String _selectedFeedbackType = "सुझाव / फीडबैक";

  String _displayName = "यजमान";
  double _walletBalance = 0.0;
  StreamSubscription? _profileSubscription;

  final List<String> _feedbackTypes = [
    "सुझाव / फीडबैक",
    "तकनीकी समस्या (App Bug)",
    "वॉलेट / पेमेंट संबंधित",
    "पंडित / ज्योतिषी सेवा शिकायत",
  ];

  static const List<String> _cities = [
    "दिल्ली NCR",
    "जयपुर",
    "लखनऊ",
    "वाराणसी",
    "मुंबई",
    "पटना",
    "सभी शहर",
  ];

  final List<String> _karmkandTypes = [
    "गृह प्रवेश एवं वास्तु शांति (Griha Pravesh)",
    "सत्यनारायण भगवान की कथा व पूजा",
    "रुद्राभिषेक एवं महामृत्युंजय अनुष्ठान",
    "विवाह संस्कार एवं लगन महूर्त",
    "मुंडन संस्कार एवं जनेऊ अनुष्ठान",
    "पितृ दोष / नारायण बालि श्राद्ध",
    "नवीन व्यापार/दुकान उद्घाटन पूजन",
  ];

  static const List<PanditBookingItem> _panditsList = [
    PanditBookingItem(
      id: "pnd_1",
      name: "पं. राधेश्याम शास्त्री",
      city: "दिल्ली NCR",
      rituals: "विवाह संस्कार, गृह प्रवेश, महामृत्युंजय",
      exp: "18+ वर्ष अनुभव",
      dakshina: "₹2,100",
      rating: 4.9,
      reviews: "1.4k",
      tradition: "वैदिक कर्मकांड एवं सनातन विधि",
      imageUrl: "https://images.unsplash.com/photo-1544717305-2782549b5136?w=200&auto=format&fit=crop&q=80",
    ),
    PanditBookingItem(
      id: "pnd_2",
      name: "आचार्य विद्याधर त्रिपाठी",
      city: "वाराणसी",
      rituals: "रुद्राभिषेक, सत्यनारायण कथा, कालसर्प शांति",
      exp: "22+ वर्ष अनुभव",
      dakshina: "₹1,500",
      rating: 5.0,
      reviews: "2.1k",
      tradition: "काशी विद्वत परिषद प्रमाणित",
      imageUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80",
    ),
    PanditBookingItem(
      id: "pnd_3",
      name: "पं. बृजमोहन शर्मा",
      city: "जयपुर",
      rituals: "विवाह मुहूर्त, वास्तु शांति, मुंडन",
      exp: "15+ वर्ष अनुभव",
      dakshina: "₹2,500",
      rating: 4.8,
      reviews: "980",
      tradition: "राजस्थान वैदिक परंपरा",
      imageUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80",
    ),
    PanditBookingItem(
      id: "pnd_4",
      name: "पं. देवेन्द्र नाथ शुक्ल",
      city: "लखनऊ",
      rituals: "गृह प्रवेश, सुंदरकांड, नवग्रह शांति",
      exp: "16+ वर्ष अनुभव",
      dakshina: "₹1,800",
      rating: 4.9,
      reviews: "1.1k",
      tradition: "अवध एवं वैदिक पद्धति",
      imageUrl: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&auto=format&fit=crop&q=80",
    ),
  ];

  static const List<LiveAstrologer> _liveAstrologers = [
    LiveAstrologer(
      name: "Poonam Sharma",
      nameHi: "पूनम शर्मा",
      rating: "8.9",
      type: "call",
      viewers: "1.2k",
      imageUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80",
    ),
    LiveAstrologer(
      name: "Astro Urja",
      nameHi: "एस्ट्रो ऊर्जा",
      rating: "6.7",
      type: "video",
      viewers: "850",
      imageUrl: "https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?w=200&auto=format&fit=crop&q=80",
    ),
    LiveAstrologer(
      name: "Palakh Ved",
      nameHi: "पलक वेद",
      rating: "9.5",
      type: "video",
      viewers: "2.4k",
      imageUrl: "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200&auto=format&fit=crop&q=80",
    ),
    LiveAstrologer(
      name: "Pt. Mayank",
      nameHi: "पं. मयंक",
      rating: "9.1",
      type: "video",
      viewers: "1.8k",
      imageUrl: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&auto=format&fit=crop&q=80",
    ),
    LiveAstrologer(
      name: "Tarot Neha",
      nameHi: "टैरो नेहा",
      rating: "8.4",
      type: "call",
      viewers: "940",
      imageUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80",
    ),
  ];

  static const List<RecentSessionAstrologer> _recentSessions = [
    RecentSessionAstrologer(
      name: "Dr. Aarti Shastri",
      skills: "Vedic, Tarot, Numerology",
      rating: "4.9",
      rate: "10+ वर्ष अनुभव",
      imageUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80",
      lastConnected: "Yesterday",
    ),
    RecentSessionAstrologer(
      name: "Astro Manish",
      skills: "Nadi, KP Astrology",
      rating: "4.8",
      rate: "8+ वर्ष अनुभव",
      imageUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80",
      lastConnected: "3 days ago",
    ),
    RecentSessionAstrologer(
      name: "Tarot Pooja",
      skills: "Tarot Card Reader, Life Coach",
      rating: "5.0",
      rate: "12+ वर्ष अनुभव",
      imageUrl: "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200&auto=format&fit=crop&q=80",
      lastConnected: "1 week ago",
    ),
  ];

  static const List<AstrologyBlog> _blogsList = [
    AstrologyBlog(
      title: "Signs of Kaal Sarp Dosh & Simple Vedic Remedies",
      titleHi: "कालसर्प दोष के लक्षण और 5 सरल वैदिक अचूक उपाय",
      category: "Kundli Dosh",
      categoryHi: "कुंडली दोष",
      readTime: "3 min",
      date: "Today",
      imageUrl: "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=500&auto=format&fit=crop&q=80",
      content: "कालसर्प योग बनने पर महामृत्युंजय मंत्र का जाप और नाग-नागिन का जोड़ा अर्पित करें।",
      contentHi: "जब जन्मकुंडली में राहु और केतु के बीच सभी ग्रह आ जाएं तब कालसर्प दोष बनता है। नित्य महामृत्युंजय मंत्र का जाप करें और सोमवार को शिवलिंग पर जल अर्पित करें।",
    ),
    AstrologyBlog(
      title: "Shani Sade Sati: Don't Fear, Know Its True Blessings",
      titleHi: "शनि की साढ़ेसाती: डरें नहीं, जानें प्रभाव और समाधान",
      category: "Planetary Transit",
      categoryHi: "ग्रह गोचर",
      readTime: "4 min",
      date: "Yesterday",
      imageUrl: "https://images.unsplash.com/photo-1532274402911-5a369e4c4bb5?w=500&auto=format&fit=crop&q=80",
      content: "शनिवार को पीपल के नीचे सरसों के तेल का दीपक लगाएं और हनुमान चालीसा पढ़ें।",
      contentHi: "शनिदेव न्याय के देवता हैं। शनिवार की शाम पीपल के नीचे सरसों के तेल का दीपक जलाएं और नित्य हनुमान चालीसा का पाठ करें।",
    ),
    AstrologyBlog(
      title: "5 Powerful Vastu & Astrology Tips for Prosperity",
      titleHi: "घर में धन और सुख-शांति के लिए 5 अचूक वास्तु नियम",
      category: "Vastu Tips",
      categoryHi: "वास्तु उपाय",
      readTime: "2 min",
      date: "2 days ago",
      imageUrl: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=500&auto=format&fit=crop&q=80",
      content: "घर के ईशान कोण को साफ रखें और शाम को कपूर जलाएं।",
      contentHi: "घर के ईशान कोण (North-East) को हमेशा साफ और हल्का रखें। शाम के समय घर में कपूर और लौंग की धूप दिखाएं।",
    ),
  ];

  static const List<BannerItem> _bannersEnglish = [
    BannerItem(
      badge: "DIVINE GUIDANCE 🚩",
      title: "Talk to Expert Astrologers",
      subtitle: "Get accurate predictions on career, love, and life path.",
      btnText: "Explore Now",
      imageUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&auto=format&fit=crop&q=80",
      gradient: [Color(0xFFFF6F00), Color(0xFFFF3D00)],
    ),
    BannerItem(
      badge: "SACRED RITUALS 🪔",
      title: "Book Verified Pandits",
      subtitle: "Perform authentic Vedic pujas at your home or temples.",
      btnText: "Book Puja",
      imageUrl: "https://images.unsplash.com/photo-1544717305-2782549b5136?w=300&auto=format&fit=crop&q=80",
      gradient: [Color(0xFFE65100), Color(0xFFC2185B)],
    ),
  ];

  static const List<BannerItem> _bannersHindi = [
    BannerItem(
      badge: "दिव्य मार्गदर्शन 🚩",
      title: "शीर्ष वैदिक ज्योतिषियों से जुड़ें",
      subtitle: "करियर, विवाह और जीवन से जुड़े सभी प्रश्नों के सटीक समाधान।",
      btnText: "अभी संपर्क करें",
      imageUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&auto=format&fit=crop&q=80",
      gradient: [Color(0xFFFF6F00), Color(0xFFFF3D00)],
    ),
    BannerItem(
      badge: "सनातन अनुष्ठान 🪔",
      title: "सत्यापित पंडित जी बुक करें",
      subtitle: "अपने घर या प्रमुख तीर्थस्थलों पर करवाएं संपूर्ण वैदिक पूजा।",
      btnText: "पंडित बुक करें",
      imageUrl: "https://images.unsplash.com/photo-1544717305-2782549b5136?w=300&auto=format&fit=crop&q=80",
      gradient: [Color(0xFFE65100), Color(0xFFC2185B)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _displayName = widget.userName ?? "यजमान";
    _fetchUserDataRealtime();
  }

  void _fetchUserDataRealtime() {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      _profileSubscription = supabase
          .from('profiles')
          .stream(primaryKey: ['id'])
          .eq('id', user.id)
          .listen((List<Map<String, dynamic>> data) {
        if (data.isNotEmpty && mounted) {
          setState(() {
            _displayName = data.first['name'] ?? widget.userName ?? "यजमान";
            _walletBalance = (data.first['wallet_balance'] ?? 0.0).toDouble();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _feedbackController.dispose();
    _profileSubscription?.cancel();
    super.dispose();
  }

  void _openKundliScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const KundliScreen()));
  }

  void _openMatchingScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const MatchingScreen()));
  }

  void _openRashifalScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const RashifalScreen()));
  }

  void _openPanchangScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PanchangScreen()));
  }

  void _openLiveDarshanScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LiveDarshanScreen()));
  }

  void _openPujaBookingScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PujaBookingScreen()));
  }

  void _openWalletScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletScreen()));
  }

  void _openConsultationHistory() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ConsultationHistoryScreen()));
  }

  void _openBlogReader(AstrologyBlog blog) {
    final String detailedContentEn = """
${blog.title}

Introduction:
Vedic astrology is an ancient and profound science that guides us through the cosmic influences shaping our lives. Understanding planetary positions helps us navigate challenges and harness positive energies effectively.

Detailed Astrological Analysis:
According to sacred texts, cosmic transits and natal chart placements dictate various phases of growth, obstacles, and spiritual evolution. When afflicted, specific doshas or planetary retrogrades can cause delays in career, marriage, or financial stability. However, the scriptures do not just outline problems; they offer time-tested, divine remedies.

Core Vedic Remedies & Solutions:
1. Mantra Chanting & Japa: Regular recitation of specific planetary mantras purifies the aura and strengthens weak benefic planets in your horoscope.
2. Charity & Daan: Donating items associated with ruling planets (like yellow items for Jupiter or black sesame for Saturn) on auspicious days mitigates malefic impacts.
3. Gemstones & Rudraksha: Wearing prescribed gemstones or consecrated Rudraksha beads after proper astrological consultation creates a protective shield of positive frequencies.
4. Lifestyle & Vastu Adjustments: Aligning your living space with Vastu principles and maintaining a disciplined spiritual routine attracts abundance and peace.

Conclusion:
Astrology is a map of potential, not a final sentence. With faith, correct remedial measures, and expert guidance, anyone can overcome planetary afflictions and lead a prosperous, harmonious life.
""";

    final String detailedContentHi = """
${blog.titleHi}

परिचय (Introduction):
वैदिक ज्योतिष एक अत्यंत प्राचीन और दिव्य विज्ञान है, जो ब्रह्मांडीय ऊर्जाओं और ग्रहों की चाल के माध्यम से हमारे जीवन को सही दिशा दिखाता है। जन्मकुंडली में ग्रहों की स्थिति यह तय करती है कि हमारे जीवन में कब सफलता आएगी और कब बाधाएं आएंगी।

ज्योतिषीय विश्लेषण एवं प्रभाव (Astrological Analysis):
शास्त्रों के अनुसार, जब जन्मकुंडली में कोई ग्रह नीच का होता है या राहु-केतु-शनि का प्रभाव बढ़ता है, तब जीवन में अचानक संघर्ष, मानसिक तनाव, व्यापार में रुकावट या विवाह में देरी जैसी समस्याएं आने लगती हैं। लेकिन सनातन धर्म में हर समस्या का समाधान भी निहित है।

5 अचूक वैदिक उपाय एवं समाधान (Core Vedic Remedies):
1. मंत्र जाप एवं अनुष्ठान: अपने इष्ट देव या संबंधित ग्रह के बीज मंत्र का नित्य एक माला जाप करने से नकारात्मक ऊर्जा समाप्त होती है और सकारात्मकता का संचार होता है।
2. दान एवं पुण्य कार्य: ज्योतिषीय गणना के अनुसार जरूरतमंदों को अन्न, वस्त्र या ग्रहों से जुड़ी वस्तुओं (जैसे शनिवार को काला तिल या सरसों का तेल) का दान करने से महादोष शांत होते हैं।
3. रत्न एवं रुद्राक्ष धारण: योग्य ज्योतिषी की सलाह से प्राण-प्रतिष्ठित रत्न या पंचमुखी/सातमुखी रुद्राक्ष धारण करने से कवच जैसा सुरक्षा चक्र बनता है।
4. वास्तु एवं दिनचर्या में सुधार: अपने घर के ईशान कोण को हमेशा पवित्र रखें, रोज सुबह सूर्य देव को जल अर्पित करें और सात्विक जीवनशैली अपनाएं।

निष्कर्ष (Conclusion):
ज्योतिष कोई भाग्य का अंतिम फैसला नहीं है, बल्कि यह भविष्य की संभावनाओं का एक नक्शा है। यदि हम सही समय पर उचित वैदिक उपाय और कर्म सुधार करें, तो बड़े से बड़ा संकट भी टल सकता है। नियमित साधना और विश्वास से जीवन में सुख-शांति और ऐश्वर्य की प्राप्ति होती है।
""";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: const BoxDecoration(
            color: kCardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFFF0E6), borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        _isEnglish ? blog.category : blog.categoryHi,
                        style: const TextStyle(color: kPrimaryBhagwa, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, color: kTextColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          blog.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200,
                            color: const Color(0xFFFFF0E6),
                            child: const Icon(Icons.menu_book_rounded, color: kPrimaryBhagwa, size: 50),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isEnglish ? blog.title : blog.titleHi,
                        style: const TextStyle(color: kTextColor, fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "पढ़ने का समय: ${blog.readTime} • अपडेटेड: 2026",
                        style: const TextStyle(color: kSubTextColor, fontSize: 11),
                      ),
                      const Divider(height: 24),
                      Text(
                        _isEnglish ? detailedContentEn : detailedContentHi,
                        style: const TextStyle(color: kTextColor, fontSize: 13.5, height: 1.6),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7F0),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFFFCC80)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("क्या यह लेख आपके लिए उपयोगी था?", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("समीक्षा के लिए धन्यवाद! 🙏")));
                                  },
                                  icon: const Icon(Icons.thumb_up_alt_rounded, color: kPrimaryBhagwa, size: 20),
                                ),
                                IconButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("लेख लिंक शेयर किया गया!")));
                                  },
                                  icon: const Icon(Icons.share_rounded, color: kPrimaryBhagwa, size: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitFeedback() {
    final text = _feedbackController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("कृपया अपना संदेश या सुझाव दर्ज करें!"), backgroundColor: Colors.orange),
      );
      return;
    }
    _feedbackController.clear();
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 50),
            const SizedBox(height: 10),
            const Text("संदेश प्रेषित हुआ! 🙏", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor)),
            const SizedBox(height: 6),
            const Text("आपका संदेश सीधे ओनर ऑफिस प्रबंधन टीम को प्राप्त हो गया है। हम शीघ्र ही इस पर कार्रवाई करेंगे।", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: kSubTextColor)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBhagwa, foregroundColor: Colors.white),
              child: const Text("ठीक है"),
            ),
          ],
        ),
      ),
    );
  }

  void _openPanditBookingModal(PanditBookingItem pandit) {
    String selectedKarmkand = _karmkandTypes.first;

    final List<Map<String, dynamic>> pujaPackages = [
      {
        "title": "लघु वैदिक विधि (Basic Anushthan)",
        "dakshina": "₹1,100",
        "pandits": "1 पंडित जी",
        "duration": "लगभग 1.5 से 2 घंटे",
        "desc": "संक्षिप्त विधि से मंत्र जाप, हवन एवं शांति पाठ।",
      },
      {
        "title": "मध्यम वैदिक विधान (Most Popular)",
        "dakshina": "₹2,100",
        "pandits": "1 मुख्य आचार्य",
        "duration": "लगभग 2.5 से 3 घंटे",
        "desc": "पूर्ण विधि-विधान, संकल्प, नवग्रह पूजन, कथा एवं विशेष आहुति।",
      },
      {
        "title": "विस्तृत अनुष्ठान (Special Grand Puja)",
        "dakshina": "₹5,100",
        "pandits": "2 विद्वान पंडित",
        "duration": "लगभग 4 घंटे",
        "desc": "दो पंडितों द्वारा सस्वर वेद पाठ, संपूर्ण अभिषेक, विस्तृत हवन एवं पूर्ण आहुति।",
      },
      {
        "title": "महा अनुष्ठान / VIP अनुष्ठान",
        "dakshina": "₹11,000",
        "pandits": "3 से 4 वैदिक ब्राह्मण",
        "duration": "लगभग 5 से 6 घंटे",
        "desc": "चार विद्वान ब्राह्मणों द्वारा संपूर्ण अनुष्ठान, सहस्र आहुति, मार्जन एवं भव्य हवन।",
      },
    ];

    int selectedPackageIndex = 1;
    final TextEditingController nameController = TextEditingController(text: _displayName);
    final TextEditingController phoneController = TextEditingController(text: "9876543210");

    final TextEditingController houseController = TextEditingController();
    final TextEditingController streetController = TextEditingController();
    final TextEditingController landmarkController = TextEditingController();
    final TextEditingController cityController = TextEditingController(text: "जयपुर");
    final TextEditingController pincodeController = TextEditingController();

    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    final Set<String> bookedDates = {
      DateTime.now().add(const Duration(days: 2)).toIso8601String().substring(0, 10),
      DateTime.now().add(const Duration(days: 5)).toIso8601String().substring(0, 10),
      DateTime.now().add(const Duration(days: 9)).toIso8601String().substring(0, 10),
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final activePkg = pujaPackages[selectedPackageIndex];
            final isoDateStr = selectedDate.toIso8601String().substring(0, 10);
            final bool isAlreadyBooked = bookedDates.contains(isoDateStr);

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.94,
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
                        CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(pandit.imageUrl),
                          backgroundColor: const Color(0xFFFFF0E6),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pandit.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
                              Text("${pandit.tradition} • अनुभव: ${pandit.exp}", style: const TextStyle(fontSize: 11, color: kPrimaryBhagwa, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(modalContext),
                          icon: const Icon(Icons.close_rounded, color: kTextColor),
                        ),
                      ],
                    ),
                    const Divider(height: 16),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "सनातन कर्मकांड एवं पूजा का उद्देश्य चुनें:",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor),
                            ),
                            const SizedBox(height: 6),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF9F4),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFFFCC80)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedKarmkand,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: kPrimaryBhagwa),
                                  items: _karmkandTypes.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kTextColor)),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setModalState(() {
                                      selectedKarmkand = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("पूजा की तिथि चुनें (Select Date):", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                                TextButton.icon(
                                  onPressed: () async {
                                    final DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 60)),
                                      builder: (context, child) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme: const ColorScheme.light(primary: kPrimaryBhagwa, onPrimary: Colors.white),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (picked != null) {
                                      setModalState(() {
                                        selectedDate = picked;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_month_rounded, size: 16, color: kPrimaryBhagwa),
                                  label: const Text("कैलेंडर खोलें", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
                                ),
                              ],
                            ),

                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isAlreadyBooked ? Colors.red.shade50 : Colors.green.shade50,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: isAlreadyBooked ? Colors.red.shade300 : Colors.green.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isAlreadyBooked ? Icons.cancel_rounded : Icons.check_circle_rounded,
                                    color: isAlreadyBooked ? Colors.red : Colors.green,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "चयनित तिथि: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          isAlreadyBooked
                                              ? "⚠️ इस तिथि पर पंडित जी पहले से अन्य यजमान के यहाँ बुक (Reserved) हैं। कृपया दूसरी तारीख चुनें।"
                                              : "✨ इस तिथि पर पंडित जी बिल्कुल फ्री (Available) हैं!",
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: isAlreadyBooked ? Colors.red.shade800 : Colors.green.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),
                            const Text(
                              "पूजा पैकेज एवं दक्षिणा विकल्प चुनें:",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor),
                            ),
                            const SizedBox(height: 8),

                            ...List.generate(pujaPackages.length, (index) {
                              final pkg = pujaPackages[index];
                              final isSelected = selectedPackageIndex == index;

                              return GestureDetector(
                                onTap: () => setModalState(() => selectedPackageIndex = index),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFFFFF7F0) : Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isSelected ? kPrimaryBhagwa : Colors.orange.shade100,
                                      width: isSelected ? 1.8 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Radio<int>(
                                        value: index,
                                        groupValue: selectedPackageIndex,
                                        activeColor: kPrimaryBhagwa,
                                        onChanged: (val) => setModalState(() => selectedPackageIndex = val!),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(pkg["title"], style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: kTextColor)),
                                                Text(pkg["dakshina"], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green)),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text("विद्वान: ${pkg["pandits"]} • समय: ${pkg["duration"]}", style: const TextStyle(fontSize: 10, color: kPrimaryBhagwa, fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),

                            const SizedBox(height: 10),
                            const Text(
                              "यजमान एवं पूरा डिलीवरी पता (Delivery Address):",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor),
                            ),
                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: nameController,
                                    style: const TextStyle(fontSize: 12, color: kTextColor),
                                    decoration: InputDecoration(
                                      labelText: "यजमान का नाम",
                                      labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                                      prefixIcon: const Icon(Icons.person_outline_rounded, color: kPrimaryBhagwa, size: 18),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFDF9),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                      contentPadding: const EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    style: const TextStyle(fontSize: 12, color: kTextColor),
                                    decoration: InputDecoration(
                                      labelText: "मोबाइल नंबर",
                                      labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                                      prefixIcon: const Icon(Icons.phone_outlined, color: kPrimaryBhagwa, size: 18),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFDF9),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                      contentPadding: const EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: houseController,
                                    style: const TextStyle(fontSize: 12, color: kTextColor),
                                    decoration: InputDecoration(
                                      labelText: "मकान / फ्लैट नंबर",
                                      labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFDF9),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                      contentPadding: const EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: streetController,
                                    style: const TextStyle(fontSize: 12, color: kTextColor),
                                    decoration: InputDecoration(
                                      labelText: "गली / एरिया",
                                      labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFDF9),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                      contentPadding: const EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: landmarkController,
                                    style: const TextStyle(fontSize: 12, color: kTextColor),
                                    decoration: InputDecoration(
                                      labelText: "लैंडमार्क (Landmark)",
                                      labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFDF9),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                      contentPadding: const EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: pincodeController,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(fontSize: 12, color: kTextColor),
                                    decoration: InputDecoration(
                                      labelText: "पिन कोड (Pin Code)",
                                      labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                                      filled: true,
                                      fillColor: const Color(0xFFFFFDF9),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                      contentPadding: const EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: isAlreadyBooked
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("इस तारीख पर पंडित जी व्यस्त हैं, कृपया दूसरी तारीख चुनें!"), backgroundColor: Colors.red),
                                );
                              }
                            : () async {
                                final fullAddress = "${houseController.text}, ${streetController.text}, Landmark: ${landmarkController.text}, ${cityController.text} - ${pincodeController.text}";
                                final yajmanFinalName = nameController.text.trim().isEmpty ? _displayName : nameController.text.trim();
                                final phoneFinal = phoneController.text.trim().isEmpty ? "9876543210" : phoneController.text.trim();
                                final dateFormatted = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";

                                try {
                                  final user = Supabase.instance.client.auth.currentUser;
                                  if (user != null) {
                                    await Supabase.instance.client.from('pandit_bookings').insert({
                                      'user_id': user.id,
                                      'pandit_name': pandit.name,
                                      'karmkand': selectedKarmkand,
                                      'package_title': activePkg["title"],
                                      'pandits_count': activePkg["pandits"],
                                      'dakshina': activePkg["dakshina"],
                                      'booking_date': dateFormatted,
                                      'address': houseController.text.trim().isEmpty ? "जयपुर, राजस्थान" : fullAddress,
                                      'yajman_name': yajmanFinalName,
                                      'phone': phoneFinal,
                                      'status': 'InProcess',
                                    });
                                  }
                                } catch (_) {}

                                Navigator.pop(modalContext);
                                _showPanditSuccessDialog(
                                  panditName: pandit.name,
                                  karmkand: selectedKarmkand,
                                  dakshina: activePkg["dakshina"],
                                  packageTitle: activePkg["title"],
                                  panditsCount: activePkg["pandits"],
                                  dateStr: dateFormatted,
                                  address: houseController.text.trim().isEmpty ? "जयपुर, राजस्थान" : fullAddress,
                                  yajman: yajmanFinalName,
                                );
                              },
                        icon: Icon(isAlreadyBooked ? Icons.block_rounded : Icons.local_fire_department_rounded, size: 24, color: Colors.white),
                        label: Text(
                          isAlreadyBooked ? "इस तारीख पर बुक नहीं हो सकते" : "पंडित जी बुक करें (${activePkg["dakshina"]}) 🚩",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white, letterSpacing: 0.5),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isAlreadyBooked ? Colors.grey : kPrimaryBhagwa,
                          elevation: 6,
                          shadowColor: Colors.orange.withAlpha(180),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPanditSuccessDialog({
    required String panditName,
    required String karmkand,
    required String dakshina,
    required String packageTitle,
    required String panditsCount,
    required String dateStr,
    required String address,
    required String yajman,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.shade300, width: 2),
                ),
                child: const Icon(Icons.verified_rounded, color: Colors.green, size: 34),
              ),
              const SizedBox(height: 10),
              const Text(
                "पंडित जी सफलतापूर्वक बुक हो गए! 🪔",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
              ),
              const SizedBox(height: 4),
              Text(
                karmkand,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(fontSize: 11, color: kSubTextColor, height: 1.3),
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9F4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFCC80)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "📜 पंडित जी एवं पूजा बुकिंग रसीद",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kPrimaryBhagwa),
                      ),
                    ),
                    const Divider(height: 12),
                    _buildReceiptRow("मुख्य आचार्य:", panditName),
                    _buildReceiptRow("विद्वान दल:", panditsCount),
                    _buildReceiptRow("यजमान:", yajman),
                    _buildReceiptRow("कर्मकांड:", karmkand),
                    _buildReceiptRow("चुना गया पैकेज:", packageTitle),
                    _buildReceiptRow("पूजा की तिथि:", dateStr),
                    _buildReceiptRow("कुल दक्षिणा:", dakshina),
                    _buildReceiptRow("पूजा स्थल पता:", address),
                    _buildReceiptRow("बुकिंग ID:", "PND_${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}"),
                  ],
                ),
              ),

              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryBhagwa,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text("धन्यवाद एवं जय श्री राम", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: kSubTextColor, fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kTextColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideDrawer(String displayName, double walletBalance) {
    return Drawer(
      backgroundColor: kBgColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [kPrimaryBhagwa, kDeepSaffron]),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundImage: NetworkImage("https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&auto=format&fit=crop&q=80"),
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(displayName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
                              child: const Text("Divine VIP Member 🌟", style: TextStyle(color: kGoldAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white.withAlpha(45), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("वॉलेट बैलेंस: ₹${walletBalance.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _openWalletScreen();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            child: const Text("+ रिचार्ज", style: TextStyle(color: kPrimaryBhagwa, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 6),
                children: [
                  _buildSectionHeader("वैदिक ज्योतिष टूल्स"),
                  _buildDrawerTile(Icons.menu_book_rounded, "जन्म कुंडली (Kundli)", kPrimaryBhagwa, () {
                    Navigator.pop(context);
                    _openKundliScreen();
                  }, badge: "FREE"),
                  _buildDrawerTile(Icons.favorite_rounded, "कुंडली मिलान (Gun Milan)", Colors.pink, () {
                    Navigator.pop(context);
                    _openMatchingScreen();
                  }),
                  _buildDrawerTile(Icons.wb_sunny_rounded, "दैनिक राशिफल", Colors.amber.shade800, () {
                    Navigator.pop(context);
                    _openRashifalScreen();
                  }),
                  _buildDrawerTile(Icons.calendar_month_rounded, "आज का पंचांग एवं चौघड़िया", Colors.teal, () {
                    Navigator.pop(context);
                    _openPanchangScreen();
                  }),
                  _buildDrawerTile(Icons.temple_hindu_rounded, "24x7 लाइव मंदिर दर्शन", const Color(0xFFE65100), () {
                    Navigator.pop(context);
                    _openLiveDarshanScreen();
                  }, badge: "LIVE 🔴", badgeColor: Colors.red),
                  _buildDrawerTile(Icons.local_fire_department_rounded, "वैदिक पूजा एवं अनुष्ठान", kDeepSaffron, () {
                    Navigator.pop(context);
                    _openPujaBookingScreen();
                  }, badge: "ऑनलाइन/मंदिर"),
                  const Divider(height: 16),
                  
                  _buildSectionHeader("मेरी गतिविधियां एवं बुकिंग्स"),
                  _buildDrawerTile(Icons.history_rounded, "परामर्श इतिहास (Call/Chat Logs)", Colors.blue, () {
                    Navigator.pop(context);
                    _openConsultationHistory();
                  }),
                  _buildDrawerTile(Icons.account_balance_wallet_rounded, "वॉलेट ट्रांजैक्शन हिस्ट्री", Colors.green, () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletHistoryScreen()));
                  }),
                  _buildDrawerTile(Icons.shopping_bag_outlined, "AstroShop ऑर्डर्स", Colors.purple, () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AstroOrdersScreen()));
                  }),
                  _buildDrawerTile(Icons.person_pin_circle_rounded, "पंडित जी बुकिंग्स (घर पर)", Colors.deepOrange, () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PanditBookingsHistoryScreen()));
                  }),
                  _buildDrawerTile(Icons.temple_hindu_rounded, "मेरी वैदिक पूजा बुकिंग्स", const Color(0xFFE65100), () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PujaBookingsHistoryScreen()));
                  }, badge: "ई-संकल्प", badgeColor: kPrimaryBhagwa),
                  
                  const Divider(height: 16),
                  _buildSectionHeader("पुरस्कार एवं स्पेशल"),
                  _buildDrawerTile(Icons.card_giftcard_rounded, "रेफर करें और ₹100 कमाएं", Colors.redAccent, () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ReferAndEarnScreen()));
                  }, badge: "₹20 FREE", badgeColor: Colors.green),
                  _buildDrawerTile(Icons.workspace_premium_rounded, "ज्योतिषी बनें / Join as Astrologer", kGoldAccent, () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const JoinAsAstrologerScreen()));
                  }, badge: "₹50k+"),
                  const Divider(height: 16),
                  _buildSectionHeader("सहायता एवं सेटिंग्स"),
                  _buildDrawerTile(Icons.headset_mic_rounded, "24x7 ग्राहक सहायता", kPrimaryBhagwa, () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerSupportScreen()));
                  }),
                  _buildDrawerTile(Icons.logout_rounded, "लॉगआउट (Logout)", Colors.red, () {
                    Navigator.pop(context);
                    Supabase.instance.client.auth.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  }),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
    );
  }

  Widget _buildDrawerTile(IconData icon, String title, Color iconColor, VoidCallback onTap, {String? badge, Color badgeColor = kPrimaryBhagwa}) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 21),
      title: Text(title, style: const TextStyle(color: kTextColor, fontSize: 13, fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: badgeColor.withAlpha(35), borderRadius: BorderRadius.circular(6)),
              child: Text(badge, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: badgeColor)),
            ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
        ],
      ),
      dense: true,
      visualDensity: const VisualDensity(vertical: -1.5),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bannerList = _isEnglish ? _bannersEnglish : _bannersHindi;

    return Scaffold(
      backgroundColor: kBgColor,
      drawer: _buildSideDrawer(_displayName, _walletBalance),
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        titleSpacing: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: kPrimaryBhagwa, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("नमस्ते, $_displayName 🚩", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor)),
            const Text("दिव्य ज्योतिष मार्गदर्शन", style: TextStyle(fontSize: 11, color: kSubTextColor)),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                _isEnglish = !_isEnglish;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0E6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.translate_rounded, color: kPrimaryBhagwa, size: 15),
                  const SizedBox(width: 4),
                  Text(
                    _isEnglish ? "ENG" : "हिन्दी",
                    style: const TextStyle(
                      color: kPrimaryBhagwa,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: _openWalletScreen,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10, right: 12, left: 4),
              padding: const EdgeInsets.symmetric(horizontal: 9),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0E6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet_rounded, color: kPrimaryBhagwa, size: 14),
                  const SizedBox(width: 4),
                  Text("₹${_walletBalance.toStringAsFixed(0)}", style: const TextStyle(color: kPrimaryBhagwa, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _buildSelectedTabContent(bannerList),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: kNavBgColor, border: Border(top: BorderSide(color: Colors.orange.shade100))),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: kPrimaryBhagwa,
          unselectedItemColor: kSubTextColor,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "होम"),
            BottomNavigationBarItem(icon: Icon(Icons.phone_in_talk_rounded), label: "कॉल"),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: "चैट"),
            BottomNavigationBarItem(icon: Icon(Icons.sensors_rounded), label: "लाइव"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_rounded), label: "शॉप"),
            BottomNavigationBarItem(icon: Icon(Icons.auto_fix_high_rounded), label: "उपाय"),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedTabContent(List<BannerItem> bannerList) {
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab(bannerList);
      case 1:
        return const CallScreen();
      case 2:
        return const ChatScreen();
      case 3:
        return const LiveScreen();
      case 4:
        return const AstroShopScreen();
      case 5:
        return const RemediesScreen();
      default:
        return _buildHomeTab(bannerList);
    }
  }

  Widget _buildHomeTab(List<BannerItem> bannerList) {
    final filteredPandits = _selectedCity == "सभी शहर" ? _panditsList : _panditsList.where((p) => p.city == _selectedCity).toList();

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HomeBannerSlider(fallbackBanners: bannerList, onBannerTap: () => setState(() => _currentIndex = 2)),
          const SizedBox(height: 14),

          const _ShubhMuhuratTickerBanner(),
          const SizedBox(height: 18),

          const Text("प्रमुख वैदिक सेवाएं 🕉️", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor)),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(child: GestureDetector(onTap: _openKundliScreen, child: _buildServiceCard("जन्म कुंडली", Icons.menu_book_rounded, kPrimaryBhagwa))),
              const SizedBox(width: 10),
              Expanded(child: GestureDetector(onTap: _openRashifalScreen, child: _buildServiceCard("दैनिक राशिफल", Icons.wb_sunny_rounded, const Color(0xFFFFA000)))),
              const SizedBox(width: 10),
              Expanded(child: GestureDetector(onTap: _openMatchingScreen, child: _buildServiceCard("गुण मिलान", Icons.favorite_rounded, const Color(0xFFE91E63)))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: GestureDetector(onTap: _openLiveDarshanScreen, child: _buildServiceCard("लाइव दर्शन", Icons.temple_hindu_rounded, const Color(0xFFE65100)))),
              const SizedBox(width: 10),
              Expanded(child: GestureDetector(onTap: _openPanchangScreen, child: _buildServiceCard("पंचांग", Icons.calendar_month_rounded, const Color(0xFF00ACC1)))),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: _openPujaBookingScreen,
                  child: _buildServiceCard("वैदिक पूजा", Icons.local_fire_department_rounded, kDeepSaffron),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // PANDIT BOOKING SECTION
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: kCardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.orange.shade200), boxShadow: kCardShadow),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: Color(0xFFFFF0E6), shape: BoxShape.circle), child: const Icon(Icons.temple_hindu_rounded, color: kPrimaryBhagwa, size: 20)),
                        const SizedBox(width: 8),
                        const Text("पंडित जी बुक करें 🪔", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Text("सत्यापित वैदिक ब्राह्मण", style: TextStyle(color: Colors.green.shade800, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 32,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _cities.length,
                    itemBuilder: (context, index) {
                      final city = _cities[index];
                      final isSelected = _selectedCity == city;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCity = city),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? kPrimaryBhagwa : const Color(0xFFFFF8F0),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isSelected ? kPrimaryBhagwa : Colors.orange.shade200),
                          ),
                          child: Text(city, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, color: isSelected ? Colors.white : kTextColor)),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Column(children: filteredPandits.map((pandit) => _buildPanditCard(pandit)).toList()),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("लाइव ज्योतिषी 🔴", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor)),
              InkWell(onTap: () => setState(() => _currentIndex = 3), child: const Text("सभी देखें", style: TextStyle(fontSize: 12, color: kPrimaryBhagwa, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 155,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              itemCount: _liveAstrologers.length,
              itemBuilder: (context, index) {
                final astro = _liveAstrologers[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AstrologerDetailScreen(
                          name: _isEnglish ? astro.name : astro.nameHi,
                          imageUrl: astro.imageUrl,
                          experience: "12+ वर्ष",
                          skills: "वैदिक ज्योतिष, टैरो",
                          rating: astro.rating,
                          ratePerMin: "15",
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: kPrimaryBhagwa, width: 2),
                                boxShadow: kCardShadow,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.network(
                                  astro.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: const Color(0xFFFFF0E6),
                                    child: const Icon(Icons.person_rounded, color: kPrimaryBhagwa, size: 40),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.videocam_rounded, size: 9, color: Colors.white),
                                    const SizedBox(width: 2),
                                    Text(astro.viewers, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isEnglish ? astro.name : astro.nameHi,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kTextColor),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          // 🌟 MY RECENT SESSIONS SECTION (Package-based, Clickable Profile, No /min)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("My Recent Sessions 🔄", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor)),
              InkWell(
                onTap: _openConsultationHistory,
                child: const Text("इतिहास देखें", style: TextStyle(fontSize: 12, color: kPrimaryBhagwa, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 125,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              itemCount: _recentSessions.length,
              itemBuilder: (context, index) {
                final session = _recentSessions[index];
                return Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kCardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange.shade200, width: 1.2),
                    boxShadow: kCardShadow,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Photo Click -> Astrologer Profile Bio Data
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AstrologerDetailScreen(
                                name: session.name,
                                imageUrl: session.imageUrl,
                                experience: session.rate,
                                skills: session.skills,
                                rating: session.rating,
                                ratePerMin: "15",
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(session.imageUrl),
                              backgroundColor: const Color(0xFFFFF0E6),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(6)),
                                child: const Text("Online", style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Name Click -> Astrologer Profile Bio Data
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AstrologerDetailScreen(
                                      name: session.name,
                                      imageUrl: session.imageUrl,
                                      experience: session.rate,
                                      skills: session.skills,
                                      rating: session.rating,
                                      ratePerMin: "15",
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                session.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(session.skills, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: kSubTextColor)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: kGoldAccent, size: 12),
                                Text(" ${session.rating} • ${session.rate}", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kTextColor)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              height: 26,
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AstrologerDetailScreen(
                                        name: session.name,
                                        imageUrl: session.imageUrl,
                                        experience: session.rate,
                                        skills: session.skills,
                                        rating: session.rating,
                                        ratePerMin: "15",
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.phone_in_talk_rounded, size: 10, color: Colors.white),
                                label: const Text("दुबारा जुड़ें", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryBhagwa,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.zero,
                                  elevation: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ASTROLOGY BLOGS & REMEDIES
          const Text("ज्योतिष ज्ञान एवं उपाय 📚", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor)),
          const SizedBox(height: 10),

          SizedBox(
            height: 195,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              itemCount: _blogsList.length,
              itemBuilder: (context, index) {
                final blog = _blogsList[index];
                return Container(
                  width: 230,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: kCardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.orange.shade100),
                    boxShadow: kCardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                            child: Image.network(
                              blog.imageUrl,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 100,
                                color: const Color(0xFFFFF0E6),
                                child: const Icon(Icons.menu_book_rounded, color: kPrimaryBhagwa),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(180),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _isEnglish ? blog.category : blog.categoryHi,
                                style: const TextStyle(color: kGoldAccent, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEnglish ? blog.title : blog.titleHi,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: kTextColor, fontSize: 11, fontWeight: FontWeight.bold, height: 1.25),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () => _openBlogReader(blog),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text("पूरा पढ़ें", style: TextStyle(color: kPrimaryBhagwa, fontSize: 11, fontWeight: FontWeight.bold)),
                                  Icon(Icons.arrow_forward_rounded, size: 13, color: kPrimaryBhagwa),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 22),

          // 3. PROFESSIONAL MANAGEMENT FEEDBACK BOX
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFB74D), width: 1.2),
              boxShadow: kCardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: kPrimaryBhagwa, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("प्रबंधन एवं ओनर ऑफिस सहायता", style: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.bold)),
                        Text("सीधे मैनेजमेंट तक अपनी बात पहुँचाएँ", style: TextStyle(color: kSubTextColor, fontSize: 10.5)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Category Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFCC80)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedFeedbackType,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: kPrimaryBhagwa),
                      items: _feedbackTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kTextColor)),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedFeedbackType = newValue!;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Text Field
                TextField(
                  controller: _feedbackController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 12, color: kTextColor),
                  decoration: InputDecoration(
                    hintText: "यहाँ अपना सुझाव, शिकायत या विचार विस्तार से लिखें...",
                    hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFCC80))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFCC80))),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),

                const SizedBox(height: 12),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: _submitFeedback,
                    icon: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
                    label: const Text("ओनर ऑफिस को सुरक्षित भेजें 🏛️", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBhagwa,
                      elevation: 3,
                      shadowColor: Colors.orange.withAlpha(120),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPanditCard(PanditBookingItem pandit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange.shade200, width: 1.2),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PanditDetailScreen(
                    name: pandit.name,
                    imageUrl: pandit.imageUrl,
                    tradition: pandit.tradition,
                    experience: pandit.exp,
                    city: pandit.city,
                    dakshina: pandit.dakshina,
                    rating: pandit.rating,
                    completedPujas: "1,250+",
                    followers: "14.2k",
                  ),
                ),
              );
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(pandit.imageUrl),
              backgroundColor: const Color(0xFFFFF0E6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PanditDetailScreen(
                      name: pandit.name,
                      imageUrl: pandit.imageUrl,
                      tradition: pandit.tradition,
                      experience: pandit.exp,
                      city: pandit.city,
                      dakshina: pandit.dakshina,
                      rating: pandit.rating,
                      completedPujas: "1,250+",
                      followers: "14.2k",
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pandit.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor)),
                  const SizedBox(height: 2),
                  Text(pandit.tradition, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: kPrimaryBhagwa, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text("अनुभव: ${pandit.exp} • दक्षिणा: ${pandit.dakshina}", style: const TextStyle(fontSize: 10.5, color: kSubTextColor)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 44,
            child: ElevatedButton(
              onPressed: () => _openPanditBookingModal(pandit),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryBhagwa,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: Colors.orange.withAlpha(160),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 18),
              ),
              child: const Text(
                "बुक करें 🪔",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: kCardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.orange.shade100), boxShadow: kCardShadow),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kTextColor)),
        ],
      ),
    );
  }
}

class _ShubhMuhuratTickerBanner extends StatefulWidget {
  const _ShubhMuhuratTickerBanner();

  @override
  State<_ShubhMuhuratTickerBanner> createState() => _ShubhMuhuratTickerBannerState();
}

class _ShubhMuhuratTickerBannerState extends State<_ShubhMuhuratTickerBanner> {
  late PageController _tickerController;
  Timer? _tickerTimer;
  int _tickerIndex = 0;

  final List<Map<String, dynamic>> _muhuratList = [
    {"icon": Icons.stars_rounded, "text": "आज का अभिजित मुहूर्त: दोपहर 11:45 से 12:35 तक (शुभ कार्य हेतु श्रेष्ठ)"},
    {"icon": Icons.warning_amber_rounded, "text": "आज का राहुकाल: दोपहर 01:30 से 03:00 तक (इस दौरान नया कार्य न करें)"},
    {"icon": Icons.wb_sunny_rounded, "text": "आज का ब्रह्म मुहूर्त: सुबह 04:20 से 05:10 तक (ध्यान व साधना हेतु उत्तम)"},
    {"icon": Icons.favorite_rounded, "text": "आज का गोचर: चंद्रमा तुला राशि में विराजमान, मानसिक शांति मिलेगी"},
    {"icon": Icons.flare_rounded, "text": "आज का अमृत काल: शाम 05:15 से 06:45 तक (व्यापारिक सौदों के लिए शुभ)"},
    {"icon": Icons.local_fire_department_rounded, "text": "दैनिक उपाय: आज सुबह स्नान के बाद सूर्य देव को जल व लाल फूल अर्पित करें"},
  ];

  @override
  void initState() {
    super.initState();
    _tickerController = PageController();
    _tickerTimer = Timer.periodic(const Duration(milliseconds: 3500), (timer) {
      if (_tickerController.hasClients) {
        _tickerIndex = (_tickerIndex + 1) % _muhuratList.length;
        _tickerController.animateToPage(
          _tickerIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _tickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PanchangScreen()));
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.orange.shade300, width: 1.2),
          boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            Icon(_muhuratList[_tickerIndex]["icon"], color: const Color(0xFFE65100), size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: PageView.builder(
                controller: _tickerController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _muhuratList.length,
                itemBuilder: (context, index) {
                  final item = _muhuratList[index];
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item["text"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF2E1500),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF795548)),
          ],
        ),
      ),
    );
  }
}

class _HomeBannerSlider extends StatefulWidget {
  final List<BannerItem> fallbackBanners;
  final VoidCallback onBannerTap;

  const _HomeBannerSlider({required this.fallbackBanners, required this.onBannerTap});

  @override
  State<_HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<_HomeBannerSlider> {
  late PageController _controller;
  Timer? _timer;
  int _currentIndex = 0;
  List<BannerItem> _dbBanners = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _fetchBannersFromSupabase();
  }

  Future<void> _fetchBannersFromSupabase() async {
    try {
      final response = await Supabase.instance.client
          .from('banners')
          .select()
          .eq('is_active', true);

      if (response.isNotEmpty && mounted) {
        setState(() {
          _dbBanners = response.map((item) {
            return BannerItem(
              badge: item['badge'] ?? "दिव्य मार्गदर्शन 🚩",
              title: item['title'] ?? "शीर्ष वैदिक ज्योतिषियों से जुड़ें",
              subtitle: item['subtitle'] ?? "करियर, विवाह और जीवन से जुड़े सभी प्रश्नों के सटीक समाधान।",
              btnText: item['btn_text'] ?? "अभी संपर्क करें",
              imageUrl: item['image_url'] ?? "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&auto=format&fit=crop&q=80",
              gradient: const [Color(0xFFFF6F00), Color(0xFFFF3D00)],
            );
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final activeList = _dbBanners.isNotEmpty ? _dbBanners : widget.fallbackBanners;
      if (_controller.hasClients && activeList.isNotEmpty) {
        _currentIndex = (_currentIndex + 1) % activeList.length;
        _controller.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeBanners = _dbBanners.isNotEmpty ? _dbBanners : widget.fallbackBanners;

    return SizedBox(
      height: 165,
      child: PageView.builder(
        controller: _controller,
        physics: const ClampingScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemCount: activeBanners.length,
        itemBuilder: (context, index) {
          final banner = activeBanners[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: banner.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: banner.gradient.first.withAlpha(90),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          banner.badge,
                          style: const TextStyle(color: kGoldAccent, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            banner.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70, fontSize: 10, height: 1.2),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: widget.onBannerTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: kDeepSaffron,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          minimumSize: const Size(60, 28),
                          elevation: 2,
                        ),
                        child: Text(banner.btnText, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 105,
                          height: 105,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: kGoldAccent.withAlpha(200), width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              banner.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.white24,
                                child: const Icon(Icons.person_rounded, color: Colors.white, size: 40),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(190),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.verified_rounded, color: kGoldAccent, size: 10),
                                SizedBox(width: 3),
                                Text("VERIFIED", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}