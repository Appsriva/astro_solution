import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

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

class FloatingItem {
  final int id;
  final String emoji;
  final double startX;
  double yOffset = 0;

  FloatingItem({required this.id, required this.emoji, required this.startX});
}

class ChatMessage {
  final String user;
  final String message;
  final bool isVip;
  final String amount;

  ChatMessage({required this.user, required this.message, this.isVip = false, this.amount = ""});
}

class TempleDarshanItem {
  final String id;
  final String templeName;
  final String deity;
  final String location;
  final String viewers;
  final String nextAarti;
  final IconData templeIcon;
  final String liveStatus;
  final String mantra;

  const TempleDarshanItem({
    required this.id,
    required this.templeName,
    required this.deity,
    required this.location,
    required this.viewers,
    required this.nextAarti,
    required this.templeIcon,
    required this.liveStatus,
    required this.mantra,
  });
}

class LiveDarshanScreen extends StatefulWidget {
  const LiveDarshanScreen({super.key});

  @override
  State<LiveDarshanScreen> createState() => _LiveDarshanScreenState();
}

class _LiveDarshanScreenState extends State<LiveDarshanScreen> with SingleTickerProviderStateMixin {
  int _selectedTempleIndex = 0;
  int _flowersOffered = 108;
  int _bellsRung = 51;
  int _diyaOffered = 21;
  int _totalChadavaAmount = 15100;
  
  bool _isAartiActive = false;
  AnimationController? _aartiController;

  final List<FloatingItem> _floatingElements = [];
  int _counter = 0;

  final TextEditingController _chatController = TextEditingController();

  final List<ChatMessage> _liveChat = [
    ChatMessage(user: "राहुल शर्मा", message: "जय महाकाल! 🙏", isVip: true, amount: "₹251"),
    ChatMessage(user: "प्रिया सिंह", message: "हर हर महादेव 🔱 हर घर शंभू"),
    ChatMessage(user: "अमित कुमार", message: "दर्शन पाकर जीवन धन्य हो गया 🚩", isVip: true, amount: "₹501"),
    ChatMessage(user: "सुनीता गुप्ता", message: "जय बांके बिहारी लाल की 🌸"),
  ];

  static const List<TempleDarshanItem> _templesList = [
    TempleDarshanItem(
      id: "tmp_1",
      templeName: "श्री महाकालेश्वर ज्योतिर्लिंग",
      deity: "भगवान शिव (महाकाल)",
      location: "उज्जैन, मध्य प्रदेश",
      viewers: "14.8k",
      nextAarti: "संध्या आरती (07:00 PM)",
      templeIcon: Icons.temple_hindu_rounded,
      liveStatus: "भस्म आरती व श्रृंगार लाइव",
      mantra: "ॐ नमः शिवाय • ॐ महाकालेश्वराय नमः",
    ),
    TempleDarshanItem(
      id: "tmp_2",
      templeName: "श्री काशी विश्वनाथ धाम",
      deity: "देवाधिदेव महादेव",
      location: "वाराणसी, उत्तर प्रदेश",
      viewers: "12.4k",
      nextAarti: "सप्तर्षि आरती (07:30 PM)",
      templeIcon: Icons.temple_buddhist_rounded,
      liveStatus: "गंगा तट गर्भ गृह लाइव",
      mantra: "हर हर महादेव • काशी विश्वनाथाय नमः",
    ),
    TempleDarshanItem(
      id: "tmp_3",
      templeName: "श्री सिद्धिविनायक मंदिर",
      deity: "भगवान श्री गणेश",
      location: "प्रभादेवी, मुंबई",
      viewers: "8.9k",
      nextAarti: "महा आरती (08:00 PM)",
      templeIcon: Icons.auto_awesome,
      liveStatus: "स्वर्ण सिंहासन लाइव दर्शन",
      mantra: "ॐ गं गणपतये नमः • वक्रतुंड महाकाय",
    ),
    TempleDarshanItem(
      id: "tmp_4",
      templeName: "श्री बांके बिहारी जी मंदिर",
      deity: "भगवान श्रीकृष्ण",
      location: "वृंदावन धाम, मथुरा",
      viewers: "19.5k",
      nextAarti: "शयन आरती (09:00 PM)",
      templeIcon: Icons.favorite_rounded,
      liveStatus: "युगल सरकार दिव्य दर्शन",
      mantra: "राधे राधे • श्री कुंज बिहारी श्री हरिदास",
    ),
  ];

  static const List<int> _quickChadavaAmounts = [
    51, 101, 201, 301, 501, 1001, 2100, 5100, 11000, 21000, 51000, 100001,
  ];

  @override
  void initState() {
    super.initState();
    _aartiController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _aartiController?.dispose();
    _chatController.dispose();
    super.dispose();
  }

  void _offerFlower() {
    setState(() {
      _flowersOffered += 5;
      for (int i = 0; i < 8; i++) {
        _triggerFloatingElement(i % 2 == 0 ? "🌸" : "🌹");
      }
    });
    _showFloatingSnack("🌸 भगवान के चरणों में पुष्पों की भारी वर्षा हुई!", Colors.pinkAccent);
  }

  void _ringBell() {
    setState(() {
      _bellsRung++;
      _triggerFloatingElement("🔔");
    });
    _showFloatingSnack("टन-टन! दिव्य मंदिर की घंटी बजी 🔔🚩", kGoldAccent);
  }

  void _offerDiya() {
    setState(() {
      _diyaOffered++;
      _isAartiActive = true;
      _aartiController?.repeat();
      for (int i = 0; i < 4; i++) {
        _triggerFloatingElement("🪔");
      }
    });
    _showFloatingSnack("✨ भव्य आरती प्रारंभ हुई, थाली परिक्रमा कर रही है!", Colors.orangeAccent);
    
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isAartiActive = false;
          _aartiController?.stop();
        });
      }
    });
  }

  void _sendLiveMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _liveChat.insert(0, ChatMessage(user: "आफ़ताब", message: text));
      _chatController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  void _triggerFloatingElement(String emoji) {
    final randomX = Random().nextDouble() * 260 + 20;
    final item = FloatingItem(id: _counter++, emoji: emoji, startX: randomX);
    setState(() {
      _floatingElements.add(item);
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          _floatingElements.removeWhere((element) => element.id == item.id);
        });
      }
    });
  }

  void _showFloatingSnack(String msg, Color iconColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.auto_awesome, color: iconColor, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(msg, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
          ],
        ),
        backgroundColor: const Color(0xFF2C1304),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openChadavaModal(TempleDarshanItem temple) {
    int selectedAmount = 101;
    final TextEditingController amountController = TextEditingController(text: "101");
    final TextEditingController nameController = TextEditingController(text: "आफ़ताब");
    final TextEditingController gotraController = TextEditingController(text: "कश्यप");
    String selectedSankalp = "सुख, शांति एवं पारिवारिक समृद्धि";

    final List<String> sankalpList = [
      "सुख, शांति एवं पारिवारिक समृद्धि",
      "व्यापार में लाभ एवं कर्ज मुक्ति",
      "रोग निवारण एवं दीर्घायु स्वास्थ्य",
      "मनोकामना पूर्ति एवं ग्रह शांति",
      "शीघ्र विवाह एवं दांपत्य सुख",
      "संतान प्राप्ति एवं उज्ज्वल भविष्य",
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.88,
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
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Color(0xFFFFF0E6), shape: BoxShape.circle),
                          child: const Icon(Icons.monetization_on_rounded, color: kPrimaryBhagwa, size: 24),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("ऑनलाइन चढ़ावा एवं गुप्त दान 🪙", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
                              Text(temple.templeName, style: const TextStyle(fontSize: 11, color: kPrimaryBhagwa, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(modalContext),
                          icon: const Icon(Icons.close_rounded, color: kTextColor),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    const Divider(),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("चढ़ावे की राशि चुनें (Select Amount):", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                            const SizedBox(height: 8),

                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _quickChadavaAmounts.map((amt) {
                                final isSelected = selectedAmount == amt;
                                return GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      selectedAmount = amt;
                                      amountController.text = amt.toString();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: isSelected ? kPrimaryBhagwa : const Color(0xFFFFFDF9),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected ? kPrimaryBhagwa : const Color(0xFFFFCC80),
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Text(
                                      amt >= 100000 ? "₹${amt ~/ 100000} Lakh" : "₹$amt",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                        color: isSelected ? Colors.white : kTextColor,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 14),

                            TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (val) {
                                final parsed = int.tryParse(val) ?? 0;
                                setModalState(() => selectedAmount = parsed);
                              },
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor),
                              decoration: InputDecoration(
                                labelText: "अन्य राशि दर्ज करें",
                                labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                                prefixIcon: const Icon(Icons.currency_rupee_rounded, color: kPrimaryBhagwa, size: 20),
                                filled: true,
                                fillColor: const Color(0xFFFFFDF9),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: kPrimaryBhagwa, width: 1.5)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                            ),

                            const SizedBox(height: 14),

                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: nameController,
                                    style: const TextStyle(fontSize: 12, color: kTextColor),
                                    decoration: InputDecoration(
                                      labelText: "भक्त का नाम",
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
                                    controller: gotraController,
                                    style: const TextStyle(fontSize: 12, color: kTextColor),
                                    decoration: InputDecoration(
                                      labelText: "गोत्र (वैकल्पिक)",
                                      labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                                      prefixIcon: const Icon(Icons.temple_hindu_rounded, color: kPrimaryBhagwa, size: 18),
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

                            const SizedBox(height: 14),

                            const Text("दान संकल्प / उद्देश्य चुनें:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFDF9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFFFE0B2)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedSankalp,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: kPrimaryBhagwa),
                                  items: sankalpList.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: const TextStyle(fontSize: 12, color: kTextColor, fontWeight: FontWeight.w600)),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => selectedSankalp = val);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (selectedAmount < 11) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("कृपया कम से कम ₹11 का चढ़ावा चढ़ाएं!"), backgroundColor: Colors.redAccent),
                            );
                            return;
                          }
                          Navigator.pop(modalContext);
                          setState(() {
                            _totalChadavaAmount += selectedAmount;
                            _liveChat.insert(
                              0,
                              ChatMessage(
                                user: nameController.text.trim().isEmpty ? "आफ़ताब" : nameController.text.trim(),
                                message: "👑 ${temple.templeName} में ₹$selectedAmount का महा-दान अर्पित किया! (${selectedSankalp}) 🙏✨",
                                isVip: true,
                                amount: "₹$selectedAmount",
                              ),
                            );
                            for (int i = 0; i < 5; i++) {
                              _triggerFloatingElement("🪙");
                              _triggerFloatingElement("✨");
                            }
                          });
                        },
                        icon: const Icon(Icons.volunteer_activism_rounded, size: 18),
                        label: Text("₹$selectedAmount चढ़ावा अर्पित करें 🚩", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryBhagwa,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
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

  @override
  Widget build(BuildContext context) {
    final currentTemple = _templesList[_selectedTempleIndex];

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
          "24x7 दिव्य लाइव दर्शन 🕉️",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: kTextColor),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. LIVE VIDEO PLAYER CONTAINER WITH AARTI IMAGE & ROTATION
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1F0B02),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF5D2403)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C1304),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Center(
                            child: Icon(currentTemple.templeIcon, color: kGoldAccent, size: 75),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black.withAlpha(120), Colors.transparent, Colors.black.withAlpha(180)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),

                          // 🪔 आरती थाली (Safe Image Network with Fallback Icon)
                          if (_isAartiActive && _aartiController != null)
                            Center(
                              child: AnimatedBuilder(
                                animation: _aartiController!,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _aartiController!.value * 2 * pi,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.withAlpha(50),
                                        shape: BoxShape.circle,
                                        boxShadow: const [BoxShadow(color: Colors.amber, blurRadius: 40, spreadRadius: 10)],
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          "https://images.unsplash.com/photo-1544717305-2782549b5136?w=200&auto=format&fit=crop&q=80",
                                          width: 110,
                                          height: 110,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: 110,
                                            height: 110,
                                            decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 60),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                          ..._floatingElements.map((item) {
                            return Positioned(
                              bottom: 40 + (item.yOffset * 50),
                              left: item.startX,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 1400),
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, -value * 150),
                                    child: Opacity(
                                      opacity: 1.0 - value,
                                      child: Text(item.emoji, style: const TextStyle(fontSize: 32)),
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),

                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: Colors.red.shade700, borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.sensors_rounded, color: Colors.white, size: 12),
                                  SizedBox(width: 4),
                                  Text("LIVE", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xCC000000),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: kGoldAccent),
                              ),
                              child: Text(
                                "चढ़ावा: ₹$_totalChadavaAmount",
                                style: const TextStyle(color: kGoldAccent, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(currentTemple.deity, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                    Text("(${currentTemple.viewers} भक्त लाइव दर्शनरत)", style: const TextStyle(color: Colors.white70, fontSize: 9.5)),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.black.withAlpha(140), borderRadius: BorderRadius.circular(10)),
                                  child: Text("🔔 कुल घंटियाँ: $_bellsRung", style: const TextStyle(color: kGoldAccent, fontSize: 10.5, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(currentTemple.templeName, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text("${currentTemple.location} • ${currentTemple.liveStatus}", style: const TextStyle(color: kGoldAccent, fontSize: 11, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: const Color(0xFF2C1304), borderRadius: BorderRadius.circular(8)),
                          child: Text("मंत्र: ${currentTemple.mantra}", maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFFFFD54F), fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Text("ऑनलाइन पूजा एवं चढ़ावा अर्पण 🪔", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(child: _buildDevotionActionCard(icon: Icons.notifications_active_rounded, title: "घंटी बजाएं", count: "$_bellsRung बार", color: Colors.amber.shade800, onTap: _ringBell)),
                const SizedBox(width: 6),
                Expanded(child: _buildDevotionActionCard(icon: Icons.spa_rounded, title: "पुष्प चढ़ाएं", count: "$_flowersOffered पुष्प", color: Colors.pink, onTap: _offerFlower)),
                const SizedBox(width: 6),
                Expanded(child: _buildDevotionActionCard(icon: Icons.local_fire_department_rounded, title: "आरती करें", count: "$_diyaOffered दीप", color: kPrimaryBhagwa, onTap: _offerDiya)),
                const SizedBox(width: 6),
                Expanded(child: _buildDevotionActionCard(icon: Icons.monetization_on_rounded, title: "चढ़ावा चढ़ाएं", count: "₹51 - ₹5L", color: Colors.green.shade700, onTap: () => _openChadavaModal(currentTemple), isSpecial: true)),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("भक्त लाइव चैट एवं समर्पण (Live Stream)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.green.shade200)),
                  child: const Text("🟢 Live Chat On", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              height: 220,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.orange.shade100),
                boxShadow: kCardShadow,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: _liveChat.length,
                      itemBuilder: (context, index) {
                        final chat = _liveChat[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: chat.isVip ? const Color(0xFFFFF8E1) : const Color(0xFFFFFDF9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: chat.isVip ? kGoldAccent : Colors.orange.shade50,
                              width: chat.isVip ? 1.5 : 1,
                            ),
                            boxShadow: chat.isVip ? [const BoxShadow(color: Color(0x15FFD700), blurRadius: 6, offset: Offset(0, 2))] : [],
                          ),
                          child: Row(
                            children: [
                              if (chat.isVip)
                                Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [Color(0xFFFF8F00), Color(0xFFFFD700)]),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 10),
                                      const SizedBox(width: 2),
                                      Text("VIP ${chat.amount}", style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              Text("${chat.user}: ", style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: kTextColor)),
                              Expanded(
                                child: Text(
                                  chat.message,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: chat.isVip ? const Color(0xFF5D4037) : kSubTextColor,
                                    fontWeight: chat.isVip ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _chatController,
                          style: const TextStyle(fontSize: 12, color: kTextColor),
                          decoration: InputDecoration(
                            hintText: "अपनी भावना या हर हर महादेव लिखें...",
                            hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                            filled: true,
                            fillColor: const Color(0xFFFFFDF9),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                            focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: kPrimaryBhagwa, width: 1.5)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onSubmitted: (_) => _sendLiveMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 38,
                        child: ElevatedButton(
                          onPressed: _sendLiveMessage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryBhagwa,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            elevation: 2,
                          ),
                          child: const Icon(Icons.send_rounded, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF6ED),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFFCC80)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Color(0xFFFFF0E6), shape: BoxShape.circle),
                    child: const Icon(Icons.access_time_rounded, color: kPrimaryBhagwa, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("आगामी महा आरती समय:", style: TextStyle(fontSize: 10, color: kSubTextColor, fontWeight: FontWeight.w600)),
                        Text(currentTemple.nextAarti, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showFloatingSnack("आरती का रिमाइंडर सेट हो गया है! 🔔", kGoldAccent);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBhagwa,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      minimumSize: const Size(60, 30),
                    ),
                    child: const Text("रिमाइंडर", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text("अन्य प्रसिद्ध पावन धाम 🚩", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
            const SizedBox(height: 10),

            Column(
              children: _templesList.asMap().entries.map((entry) {
                final index = entry.key;
                final temple = entry.value;
                final isSelected = _selectedTempleIndex == index;

                return GestureDetector(
                  onTap: () => setState(() => _selectedTempleIndex = index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFFF6ED) : kCardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? kPrimaryBhagwa : const Color(0xFFFFE0B2),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: kCardShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(color: const Color(0xFFFFF0E6), borderRadius: BorderRadius.circular(12)),
                          child: Icon(temple.templeIcon, color: kPrimaryBhagwa, size: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                    decoration: BoxDecoration(color: Colors.red.shade700, borderRadius: BorderRadius.circular(4)),
                                    child: const Text("LIVE", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 6),
                                  Text("${temple.viewers} दर्शक", style: const TextStyle(fontSize: 10, color: kSubTextColor, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(temple.templeName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor)),
                              Text("${temple.deity} • ${temple.location}", maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: kSubTextColor)),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected ? Icons.radio_button_checked_rounded : Icons.play_circle_fill_rounded,
                          color: kPrimaryBhagwa,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDevotionActionCard({
    required IconData icon,
    required String title,
    required String count,
    required Color color,
    required VoidCallback onTap,
    bool isSpecial = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isSpecial ? const Color(0xFFFFF9F0) : kCardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSpecial ? Colors.green.shade400 : const Color(0xFFFFE0B2), width: isSpecial ? 1.5 : 1),
          boxShadow: kCardShadow,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: const BoxDecoration(color: Color(0xFFFFF0E6), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 5),
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kTextColor)),
            const SizedBox(height: 2),
            Text(count, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}