import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'active_call_screen.dart';
import 'astrologer_detail_screen.dart'; // 👈 ज्योतिषी प्रोफाइल स्क्रीन इम्पोर्ट
import 'wallet_screen.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);

class OfficialPackage {
  final String id;
  final String price;
  final String badge;
  final String mainText;
  final String subText;
  final int minutes;
  final int priceValue;
  final Color badgeColor;

  const OfficialPackage({
    required this.id,
    required this.price,
    required this.badge,
    required this.mainText,
    required this.subText,
    required this.minutes,
    required this.priceValue,
    required this.badgeColor,
  });
}

class AstrologerCallItem {
  final String id;
  final String name;
  final String skills;
  final String languages;
  final int experience;
  final double rating;
  final int orders;
  final bool isOnline;
  final bool isBusy;

  const AstrologerCallItem({
    required this.id,
    required this.name,
    required this.skills,
    required this.languages,
    required this.experience,
    required this.rating,
    required this.orders,
    required this.isOnline,
    required this.isBusy,
  });
}

class CategoryModel {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryModel({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "सभी";

  final PageController _promptController = PageController();
  Timer? _promptTimer;
  int _currentPromptIndex = 0;

  // Live Supabase Wallet Balance
  final supabase = Supabase.instance.client;
  double _userWalletBalance = 50.0;
  StreamSubscription? _walletSubscription;

  static const List<String> _astrotalkPrompts = [
    "💖 When will my ex back in my life?",
    "💼 Which business or job is best for my career?",
    "💍 When will I get married? Kundli matching",
    "🔮 How will my upcoming year 2026 be?",
    "💰 Financial growth & money solutions",
  ];

  static const List<CategoryModel> _categories = [
    CategoryModel(name: "सभी", icon: Icons.grid_view_rounded, color: Color(0xFFFF6F00)),
    CategoryModel(name: "Love", icon: Icons.favorite_rounded, color: Color(0xFFE91E63)),
    CategoryModel(name: "Career", icon: Icons.work_rounded, color: Color(0xFF0288D1)),
    CategoryModel(name: "Financial", icon: Icons.currency_rupee_rounded, color: Color(0xFF388E3C)),
    CategoryModel(name: "Marriage", icon: Icons.handshake_rounded, color: Color(0xFFC2185B)),
    CategoryModel(name: "Kundli", icon: Icons.menu_book_rounded, color: Color(0xFFF57C00)),
  ];

  static const List<OfficialPackage> _officialPackages = [
    OfficialPackage(
      id: "pkg_50",
      price: "₹50",
      badge: "SPECIAL",
      mainText: "10 मिनट परामर्श",
      subText: "+ ₹10 बोनस शामिल",
      minutes: 10,
      priceValue: 50,
      badgeColor: Color(0xFFFF6F00),
    ),
    OfficialPackage(
      id: "pkg_155",
      price: "₹155",
      badge: "MOST POPULAR ⏳",
      mainText: "30 मिनट चैट या कॉल",
      subText: "+ संपूर्ण कुंडली विश्लेषण",
      minutes: 30,
      priceValue: 155,
      badgeColor: Color(0xFFD84315),
    ),
    OfficialPackage(
      id: "pkg_299",
      price: "₹299",
      badge: "BEST VALUE",
      mainText: "60 मिनट (1 घंटा) बात करें",
      subText: "+ संपूर्ण कुंडली एवं समाधान",
      minutes: 60,
      priceValue: 299,
      badgeColor: Color(0xFFE65100),
    ),
    OfficialPackage(
      id: "pkg_555",
      price: "₹555",
      badge: "UNLIMITED PACK 🔱",
      mainText: "अनलिमिटेड बात करें (नो टाइम लिमिट)",
      subText: "+ सम्पूर्ण जीवनफल + उपाय",
      minutes: 0,
      priceValue: 555,
      badgeColor: Color(0xFFC2185B),
    ),
    OfficialPackage(
      id: "pkg_1100",
      price: "₹1,100",
      badge: "VIP PACK & REMEDY 👑",
      mainText: "150 मिनट बात + VIP प्रायोरिटी",
      subText: "+ विशेष संपूर्ण मार्गदर्शन",
      minutes: 150,
      priceValue: 1100,
      badgeColor: Color(0xFF6A1B9A),
    ),
  ];

  static const List<AstrologerCallItem> _astrologers = [
    AstrologerCallItem(
      id: "ast_1",
      name: "आचार्य विद्याधर त्रिपाठी",
      skills: "वैदिक ज्योतिष, Kundli, Marriage, कर्मकांड",
      languages: "हिन्दी, संस्कृत, English",
      experience: 16,
      rating: 4.9,
      orders: 4520,
      isOnline: true,
      isBusy: false,
    ),
    AstrologerCallItem(
      id: "ast_2",
      name: "टैरो पलक शर्मा",
      skills: "Tarot, Love, Relationship, Financial",
      languages: "हिन्दी, English, पंजाबी",
      experience: 8,
      rating: 4.95,
      orders: 3180,
      isOnline: true,
      isBusy: false,
    ),
    AstrologerCallItem(
      id: "ast_3",
      name: "पं. देवेन्द्र नाथ शुक्ल",
      skills: "वैदिक, Vastu Shastra, Career, Kundli",
      languages: "हिन्दी, गुजराती",
      experience: 22,
      rating: 5.0,
      orders: 6890,
      isOnline: true,
      isBusy: true,
    ),
    AstrologerCallItem(
      id: "ast_4",
      name: "एस्ट्रो ऊर्जा सिंह",
      skills: "Numerology (अंक ज्योतिष), Financial, Career",
      languages: "हिन्दी, English",
      experience: 11,
      rating: 4.85,
      orders: 2240,
      isOnline: true,
      isBusy: false,
    ),
    AstrologerCallItem(
      id: "ast_5",
      name: "डॉ. भानु प्रताप मिश्र",
      skills: "Medical Astrology, Career, Vastu",
      languages: "हिन्दी, बंगाली, English",
      experience: 19,
      rating: 4.92,
      orders: 5120,
      isOnline: false,
      isBusy: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
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
        if (_currentPromptIndex < _astrotalkPrompts.length - 1) {
          _currentPromptIndex++;
        } else {
          _currentPromptIndex = 0;
        }
        _promptController.animateToPage(
          _currentPromptIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _promptTimer?.cancel();
    _promptController.dispose();
    _walletSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startCallSession(AstrologerCallItem astro, OfficialPackage chosenPack) async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      try {
        final double newBalance = _userWalletBalance - chosenPack.priceValue;

        // 1. Update Profile Wallet Balance
        await supabase.from('profiles').update({
          'wallet_balance': newBalance,
        }).eq('id', user.id);

        // 2. Insert debit transaction
        await supabase.from('wallet_transactions').insert({
          'user_id': user.id,
          'amount': chosenPack.priceValue,
          'type': 'debit',
          'description': "कॉल परामर्श - ${astro.name} (${chosenPack.price})",
        });
      } catch (_) {}
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveCallScreen(
          astrologerName: astro.name,
          astrologerRole: astro.skills,
          packageName: "${chosenPack.price} - ${chosenPack.mainText}",
          totalMinutes: chosenPack.minutes,
        ),
      ),
    );
  }

  void _openPackageSelector(AstrologerCallItem astro) {
    if (astro.isBusy) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${astro.name} जी अभी दूसरी कॉल पर व्यस्त हैं।"), backgroundColor: Colors.orange.shade800),
      );
      return;
    }

    if (!astro.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${astro.name} जी अभी ऑफलाइन हैं।"), backgroundColor: Colors.grey.shade800),
      );
      return;
    }

    int selectedPackIndex = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final chosenPack = _officialPackages[selectedPackIndex];
            final bool hasEnoughBalance = _userWalletBalance >= chosenPack.priceValue;

            return Container(
              height: MediaQuery.of(context).size.height * 0.88,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
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
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFFFFF0E6),
                        child: Icon(Icons.person_rounded, color: kPrimaryBhagwa, size: 28),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(astro.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
                            Text("${astro.skills} • ${astro.experience} वर्ष अनुभव", style: const TextStyle(fontSize: 11, color: kSubTextColor)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(modalContext),
                        icon: const Icon(Icons.close_rounded, color: kTextColor),
                      ),
                    ],
                  ),
                  const Divider(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFF6F00), Color(0xFFFF3D00)]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("उपलब्ध वॉलेट बैलेंस:", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        Text("₹${_userWalletBalance.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "परामर्श पैकेज चुनें (Select Package):",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _officialPackages.length,
                      itemBuilder: (context, index) {
                        final pack = _officialPackages[index];
                        final isSelected = selectedPackIndex == index;

                        return GestureDetector(
                          onTap: () => setModalState(() => selectedPackIndex = index),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFFFF7F0) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? kPrimaryBhagwa : Colors.orange.shade100,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Radio<int>(
                                  value: index,
                                  groupValue: selectedPackIndex,
                                  activeColor: kPrimaryBhagwa,
                                  onChanged: (val) => setModalState(() => selectedPackIndex = val!),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(pack.price, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: pack.badgeColor.withAlpha(25),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              pack.badge,
                                              style: TextStyle(color: pack.badgeColor, fontSize: 9, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(pack.mainText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kTextColor)),
                                      Text(pack.subText, style: const TextStyle(fontSize: 10, color: kSubTextColor)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.phone_in_talk_rounded, size: 18, color: Colors.grey),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(modalContext);
                        if (!hasEnoughBalance) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const WalletScreen()),
                          );
                        } else {
                          _startCallSession(astro, chosenPack);
                        }
                      },
                      icon: Icon(hasEnoughBalance ? Icons.call_rounded : Icons.account_balance_wallet_rounded, size: 18),
                      label: Text(
                        hasEnoughBalance
                            ? "${chosenPack.price} में कॉल शुरू करें 🚩"
                            : "रिचार्ज करें (${chosenPack.price} के लिए)",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hasEnoughBalance ? Colors.green.shade700 : const Color(0xFFE65100),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
    final query = _searchController.text.trim().toLowerCase();
    final filteredList = _astrologers.where((astro) {
      final matchesSearch = astro.name.toLowerCase().contains(query) ||
          astro.skills.toLowerCase().contains(query) ||
          astro.languages.toLowerCase().contains(query);

      if (!matchesSearch) return false;

      if (_selectedCategory == "सभी") return true;
      return astro.skills.toLowerCase().contains(_selectedCategory.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() {}),
                style: const TextStyle(fontSize: 13, color: kTextColor),
                decoration: InputDecoration(
                  hintText: "ज्योतिषी का नाम, विद्या या भाषा खोजें...",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                  prefixIcon: const Icon(Icons.search_rounded, color: kPrimaryBhagwa, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.orange.shade100)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.orange.shade100)),
                ),
              ),
            ),

            // Question Prompts Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF9C4), Color(0xFFFFECB3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFD54F), width: 1.2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded, color: Color(0xFFE65100), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PageView.builder(
                        controller: _promptController,
                        itemCount: _astrotalkPrompts.length,
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _astrotalkPrompts[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF3E2723),
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.brown),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Icon-based Categories Filter
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat.name;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat.name),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimaryBhagwa : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: isSelected ? kPrimaryBhagwa : Colors.orange.shade200),
                        boxShadow: isSelected ? [BoxShadow(color: Colors.orange.withAlpha(80), blurRadius: 4, offset: const Offset(0, 2))] : [],
                      ),
                      child: Row(
                        children: [
                          Icon(cat.icon, size: 15, color: isSelected ? Colors.white : cat.color),
                          const SizedBox(width: 6),
                          Text(
                            cat.name,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              color: isSelected ? Colors.white : kTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Astrologers List
            Expanded(
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final astro = filteredList[index];
                  return _buildAstrologerCard(astro);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAstrologerCard(AstrologerCallItem astro) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AstrologerDetailScreen(
              name: astro.name,
              imageUrl: "https://images.unsplash.com/photo-1544717305-2782549b5136?w=400&auto=format&fit=crop&q=80",
              experience: "${astro.experience} वर्ष",
              skills: astro.skills,
              rating: astro.rating.toString(),
              ratePerMin: "15",
              status: astro.isOnline ? "Online" : "Offline",
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.orange.shade100),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.orange.shade200, width: 1.5),
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Color(0xFFFFF0E6),
                        child: Icon(Icons.person_rounded, size: 34, color: kPrimaryBhagwa),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: astro.isBusy
                              ? Colors.red
                              : (astro.isOnline ? Colors.green : Colors.grey),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                    const SizedBox(width: 2),
                    Text(astro.rating.toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kTextColor)),
                  ],
                ),
                Text("${astro.orders} परामर्श", style: const TextStyle(fontSize: 9, color: kSubTextColor)),
              ],
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          astro.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified_rounded, color: Colors.blue, size: 14),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    astro.skills,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: kSubTextColor),
                  ),
                  Text(
                    "भाषा: ${astro.languages}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: kSubTextColor),
                  ),
                  Text(
                    "अनुभव: ${astro.experience} वर्ष",
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: kTextColor),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: const Text(
                      "₹50 • ₹155 • ₹299 • ₹555 • ₹1,100",
                      style: TextStyle(color: Color(0xFF1B5E20), fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Highlighted Call Button
            Container(
              decoration: BoxDecoration(
                gradient: astro.isOnline && !astro.isBusy
                    ? const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF43A047)])
                    : null,
                color: astro.isBusy ? Colors.red.shade50 : (!astro.isOnline ? Colors.grey.shade100 : null),
                borderRadius: BorderRadius.circular(12),
                boxShadow: astro.isOnline && !astro.isBusy
                    ? [BoxShadow(color: Colors.green.withAlpha(100), blurRadius: 6, offset: const Offset(0, 3))]
                    : [],
                border: Border.all(
                  color: astro.isBusy ? Colors.red : (astro.isOnline ? Colors.green.shade700 : Colors.grey.shade400),
                  width: 1.5,
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: () => _openPackageSelector(astro),
                icon: Icon(
                  Icons.call_rounded,
                  size: 14,
                  color: astro.isBusy ? Colors.red : (astro.isOnline ? Colors.white : Colors.grey.shade600),
                ),
                label: Text(
                  astro.isBusy ? "व्यस्त" : (astro.isOnline ? "कॉल करें" : "ऑफलाइन"),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: astro.isBusy ? Colors.red : (astro.isOnline ? Colors.white : Colors.grey.shade600),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: const Size(70, 34),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}