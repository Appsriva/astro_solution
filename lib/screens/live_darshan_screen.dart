import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui_web' as ui_web;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

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
  final List<String> mantras;
  final String streamUrl;
  final String imageUrl;
  final bool isActive;

  const TempleDarshanItem({
    required this.id,
    required this.templeName,
    required this.deity,
    required this.location,
    required this.viewers,
    required this.nextAarti,
    required this.templeIcon,
    required this.liveStatus,
    required this.mantras,
    this.streamUrl = "",
    this.imageUrl = "",
    this.isActive = true,
  });
}

class LiveDarshanScreen extends StatefulWidget {
  const LiveDarshanScreen({super.key});

  @override
  State<LiveDarshanScreen> createState() => _LiveDarshanScreenState();
}

class _LiveDarshanScreenState extends State<LiveDarshanScreen> with TickerProviderStateMixin {
  int _selectedTempleIndex = 0;
  int _flowersOffered = 108;
  int _bellsRung = 51;
  int _diyaOffered = 21;
  int _totalChadavaAmount = 15100;
  
  bool _isAartiActive = false;
  AnimationController? _aartiController;

  late AnimationController _masterBellController;
  late AnimationController _liveBlinkController;
  Timer? _mantraTimer;
  int _currentMantraIndex = 0;

  final List<FloatingItem> _floatingElements = [];
  int _counter = 0;

  final TextEditingController _chatController = TextEditingController();

  List<TempleDarshanItem> _dynamicTemplesList = [];
  bool _isLoadingTemples = true;

  String _activeAartiDisplay = "संध्या आरती (07:00 PM)";
  bool _isGlobalChatActive = true;
  RealtimeChannel? _settingsSubscription;

  bool _showChadavaPopup = false;
  String _popupDonorName = "";
  int _popupDonorAmount = 0;
  final String _popupUserAvatar = "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80";

  final List<ChatMessage> _liveChat = [
    ChatMessage(user: "राहुल शर्मा", message: "जय महाकाल! 🙏", isVip: true, amount: "₹251"),
    ChatMessage(user: "प्रिया सिंह", message: "हर हर महादेव 🔱 हर घर शंभू"),
    ChatMessage(user: "अमित कुमार", message: "दर्शन पाकर जीवन धन्य हो गया 🚩", isVip: true, amount: "₹501"),
    ChatMessage(user: "सुनीता गुप्ता", message: "जय बांके बिहारी लाल की 🌸"),
  ];

  static const List<TempleDarshanItem> _fallbackTemplesList = [
    TempleDarshanItem(
      id: "tmp_1",
      templeName: "श्री महाकालेश्वर ज्योतिर्लिंग",
      deity: "भगवान शिव (महाकाल)",
      location: "उज्जैन, मध्य प्रदेश",
      viewers: "14.8k",
      nextAarti: "संध्या आरती (07:00 PM)",
      templeIcon: Icons.temple_hindu_rounded,
      liveStatus: "भस्म आरती व श्रृंगार लाइव",
      mantras: ["ॐ नमः शिवाय", "ॐ महाकालेश्वराय नमः", "हर हर महादेव", "त्र्यम्बकं यजामहे", "ॐ शिवाय नमः"],
      streamUrl: "https://www.youtube.com/embed/WPZ0xL0-sKs",
      imageUrl: "https://images.unsplash.com/photo-1544717305-2782549b5136?w=300&auto=format&fit=crop&q=80",
      isActive: true,
    ),
  ];

  static const List<int> _quickChadavaAmounts = [
    51, 101, 201, 301, 501, 1001, 2100, 5100, 11000, 21000, 51000, 100001,
  ];

  @override
  void initState() {
    super.initState();
    // 🌟 आरती की थाली घूमने की स्पीड एकदम सही (2 सेकंड में एक परिक्रमा) कर दी गई है
    _aartiController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _masterBellController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _liveBlinkController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this)..repeat(reverse: true);

    _mantraTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentMantraIndex++;
        });
      }
    });

    if (kIsWeb) {
      try {
        // ignore: undefined_prefixed_name
        ui_web.platformViewRegistry.registerViewFactory(
          'tmp_1',
          (int viewId) {
            final html.DivElement div = html.DivElement()..style.width = '100%'..style.height = '100%';
            final html.IFrameElement iframe = html.IFrameElement()
              ..src = "https://www.youtube.com/embed/WPZ0xL0-sKs?autoplay=1&mute=0&controls=1&enablejsapi=1&playsinline=1"
              ..style.border = 'none'
              ..style.width = '100%'
              ..style.height = '100%'
              ..setAttribute('allow', 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture');
            div.append(iframe);
            return div;
          },
        );
      } catch (_) {}
    }

    _fetchAdminMandirs();
    _fetchAartiSchedules();
    _fetchChatStatusAndListen();
  }

  Future<void> _fetchAdminMandirs() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.from('mandir_livestreams').select().order('created_at', ascending: false);

      if (response.isNotEmpty && mounted) {
        final List<TempleDarshanItem> loadedTemples = response.map<TempleDarshanItem>((item) {
          String rawUrl = item['stream_url']?.toString() ?? '';
          bool activeStatus = item['is_active'] ?? true;
          
          rawUrl = rawUrl.replaceAll(RegExp(r'^[^h]*https'), 'https');
          if (rawUrl.contains('https://https://')) {
            rawUrl = rawUrl.replaceFirst('https://https://', 'https://');
          }

          if (rawUrl.contains('watch?v=')) {
            final videoId = rawUrl.split('watch?v=').last.split('&').first.split('?').first;
            rawUrl = 'https://www.youtube.com/embed/$videoId?autoplay=1&mute=0&controls=1&enablejsapi=1&playsinline=1';
          } else if (rawUrl.contains('youtu.be/')) {
            final videoId = rawUrl.split('youtu.be/').last.split('?').first.split('&').first;
            rawUrl = 'https://www.youtube.com/embed/$videoId?autoplay=1&mute=0&controls=1&enablejsapi=1&playsinline=1';
          } else if (rawUrl.contains('embed/')) {
            final videoId = rawUrl.split('embed/').last.split('?').first.split('&').first;
            rawUrl = 'https://www.youtube.com/embed/$videoId?autoplay=1&mute=0&controls=1&enablejsapi=1&playsinline=1';
          } else if (rawUrl.isEmpty) {
            rawUrl = 'https://www.youtube.com/embed/WPZ0xL0-sKs?autoplay=1&mute=0&controls=1&enablejsapi=1&playsinline=1';
          }

          final String rawDbId = item['id']?.toString() ?? 'tmp_1';
          final String stableViewId = 'iframe-view-$rawDbId';

          List<String> loadedMantras = [
            item['mantra_1']?.toString() ?? 'ॐ नमः शिवाय',
            item['mantra_2']?.toString() ?? 'हर हर महादेव',
            item['mantra_3']?.toString() ?? 'ॐ नमो भगवते वासुदेवाय',
            item['mantra_4']?.toString() ?? 'जय बांके बिहारी',
            item['mantra_5']?.toString() ?? 'जय श्री राम',
          ];

          if (kIsWeb && rawUrl.isNotEmpty && activeStatus) {
            try {
              // ignore: undefined_prefixed_name
              ui_web.platformViewRegistry.registerViewFactory(
                stableViewId,
                (int viewId) {
                  final html.DivElement div = html.DivElement()..style.width = '100%'..style.height = '100%';
                  final html.IFrameElement iframe = html.IFrameElement()
                    ..src = rawUrl
                    ..style.border = 'none'
                    ..style.width = '100%'
                    ..style.height = '100%'
                    ..setAttribute('allow', 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture');
                  div.append(iframe);
                  return div;
                },
              );
            } catch (_) {}
          }

          return TempleDarshanItem(
            id: rawDbId,
            templeName: item['temple_name']?.toString() ?? 'दिव्य मंदिर',
            deity: 'मुख्य अर्चनीय विग्रह',
            location: item['city']?.toString() ?? 'भारत',
            viewers: '12.5k',
            nextAarti: _activeAartiDisplay,
            templeIcon: Icons.temple_hindu_rounded,
            liveStatus: activeStatus ? '24x7 सीधा प्रसारण लाइव' : 'दर्शन संपन्न हुए',
            mantras: loadedMantras,
            streamUrl: rawUrl,
            imageUrl: item['image_url']?.toString() ?? 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=300&auto=format&fit=crop&q=80',
            isActive: activeStatus,
          );
        }).toList();

        if (!mounted) return;
        setState(() {
          _dynamicTemplesList = loadedTemples;
          _isLoadingTemples = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _isLoadingTemples = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingTemples = false;
        });
      }
    }
  }

  Future<void> _fetchAartiSchedules() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.from('aarti_schedules').select().order('created_at', ascending: false).limit(1);

      if (response.isNotEmpty && mounted) {
        final aarti = response.first;
        final name = aarti['aarti_name']?.toString() ?? 'महा आरती';
        final time = aarti['aarti_time']?.toString() ?? '07:00 PM';
        setState(() {
          _activeAartiDisplay = "$name ($time)";
        });
      }
    } catch (_) {}
  }

  Future<void> _fetchChatStatusAndListen() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.from('app_settings').select('*').eq('key', 'chat_enabled').maybeSingle();
      
      if (response != null && mounted) {
        final val = response['value'];
        setState(() {
          _isGlobalChatActive = val == 'true' || val == true;
        });
      }

      _settingsSubscription = supabase
        .channel('public:app_settings')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'app_settings',
          callback: (payload) {
            final newRec = payload.newRecord;
            if (newRec['key'] == 'chat_enabled') {
              final val = newRec['value'];
              if (mounted) {
                setState(() {
                  _isGlobalChatActive = val == 'true' || val == true;
                });
              }
            }
          },
        )
        .subscribe();
    } catch (_) {}
  }

  @override
  void dispose() {
    _aartiController?.dispose();
    _masterBellController.dispose();
    _liveBlinkController.dispose();
    _mantraTimer?.cancel();
    _chatController.dispose();
    if (_settingsSubscription != null) {
      Supabase.instance.client.removeChannel(_settingsSubscription!);
    }
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

    _masterBellController.repeat(reverse: true);
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _masterBellController.stop();
        _masterBellController.reset();
      }
    });
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

  void _sendLiveMessage() async {
    if (!_isGlobalChatActive) {
      _showFloatingSnack("🔴 एडमिन द्वारा लाइव चैट बंद कर दी गई है!", Colors.redAccent);
      return;
    }

    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    final activeTemplesList = _dynamicTemplesList.isNotEmpty ? _dynamicTemplesList : _fallbackTemplesList;
    if (_selectedTempleIndex >= activeTemplesList.length) _selectedTempleIndex = 0;
    final currentTemple = activeTemplesList[_selectedTempleIndex];

    setState(() {
      _liveChat.insert(0, ChatMessage(user: "आफ़ताब", message: text));
      _chatController.clear();
    });

    try {
      final supabase = Supabase.instance.client;
      await supabase.from('live_chat_messages').insert({
        'user_name': 'आफ़ताब',
        'message': text,
        'is_vip': false,
        'amount': '',
        'mandir_id': currentTemple.id.startsWith('tmp_') ? null : currentTemple.id,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint("Supabase Chat Sync Error: $e");
    }

    if (!mounted) return;
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

  void _triggerChadavaSuccessPopup(String donorName, int amount) {
    setState(() {
      _popupDonorName = donorName;
      _popupDonorAmount = amount;
      _showChadavaPopup = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showChadavaPopup = false;
        });
      }
    });
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
                        onPressed: () async {
                          if (selectedAmount < 11) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("कृपया कम से कम ₹11 का चढ़ावा चढ़ाएं!"), backgroundColor: Colors.redAccent),
                            );
                            return;
                          }
                          final donor = nameController.text.trim().isEmpty ? "आफ़ताब" : nameController.text.trim();
                          Navigator.pop(modalContext);

                          try {
                            final supabase = Supabase.instance.client;
                            await supabase.from('chadava_payments').insert({
                              'donor_name': donor,
                              'amount': selectedAmount,
                              'payment_method': 'UPI / Online',
                              'sankalp': selectedSankalp,
                              'created_at': DateTime.now().toIso8601String(),
                            });
                          } catch (_) {}

                          setState(() {
                            _totalChadavaAmount += selectedAmount;
                            _liveChat.insert(
                              0,
                              ChatMessage(
                                user: donor,
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

                          _triggerChadavaSuccessPopup(donor, selectedAmount);
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
    final activeTemplesList = _dynamicTemplesList.isNotEmpty ? _dynamicTemplesList : _fallbackTemplesList;
    if (_selectedTempleIndex >= activeTemplesList.length) {
      _selectedTempleIndex = 0;
    }
    final currentTemple = activeTemplesList[_selectedTempleIndex];
    final currentMantra = currentTemple.mantras.isNotEmpty
        ? currentTemple.mantras[_currentMantraIndex % currentTemple.mantras.length]
        : "ॐ नमः शिवाय";

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
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. LIVE VIDEO PLAYER CONTAINER
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
                              if (currentTemple.isActive && currentTemple.streamUrl.isNotEmpty)
                                kIsWeb
                                    ? Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          HtmlElementView(
                                            viewType: 'iframe-view-${currentTemple.id}',
                                          ),
                                          AbsorbPointer(
                                            child: Container(color: Colors.transparent),
                                          ),
                                        ],
                                      )
                                    : Center(child: Icon(currentTemple.templeIcon, color: kGoldAccent, size: 75))
                              else
                                Container(
                                  color: const Color(0xFF1F0B02),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.nightlight_round, color: kGoldAccent, size: 48),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "आज के लाइव दर्शन संपन्न हुए 🙏",
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
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

                              // 🌟 आरती की थाली अब आपके बताए गए पूरे एरिया में सही स्पीड और सीधी पोजीशन में घूम रही है
                              if (_isAartiActive && _aartiController != null)
                                Center(
                                  child: AnimatedBuilder(
                                    animation: _aartiController!,
                                    builder: (context, child) {
                                      final double value = _aartiController!.value * 2 * pi;
                                      final double radiusX = 120.0;
                                      final double radiusY = 45.0;
                                      final double offsetX = cos(value) * radiusX;
                                      final double offsetY = sin(value) * radiusY;

                                      return Transform.translate(
                                        offset: Offset(offsetX, offsetY),
                                        child: Container(
                                          width: 85,
                                          height: 85,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(color: Colors.amberAccent, blurRadius: 25, spreadRadius: 6),
                                            ],
                                          ),
                                          child: ClipOval(
                                            child: Image.asset(
                                              'assets/images/aarti.png',
                                              fit: BoxFit.contain,
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

                              // 🌟 ब्लिंकिंग (Blinking) लाइव बटन
                              Positioned(
                                top: 10,
                                left: 10,
                                child: FadeTransition(
                                  opacity: _liveBlinkController,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade700,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [BoxShadow(color: Colors.red.withAlpha(150), blurRadius: 8, spreadRadius: 2)],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.sensors_rounded, color: Colors.white, size: 12),
                                        const SizedBox(width: 4),
                                        const Text("LIVE", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Left Bell
                              Positioned(
                                top: 0,
                                left: 12,
                                child: GestureDetector(
                                  onTap: _ringBell,
                                  child: AnimatedBuilder(
                                    animation: _masterBellController,
                                    builder: (context, child) {
                                      final angle = sin(_masterBellController.value * 2 * pi * 3.5) * 0.10;
                                      return Transform(
                                        alignment: Alignment.topCenter,
                                        transform: Matrix4.rotationZ(angle),
                                        child: SizedBox(
                                          width: 70,
                                          height: 170,
                                          child: Image.asset('assets/images/temple_bell.png', fit: BoxFit.contain),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Right Bell
                              Positioned(
                                top: 0,
                                right: 12,
                                child: GestureDetector(
                                  onTap: _ringBell,
                                  child: AnimatedBuilder(
                                    animation: _masterBellController,
                                    builder: (context, child) {
                                      final angle = sin(_masterBellController.value * 2 * pi * 3.5) * 0.10;
                                      return Transform(
                                        alignment: Alignment.topCenter,
                                        transform: Matrix4.rotationZ(angle),
                                        child: SizedBox(
                                          width: 70,
                                          height: 170,
                                          child: Image.asset('assets/images/temple_bell.png', fit: BoxFit.contain),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 🌟 मंदिर का नाम और 5 मंत्रों का स्लाइडर
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
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFF2C1304), borderRadius: BorderRadius.circular(8)),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: Text(
                                  "✨ मंत्र: $currentMantra",
                                  key: ValueKey<String>(currentMantra),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Color(0xFFFFD54F), fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
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
                    Expanded(child: _buildDevotionActionCard(icon: Icons.notifications_active_rounded, title: "घंटी बजाएं", count: "घंटी बजाएं", color: Colors.amber.shade800, onTap: _ringBell)),
                    const SizedBox(width: 6),
                    Expanded(child: _buildDevotionActionCard(icon: Icons.spa_rounded, title: "पुष्प चढ़ाएं", count: "पुष्प वर्षा", color: Colors.pink, onTap: _offerFlower)),
                    const SizedBox(width: 6),
                    Expanded(child: _buildDevotionActionCard(icon: Icons.local_fire_department_rounded, title: "आरती करें", count: "दीप प्रज्वलन", color: kPrimaryBhagwa, onTap: _offerDiya)),
                    const SizedBox(width: 6),
                    Expanded(child: _buildDevotionActionCard(icon: Icons.monetization_on_rounded, title: "चढ़ावा", count: "महा-दान", color: Colors.green.shade700, onTap: () => _openChadavaModal(currentTemple), isSpecial: true)),
                  ],
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("भक्त लाइव चैट एवं समर्पण (Live Stream)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _isGlobalChatActive ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _isGlobalChatActive ? Colors.green.shade200 : Colors.red.shade200)
                      ),
                      child: Text(
                        _isGlobalChatActive ? "🟢 Live Chat On" : "🔴 Live Chat Closed",
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _isGlobalChatActive ? Colors.green : Colors.red)
                      ),
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
                                border: Border.all(color: chat.isVip ? kGoldAccent : Colors.orange.shade50, width: chat.isVip ? 1.5 : 1),
                              ),
                              child: Row(
                                children: [
                                  Text("${chat.user}: ", style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: kTextColor)),
                                  Expanded(child: Text(chat.message, style: const TextStyle(fontSize: 11.5, color: kSubTextColor))),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 6),
                      _isGlobalChatActive
                          ? Row(
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
                                    style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBhagwa, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                    child: const Icon(Icons.send_rounded, size: 16),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
                              child: const Text("🔴 लाइव चैट वर्तमान में बंद है", textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.red)),
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
                            Text(_activeAartiDisplay, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showFloatingSnack("🔔 आरती रिमाइंडर सेट हो गया!", kGoldAccent);
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

                // 🌟 अन्य प्रसिद्ध पावन धाम की सूची (असली इमेज के साथ)
                const Text("अन्य प्रसिद्ध पावन धाम 🚩", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
                const SizedBox(height: 10),

                Column(
                  children: activeTemplesList.asMap().entries.map((entry) {
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
                          border: Border.all(color: isSelected ? kPrimaryBhagwa : const Color(0xFFFFE0B2), width: isSelected ? 1.5 : 1),
                          boxShadow: kCardShadow,
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                temple.imageUrl.isNotEmpty ? temple.imageUrl : 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=200',
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                              ),
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
                                        decoration: BoxDecoration(color: temple.isActive ? Colors.red.shade700 : Colors.grey, borderRadius: BorderRadius.circular(4)),
                                        child: Text(temple.isActive ? "LIVE" : "OFF", style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(width: 6),
                                      Text("${temple.viewers} दर्शक", style: const TextStyle(fontSize: 10, color: kSubTextColor, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(temple.templeName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor)),
                                  Text("${temple.location}", maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: kSubTextColor)),
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

          if (_showChadavaPopup)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(160),
                child: Center(
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: kGoldAccent, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("🌸 महा-दान समर्पण 🌸", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
                        const SizedBox(height: 14),
                        CircleAvatar(radius: 35, backgroundImage: NetworkImage(_popupUserAvatar)),
                        const SizedBox(height: 12),
                        Text(_popupDonorName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: kTextColor)),
                        const SizedBox(height: 4),
                        Text("₹$_popupDonorAmount अर्पित किया", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF8D6E63))),
                        const SizedBox(height: 12),
                        const Text("भगवान आपकी मनोकामना पूर्ण करें। धन्यवाद! 🙏✨", textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, color: kSubTextColor, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDevotionActionCard({required IconData icon, required String title, required String count, required Color color, required VoidCallback onTap, bool isSpecial = false}) {
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