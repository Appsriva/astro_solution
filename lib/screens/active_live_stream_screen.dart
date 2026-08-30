import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// Brand Color Constants
const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);

class LiveComment {
  final String user;
  final String message;
  final String badge;
  final bool isVip;

  const LiveComment({
    required this.user,
    required this.message,
    this.badge = "",
    this.isVip = false,
  });
}

class FloatingHeart {
  final int id;
  final double startX;
  final String emoji;
  final Color color;

  FloatingHeart({
    required this.id,
    required this.startX,
    required this.emoji,
    required this.color,
  });
}

class LivePackage {
  final String title;
  final String duration;
  final int price;
  final String badge;

  const LivePackage({
    required this.title,
    required this.duration,
    required this.price,
    required this.badge,
  });
}

class ActiveLiveStreamScreen extends StatefulWidget {
  final String astrologerName;
  final String topic;
  final String viewers;

  const ActiveLiveStreamScreen({
    super.key,
    this.astrologerName = "पूनम शर्मा",
    this.topic = "लव लाइफ एवं शादी पर सीधा सवाल पूछें 💖",
    this.viewers = "1.4k",
  });

  @override
  State<ActiveLiveStreamScreen> createState() => _ActiveLiveStreamScreenState();
}

class _ActiveLiveStreamScreenState extends State<ActiveLiveStreamScreen>
    with TickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _equalizerController;
  late AnimationController _auraController;

  final List<FloatingHeart> _hearts = [];
  final Random _random = Random();
  int _heartCounter = 0;

  final int _userWalletBalance = 50;

  // 🎙️ Live Audio Call State
  bool _isLiveCallActive = false;
  int _liveCallSeconds = 0;
  Timer? _liveCallTimer;
  bool _isUserMicMuted = false;

  // 💬 Continuous Live VIP Chat State
  bool _isLiveChatActive = false;
  int _liveChatSeconds = 0;
  Timer? _liveChatTimer;
  String _activeChatPackageTitle = "";
  String _activeChatDurationText = "";

  static const List<LivePackage> _livePackages = [
    LivePackage(title: "₹50 पैक", duration: "10 मिनट लाइव बात/चैट", price: 50, badge: "STARTER"),
    LivePackage(title: "₹155 पैक", duration: "30 मिनट लाइव बात/चैट", price: 155, badge: "POPULAR 🔥"),
    LivePackage(title: "₹299 पैक", duration: "60 मिनट संपूर्ण समाधान", price: 299, badge: "BEST VALUE ✨"),
    LivePackage(title: "₹555 पैक", duration: "अनलिमिटेड लाइव बातचीत", price: 555, badge: "UNLIMITED 🔱"),
  ];

  final List<LiveComment> _comments = [
    const LiveComment(user: "राहुल शर्मा", message: "प्रणाम गुरु जी 🙏", badge: "VIP", isVip: false),
    const LiveComment(user: "Pooja Verma", message: "मेरी शादी कब तक होगी? 💖", badge: "", isVip: false),
    const LiveComment(user: "Amit Kumar", message: "सरकारी नौकरी के योग बताएं कृपया 💼", badge: "", isVip: false),
    const LiveComment(user: "Sneha Patel", message: "Jai Mata Di 🚩✨", badge: "Top Fan", isVip: false),
  ];

  Timer? _autoCommentTimer;
  bool _isFollowing = false;
  String? _activeGiftAnimation;

  @override
  void initState() {
    super.initState();

    _equalizerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _auraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _startSimulatedComments();
  }

  void _startSimulatedComments() {
    final simulated = [
      const LiveComment(user: "Vikram S.", message: "गुरु जी मेरा प्रमोशन कब होगा?", badge: "", isVip: false),
      const LiveComment(user: "Ritu Raj", message: "नमस्ते गुरु जी, आपकी सलाह बहुत काम आई 🙏", badge: "VIP", isVip: false),
      const LiveComment(user: "Karan", message: "Super live astrology session! 🌟", badge: "", isVip: false),
      const LiveComment(user: "Deepika", message: "उपाय बहुत प्रभावी हैं गुरु जी 🪔", badge: "Top Fan", isVip: false),
      const LiveComment(user: "Manoj Verma", message: "कुंडली में राहु दोष के उपाय बताएं", badge: "", isVip: false),
    ];
    int index = 0;

    _autoCommentTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _comments.add(simulated[index % simulated.length]);
        });
        index++;
        _scrollToBottom();
      }
    });
  }

  void _spawnHeart([TapDownDetails? details]) {
    final emojis = ["❤️", "✨", "🙏", "🪔", "🔱", "💖", "🌸"];
    final colors = [Colors.redAccent, Colors.pinkAccent, Colors.amber, Colors.orange];

    final double startX = details != null
        ? details.localPosition.dx
        : (MediaQuery.of(context).size.width * 0.75) + (_random.nextDouble() * 50 - 25);

    _heartCounter++;
    final heart = FloatingHeart(
      id: _heartCounter,
      startX: startX,
      emoji: emojis[_random.nextInt(emojis.length)],
      color: colors[_random.nextInt(colors.length)],
    );

    setState(() {
      _hearts.add(heart);
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        setState(() {
          _hearts.removeWhere((item) => item.id == heart.id);
        });
      }
    });
  }

  // 🌟 SENDING MESSAGE (CONTINUOUS DURING ACTIVE CHAT SESSION)
  void _sendLiveMessage() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    if (_isLiveChatActive) {
      setState(() {
        _comments.add(
          LiveComment(
            user: "आप (You)",
            message: text,
            badge: "VIP LIVE 🌟",
            isVip: true,
          ),
        );
      });

      _commentController.clear();
      _scrollToBottom();
      _spawnHeart();

      // Simulated Astrologer Response
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (mounted && _isLiveChatActive) {
          final replies = [
            "जी, मैंने आपका प्रश्न देखा है। आपकी कुंडली में ग्रह योग इसके अनुकूल बन रहे हैं।",
            "आपकी राशि अनुसार अगले 3 महीनों में सकारात्मक परिवर्तन दिख रहा है। कोई और संशय हो तो पूछें।",
            "इसके निवारण के लिए नित्य सूर्य देव को जल अर्पित करें और शनिवार को दीपक जलाएं।",
          ];
          final randomReply = replies[_random.nextInt(replies.length)];

          setState(() {
            _comments.add(
              LiveComment(
                user: widget.astrologerName,
                message: "@आप: $randomReply",
                badge: "गुरु जी 🚩",
                isVip: true,
              ),
            );
          });
          _scrollToBottom();
        }
      });
    } else {
      setState(() {
        _comments.add(LiveComment(user: "आप (You)", message: text, badge: "Member", isVip: false));
      });
      _commentController.clear();
      _scrollToBottom();
      _spawnHeart();
    }
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

  // 🌟 LIVE JOIN SELECTION SHEET (CALL VS CHAT)
  void _showLiveJoinSelectionSheet() {
    String selectedMode = "chat";
    int selectedPackIndex = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final activePack = _livePackages[selectedPackIndex];
            final bool hasEnoughBalance = _userWalletBalance >= activePack.price;

            return Container(
              height: MediaQuery.of(context).size.height * 0.76,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "लाइव जुड़ें (${widget.astrologerName}) 🚩",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E1500)),
                          ),
                          const Text(
                            "पूरे समय तक लगातार बात व चैट करें",
                            style: TextStyle(fontSize: 11, color: Colors.brown),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: kPrimaryBhagwa.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "वॉलेट: ₹$_userWalletBalance",
                          style: const TextStyle(color: kPrimaryBhagwa, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Mode Selection
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedMode = "chat";
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedMode == "chat" ? const Color(0xFFFFF3E0) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selectedMode == "chat" ? kPrimaryBhagwa : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.mark_chat_unread_rounded,
                                  color: selectedMode == "chat" ? kPrimaryBhagwa : Colors.grey.shade600,
                                  size: 22,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "लाइव VIP चैट (Continuous)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: selectedMode == "chat" ? kPrimaryBhagwa : Colors.grey.shade700,
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
                          onTap: () {
                            setModalState(() {
                              selectedMode = "call";
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedMode == "call" ? const Color(0xFFFFF3E0) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selectedMode == "call" ? kPrimaryBhagwa : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.phone_in_talk_rounded,
                                  color: selectedMode == "call" ? kPrimaryBhagwa : Colors.grey.shade600,
                                  size: 22,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "लाइव ऑडियो कॉल",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: selectedMode == "call" ? kPrimaryBhagwa : Colors.grey.shade700,
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
                  Text(
                    selectedMode == "chat"
                        ? "चैट समय सीमा (Chat Duration Package):"
                        : "कॉल समय सीमा (Call Duration Package):",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2E1500)),
                  ),
                  const SizedBox(height: 8),

                  // Packages List
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _livePackages.length,
                      itemBuilder: (context, index) {
                        final pkg = _livePackages[index];
                        final isSelected = selectedPackIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedPackIndex = index;
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
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2E1500)),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: kPrimaryBhagwa.withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              pkg.badge,
                                              style: const TextStyle(color: kPrimaryBhagwa, fontSize: 8, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        pkg.duration,
                                        style: const TextStyle(color: Color(0xFFE65100), fontSize: 11, fontWeight: FontWeight.w600),
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

                  // Confirm Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(modalContext);

                        if (!hasEnoughBalance) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("वॉलेट में पर्याप्त बैलेंस नहीं है, कृपया रिचार्ज करें!"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        if (selectedMode == "call") {
                          _startLiveCall(activePack.title);
                        } else {
                          _startLiveChatSession(activePack);
                        }
                      },
                      icon: Icon(
                        selectedMode == "call" ? Icons.phone_in_talk_rounded : Icons.chat_bubble_rounded,
                        size: 18,
                      ),
                      label: Text(
                        selectedMode == "call"
                            ? "${activePack.title} से अभी लाइव कॉल शुरू करें"
                            : "${activePack.title} से लाइव VIP चैट शुरू करें (${activePack.duration})",
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryBhagwa,
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

  // 🌟 START CONTINUOUS LIVE VIP CHAT SESSION
  void _startLiveChatSession(LivePackage pkg) {
    setState(() {
      _isLiveChatActive = true;
      _liveChatSeconds = 0;
      _activeChatPackageTitle = pkg.title;
      _activeChatDurationText = pkg.duration;
    });

    _liveChatTimer?.cancel();
    _liveChatTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _liveChatSeconds++;
        });
      }
    });

    _comments.add(
      LiveComment(
        user: "सिस्टम (System)",
        message: "🎉 आपका ${pkg.title} (${pkg.duration}) से लाइव VIP चैट सत्र शुरू हो गया है! अब आप लगातार सवाल पूछ सकते हैं।",
        badge: "VIP ACTIVE",
        isVip: true,
      ),
    );
    _scrollToBottom();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("लाइव VIP चैट सत्र सक्रिय हुआ (${pkg.title})! अब आप नीचे से लगातार चैट कर सकते हैं।"),
        backgroundColor: kPrimaryBhagwa,
      ),
    );
  }

  void _endLiveChatSession() {
    _liveChatTimer?.cancel();
    setState(() {
      _isLiveChatActive = false;
      _liveChatSeconds = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("लाइव VIP चैट सत्र समाप्त हुआ"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _startLiveCall(String packageName) {
    setState(() {
      _isLiveCallActive = true;
      _liveCallSeconds = 0;
    });

    _liveCallTimer?.cancel();
    _liveCallTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _liveCallSeconds++;
        });
      }
    });

    _comments.add(
      LiveComment(
        user: "सिस्टम (System)",
        message: "🎉 आप $packageName से गुरु जी के साथ लाइव कॉल पर जुड़ चुके हैं!",
        badge: "LIVE SPEAKER",
        isVip: false,
      ),
    );
    _scrollToBottom();
  }

  void _endLiveCall() {
    _liveCallTimer?.cancel();
    setState(() {
      _isLiveCallActive = false;
      _liveCallSeconds = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("लाइव कॉल समाप्त हुआ"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  String _formatTimer(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  void _showGiftSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "गुरु दक्षिणा एवं दिव्य गिफ्ट भेजें 🎁",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E1500)),
                  ),
                  Text("वॉलेट: ₹$_userWalletBalance", style: const TextStyle(color: kPrimaryBhagwa, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildGiftItem("फूल 🌸", "₹11", "🌸"),
                  _buildGiftItem("दीपक 🪔", "₹21", "🪔"),
                  _buildGiftItem("नारियल 🥥", "₹51", "🥥"),
                  _buildGiftItem("रुद्राक्ष 📿", "₹101", "📿"),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGiftItem(String name, String price, String emoji) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          _activeGiftAnimation = "$name भेजा गया!";
        });

        for (int i = 0; i < 5; i++) {
          Future.delayed(Duration(milliseconds: i * 150), () => _spawnHeart());
        }

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _activeGiftAnimation = null;
            });
          }
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F0),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 4),
            Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2E1500))),
            Text(price, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _liveCallTimer?.cancel();
    _liveChatTimer?.cancel();
    _equalizerController.dispose();
    _auraController.dispose();
    _autoCommentTimer?.cancel();
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _spawnHeart(details),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _auraController,
                builder: (context, child) {
                  final scale = 1.0 + (_auraController.value * 0.04);
                  return Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0, -0.2),
                        radius: 1.2 * scale,
                        colors: const [
                          Color(0xFF5C2607),
                          Color(0xFF2B0F02),
                          Color(0xFF0D0501),
                          Color(0xFF000000),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _auraController,
                        builder: (context, child) {
                          return Container(
                            width: 170 + (_auraController.value * 20),
                            height: 170 + (_auraController.value * 20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryBhagwa.withValues(alpha: 0.15 - (_auraController.value * 0.08)),
                            ),
                          );
                        },
                      ),
                      Container(
                        width: 145,
                        height: 145,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [kPrimaryBhagwa, kGoldAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryBhagwa.withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(3),
                        child: ClipOval(
                          child: Container(
                            color: const Color(0xFFFFF0E6),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 90,
                              color: kPrimaryBhagwa,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: kGoldAccent, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildEqualizerBar(0.8),
                              const SizedBox(width: 2),
                              _buildEqualizerBar(1.2),
                              const SizedBox(width: 2),
                              _buildEqualizerBar(0.5),
                              const SizedBox(width: 5),
                              const Text(
                                "लाइव बोल रहे हैं 🎙️",
                                style: TextStyle(color: kGoldAccent, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    widget.astrologerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      widget.topic,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 15,
                            backgroundColor: Color(0xFFFFF3E0),
                            child: Icon(Icons.person_rounded, size: 20, color: kPrimaryBhagwa),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.astrologerName,
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.remove_red_eye_rounded, size: 10, color: Colors.white70),
                                  const SizedBox(width: 3),
                                  Text(
                                    "${widget.viewers} लाइव",
                                    style: const TextStyle(color: Colors.white70, fontSize: 9),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isFollowing = !_isFollowing;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _isFollowing ? Colors.white24 : kPrimaryBhagwa,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                _isFollowing ? "फॉलो किया" : "+ फॉलो",
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.fiber_manual_record_rounded, color: Colors.white, size: 10),
                          SizedBox(width: 3),
                          Text("LIVE", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 26),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),

            // 🌟 FLOATING CO-HOST AUDIO CALL OVERLAY
            if (_isLiveCallActive)
              Positioned(
                top: 75,
                right: 14,
                child: Container(
                  width: 140,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.greenAccent, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent.withValues(alpha: 0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text("LIVE 🎙️", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                          Text(
                            _formatTimer(_liveCallSeconds),
                            style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFFFFECE0),
                        child: Icon(Icons.person_rounded, color: kPrimaryBhagwa, size: 30),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "आप (You)",
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isUserMicMuted = !_isUserMicMuted;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: _isUserMicMuted ? Colors.red : Colors.white24,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isUserMicMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _endLiveCall,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.call_end_rounded, size: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // 🌟 CONTINUOUS LIVE VIP CHAT STATUS DOCK
            if (_isLiveChatActive)
              Positioned(
                top: 75,
                left: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kPrimaryBhagwa, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryBhagwa.withValues(alpha: 0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.stars_rounded, color: kPrimaryBhagwa, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "VIP लाइव चैट सत्र चालू है ($_activeChatPackageTitle)",
                              style: const TextStyle(
                                color: Color(0xFF2E1500),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "सक्रिय समय: ${_formatTimer(_liveChatSeconds)} • लगातार सवाल पूछें",
                              style: const TextStyle(color: Color(0xFFE65100), fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _endLiveChatSession,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "समाप्त",
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ..._hearts.map((heart) => _buildAnimatedFloatingHeart(heart)),

            if (_activeGiftAnimation != null)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [kPrimaryBhagwa, kDeepSaffron]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: kPrimaryBhagwa.withValues(alpha: 0.5), blurRadius: 14),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _activeGiftAnimation!,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

            // 🌟 LIVE COMMENTS STREAM (100% NULL SAFE)
            Positioned(
              left: 12,
              right: 12,
              bottom: 80,
              child: SizedBox(
                height: 190,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final comment = _comments[index];
                    final bool isVipComment = comment.isVip == true;

                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isVipComment
                              ? const Color(0xFFFFF3E0).withValues(alpha: 0.95)
                              : Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isVipComment ? kPrimaryBhagwa : Colors.white12,
                            width: isVipComment ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (comment.badge.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: isVipComment ? kPrimaryBhagwa : Colors.black45,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  comment.badge,
                                  style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 5),
                            ],
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${comment.user}: ",
                                      style: TextStyle(
                                        color: isVipComment ? const Color(0xFF2E1500) : kGoldAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: comment.message,
                                      style: TextStyle(
                                        color: isVipComment ? const Color(0xFF2E1500) : Colors.white,
                                        fontSize: 12,
                                        fontWeight: isVipComment ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 🌟 BOTTOM ACTION BAR
            Positioned(
              left: 12,
              right: 12,
              bottom: 14,
              child: SafeArea(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (_isLiveChatActive || _isLiveCallActive)
                          ? null
                          : _showLiveJoinSelectionSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: (_isLiveChatActive || _isLiveCallActive)
                                ? [Colors.green.shade700, Colors.green.shade900]
                                : [const Color(0xFFE65100), const Color(0xFFBF360C)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kGoldAccent.withValues(alpha: 0.8)),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryBhagwa.withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              (_isLiveChatActive || _isLiveCallActive) ? Icons.check_circle_rounded : Icons.stars_rounded,
                              color: kGoldAccent,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _isLiveChatActive
                                  ? "VIP चैट सक्रिय"
                                  : (_isLiveCallActive ? "कॉल सक्रिय" : "लाइव जुड़ें"),
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    Expanded(
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: _isLiveChatActive
                              ? const Color(0xFFFFF3E0).withValues(alpha: 0.95)
                              : Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _isLiveChatActive ? kPrimaryBhagwa : Colors.white24,
                            width: _isLiveChatActive ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                style: TextStyle(
                                  color: _isLiveChatActive ? const Color(0xFF2E1500) : Colors.white,
                                  fontSize: 12,
                                  fontWeight: _isLiveChatActive ? FontWeight.w600 : FontWeight.normal,
                                ),
                                decoration: InputDecoration(
                                  hintText: _isLiveChatActive
                                      ? "VIP सवाल लिखें (लाइव उत्तर पाएं)..."
                                      : "गुरु जी से सवाल पूछें...",
                                  hintStyle: TextStyle(
                                    color: _isLiveChatActive ? Colors.brown.shade400 : Colors.white54,
                                    fontSize: 11,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                onSubmitted: (_) => _sendLiveMessage(),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send_rounded, color: kPrimaryBhagwa, size: 18),
                              onPressed: _sendLiveMessage,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    GestureDetector(
                      onTap: _showGiftSheet,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [kPrimaryBhagwa, kDeepSaffron],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryBhagwa.withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                    const SizedBox(width: 8),

                    GestureDetector(
                      onTap: () => _spawnHeart(),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                        ),
                        child: const Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEqualizerBar(double factor) {
    return AnimatedBuilder(
      animation: _equalizerController,
      builder: (context, child) {
        final height = (6 + (_equalizerController.value * 8 * factor)).clamp(4.0, 14.0);
        return Container(
          width: 3,
          height: height,
          decoration: BoxDecoration(
            color: kGoldAccent,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedFloatingHeart(FloatingHeart heart) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(heart.id),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        final double bottom = 80 + (value * 350);
        final double opacity = (1.0 - value).clamp(0.0, 1.0);
        final double horizontalWobble = sin(value * pi * 4) * 20;

        return Positioned(
          bottom: bottom,
          left: (heart.startX + horizontalWobble).clamp(20.0, MediaQuery.of(context).size.width - 40),
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: 0.8 + (value * 0.5),
              child: Text(
                heart.emoji,
                style: TextStyle(fontSize: 24, color: heart.color),
              ),
            ),
          ),
        );
      },
    );
  }
}