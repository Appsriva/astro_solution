import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'active_chat_screen.dart';
import 'astrologer_detail_screen.dart';
import 'wallet_screen.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);

class QuestionPrompt {
  final String textEn;
  final String category;

  const QuestionPrompt({
    required this.textEn,
    required this.category,
  });
}

class CategoryItem {
  final String key;
  final String label;
  final IconData icon;
  final Color iconColor;

  const CategoryItem({
    required this.key,
    required this.label,
    required this.icon,
    required this.iconColor,
  });
}

class ChatPackageItem {
  final String id;
  final String title;
  final String duration;
  final int price;
  final String badge;
  final bool isPopular;

  const ChatPackageItem({
    required this.id,
    required this.title,
    required this.duration,
    required this.price,
    required this.badge,
    this.isPopular = false,
  });
}

class ChatAstrologer {
  final String name;
  final String specialty;
  final String languages;
  final String planTag;
  final double rating;
  final String orders;
  final List<String> categories;
  final bool isOnline;

  const ChatAstrologer({
    required this.name,
    required this.specialty,
    required this.languages,
    required this.planTag,
    required this.rating,
    required this.orders,
    required this.categories,
    required this.isOnline,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _selectedCategory = "All";
  
  final supabase = Supabase.instance.client;
  double _userWalletBalance = 50.0;
  StreamSubscription? _walletSubscription;

  late PageController _promptController;
  Timer? _promptTimer;
  int _currentPromptIndex = 0;

  static const List<ChatPackageItem> _consultationPackages = [
    ChatPackageItem(
      id: "pkg_50",
      title: "₹50 पैक",
      duration: "10 मिनट चैट परामर्श",
      price: 50,
      badge: "STARTER",
    ),
    ChatPackageItem(
      id: "pkg_155",
      title: "₹155 पैक",
      duration: "30 मिनट चैट परामर्श",
      price: 155,
      badge: "MOST POPULAR 🔥",
      isPopular: true,
    ),
    ChatPackageItem(
      id: "pkg_299",
      title: "₹299 पैक",
      duration: "60 मिनट (1 घंटा) चैट",
      price: 299,
      badge: "BEST VALUE ✨",
    ),
    ChatPackageItem(
      id: "pkg_555",
      title: "₹555 पैक",
      duration: "अनलिमिटेड चैट (नो लिमिट)",
      price: 555,
      badge: "UNLIMITED 🔱",
    ),
    ChatPackageItem(
      id: "pkg_1100",
      title: "₹1,100 पैक",
      duration: "150 मिनट + VIP चैट",
      price: 1100,
      badge: "VIP MAHA 👑",
    ),
  ];

  static const List<QuestionPrompt> _prompts = [
    QuestionPrompt(textEn: "Will my lover return back to me?", category: "Love"),
    QuestionPrompt(textEn: "Which business is best according to my Kundli?", category: "Career"),
    QuestionPrompt(textEn: "When will I get married and to whom?", category: "Marriage"),
    QuestionPrompt(textEn: "How will my upcoming year 2026 be?", category: "Kundli"),
  ];

  static const List<CategoryItem> _categories = [
    CategoryItem(key: "All", label: "All", icon: Icons.grid_view_rounded, iconColor: Color(0xFFFFA000)),
    CategoryItem(key: "Love", label: "Love", icon: Icons.favorite_rounded, iconColor: Color(0xFFE91E63)),
    CategoryItem(key: "Career", label: "Career", icon: Icons.work_rounded, iconColor: Color(0xFF29B6F6)),
    CategoryItem(key: "Marriage", label: "Marriage", icon: Icons.favorite_border_rounded, iconColor: Color(0xFFFF5252)),
    CategoryItem(key: "Kundli", label: "Kundli", icon: Icons.menu_book_rounded, iconColor: Color(0xFFFF9800)),
    CategoryItem(key: "Tarot", label: "Tarot", icon: Icons.style_rounded, iconColor: Color(0xFFAB47BC)),
  ];

  static const List<ChatAstrologer> _chatAstrologersList = [
    ChatAstrologer(
      name: "टैरो नेहा शर्मा",
      specialty: "टैरो कार्ड एवं लव गाइडेंस • 8 वर्ष",
      languages: "हिंदी, English",
      planTag: "30 मिनट / अनलिमिटेड उपलब्ध",
      rating: 4.9,
      orders: "18.4k",
      categories: ["All", "Love", "Marriage", "Tarot"],
      isOnline: true,
    ),
    ChatAstrologer(
      name: "आचार्य विक्रम",
      specialty: "वैदिक ज्योतिष एवं प्रश्न कुंडली • 14 वर्ष",
      languages: "हिंदी, संस्कृत, गुजराती",
      planTag: "सभी पैक्स में उपलब्ध",
      rating: 5.0,
      orders: "26.1k",
      categories: ["All", "Career", "Kundli", "Marriage"],
      isOnline: true,
    ),
    ChatAstrologer(
      name: "डॉ. मानसी जोशी",
      specialty: "रिलेशनशिप एक्सपर्ट एवं अंकशास्त्र • 9 वर्ष",
      languages: "हिंदी, English",
      planTag: "30 मिनट / अनलिमिटेड उपलब्ध",
      rating: 4.8,
      orders: "12.7k",
      categories: ["All", "Love", "Career"],
      isOnline: true,
    ),
    ChatAstrologer(
      name: "पं. राघवेंद्र जी",
      specialty: "कुंडली दोष एवं व्यापार विशेषज्ञ • 16 वर्ष",
      languages: "हिंदी, राजस्थानी",
      planTag: "व्यापार विशेष पैक",
      rating: 4.7,
      orders: "9.2k",
      categories: ["All", "Career", "Kundli"],
      isOnline: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _promptController = PageController(initialPage: 0);
    _startPromptSlider();
    _fetchLiveWalletBalance();
  }

  void _fetchLiveWalletBalance() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      _walletSubscription = supabase
          .from('profiles')
          .stream(primaryKey: ['id'])
          .eq('id', user.id)
          .listen((List<Map<String, dynamic>> data) {
        if (data.isNotEmpty && mounted) {
          setState(() {
            _userWalletBalance = (data.first['wallet_balance'] ?? 50.0).toDouble();
          });
        }
      });
    }
  }

  void _startPromptSlider() {
    _promptTimer?.cancel();
    _promptTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_promptController.hasClients) {
        if (_currentPromptIndex < _prompts.length - 1) {
          _currentPromptIndex++;
        } else {
          _currentPromptIndex = 0;
        }
        _promptController.animateToPage(
          _currentPromptIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _promptTimer?.cancel();
    _promptController.dispose();
    _walletSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startChatSession(ChatAstrologer astro, ChatPackageItem activePack) async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      try {
        final double newBalance = _userWalletBalance - activePack.price;

        await supabase.from('profiles').update({
          'wallet_balance': newBalance,
        }).eq('id', user.id);

        await supabase.from('wallet_transactions').insert({
          'user_id': user.id,
          'amount': activePack.price,
          'type': 'debit',
          'description': "चैट परामर्श - ${astro.name} (${activePack.title})",
        });

        await supabase.from('chat_messages').insert({
          'sender_id': user.id,
          'receiver_name': astro.name,
          'is_astrologer': true,
          'message': "नमस्ते ${user.email ?? 'यजमान'} जी। ${astro.name} से आपकी चैट (${activePack.title}) प्रारंभ हो चुकी है। आप अपना प्रश्न पूछ सकते हैं। 🙏",
        });
      } catch (_) {}
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveChatScreen(
          astrologerName: astro.name,
          specialty: astro.specialty,
          packageName: activePack.title,
          durationText: activePack.duration,
        ),
      ),
    );
  }

  void _openChatPackageModal(ChatAstrologer astro) {
    int selectedIndex = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final activePack = _consultationPackages[selectedIndex];
            final bool hasEnoughBalance = _userWalletBalance >= activePack.price;

            return Container(
              height: MediaQuery.of(context).size.height * 0.72,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundColor: Color(0xFFFFF3E0),
                        child: Icon(Icons.person_rounded, color: kPrimaryBhagwa, size: 32),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              astro.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
                            ),
                            Text(
                              astro.specialty,
                              style: const TextStyle(fontSize: 11, color: kSubTextColor),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "चैट उपलब्ध 💬",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "वॉलेट बैलेंस (Wallet Balance):",
                        style: TextStyle(color: kTextColor, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "₹${_userWalletBalance.toStringAsFixed(0)}",
                        style: const TextStyle(color: Color(0xFFE65100), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "चैट पैकेज चुनें (Select Chat Package):",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _consultationPackages.length,
                      itemBuilder: (context, index) {
                        final pkg = _consultationPackages[index];
                        final isSelected = selectedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFFFF8F0) : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? kPrimaryBhagwa : Colors.grey.shade200,
                                width: isSelected ? 1.8 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
                                  color: isSelected ? kPrimaryBhagwa : Colors.grey.shade400,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            pkg.title,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: kTextColor,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: pkg.isPopular
                                                  ? Colors.red.shade50
                                                  : kPrimaryBhagwa.withAlpha(30),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              pkg.badge,
                                              style: TextStyle(
                                                color: pkg.isPopular ? Colors.red.shade700 : kPrimaryBhagwa,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        pkg.duration,
                                        style: const TextStyle(
                                          color: Color(0xFFE65100),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        if (!hasEnoughBalance) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const WalletScreen()),
                          );
                        } else {
                          _startChatSession(astro, activePack);
                        }
                      },
                      icon: Icon(
                        hasEnoughBalance ? Icons.chat_bubble_rounded : Icons.account_balance_wallet_rounded,
                        size: 18,
                      ),
                      label: Text(
                        hasEnoughBalance
                            ? "${activePack.title} से चैट शुरू करें (${activePack.duration})"
                            : "रिचार्ज करें (${activePack.title} के लिए)",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hasEnoughBalance ? kPrimaryBhagwa : const Color(0xFFE65100),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = kPrimaryBhagwa.withAlpha(30);

    final filteredList = _selectedCategory == "All"
        ? _chatAstrologersList
        : _chatAstrologersList
            .where((astro) => astro.categories.contains(_selectedCategory))
            .toList();

    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 6),
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat.key;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat.key;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimaryBhagwa.withAlpha(40) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected ? kPrimaryBhagwa : Colors.orange.shade100,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(cat.icon, size: 16, color: cat.iconColor),
                          const SizedBox(width: 6),
                          Text(
                            cat.label,
                            style: TextStyle(
                              color: isSelected ? kPrimaryBhagwa : kTextColor,
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF9C4), Color(0xFFFFECB3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFD54F), width: 1.2),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -10,
                      top: -10,
                      bottom: -10,
                      child: Container(
                        width: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFD54F).withAlpha(60),
                          border: Border.all(color: const Color(0xFFFFCA28), width: 2),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: PageView.builder(
                                    controller: _promptController,
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentPromptIndex = index;
                                      });
                                    },
                                    itemCount: _prompts.length,
                                    itemBuilder: (context, index) {
                                      final prompt = _prompts[index];
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          prompt.textEn,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Color(0xFF3E2723),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            height: 1.3,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                    _prompts.length,
                                    (dotIndex) => AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.only(right: 5),
                                      width: _currentPromptIndex == dotIndex ? 14 : 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: _currentPromptIndex == dotIndex
                                            ? Colors.black87
                                            : Colors.black26,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(200),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFFFB300), width: 1.5),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 28,
                                color: Color(0xFFE65100),
                              ),
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
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final astro = filteredList[index];
                  return _buildChatCard(astro, borderColor);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatCard(ChatAstrologer astro, Color borderColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AstrologerDetailScreen(
              name: astro.name,
              imageUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80",
              experience: "10 वर्ष",
              skills: astro.specialty,
              rating: astro.rating.toString(),
              ratePerMin: "15",
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: kPrimaryBhagwa.withAlpha(40),
                  child: const Icon(Icons.person_rounded, color: kPrimaryBhagwa, size: 34),
                ),
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: astro.isOnline ? Colors.greenAccent.shade700 : Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: kCardColor, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        astro.name,
                        style: const TextStyle(
                          color: kTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified_rounded, color: Color(0xFF00B0FF), size: 16),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    astro.specialty,
                    style: const TextStyle(color: kSubTextColor, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    astro.languages,
                    style: const TextStyle(color: kSubTextColor, fontSize: 10),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        "${astro.rating} (${astro.orders})",
                        style: const TextStyle(color: kTextColor, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: kPrimaryBhagwa.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          astro.planTag,
                          style: const TextStyle(color: kPrimaryBhagwa, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: astro.isOnline ? () => _openChatPackageModal(astro) : null,
              icon: const Icon(Icons.chat_bubble_rounded, size: 14),
              label: Text(
                astro.isOnline ? "चैट करें" : "ऑफलाइन",
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryBhagwa,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade600,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                minimumSize: const Size(60, 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}