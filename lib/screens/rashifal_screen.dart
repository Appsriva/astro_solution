import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF6D4C41);

const List<BoxShadow> kSmoothShadow = [
  BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 10,
    offset: Offset(0, 4),
  ),
];

class RashifalScreen extends StatefulWidget {
  const RashifalScreen({super.key});

  @override
  State<RashifalScreen> createState() => _RashifalScreenState();
}

class _RashifalScreenState extends State<RashifalScreen> {
  int _selectedZodiacIndex = 0;
  int _timeframeIndex = 0; // 0: दैनिक (Daily), 1: साप्ताहिक (Weekly), 2: वार्षिक (Yearly)
  bool _isPlayingAudio = false;

  bool _isLoading = true;
  String? _fetchedRecordId; // 🆔 लाइव रिकॉर्ड आईडी (Views & Likes अपडेट करने के लिए)
  String _fetchedPrediction = "";
  String _fetchedCareer = "";
  String _fetchedFamily = "";
  String _fetchedHealth = "";
  String _fetchedLuckyNumber = "7";
  String _fetchedLuckyColor = "लाल (Red)";
  String _fetchedDateRange = ""; // 📅 एडमिन द्वारा डाली गई डेट-रेंज
  
  // 💙 लाइक और व्यू स्टेट वेरिएबल्स
  bool _isLiked = false;
  int _likesCount = 0;

  // 🎵 ऑडियो प्लेयर वेरिएबल्स
  late final AudioPlayer _audioPlayer;
  String? _fetchedAudioUrl;
  StreamSubscription? _audioCompleteSubscription;

  final List<Map<String, String>> _zodiacSigns = const [
    {"name": "मेष", "en": "Aries", "key": "Aries", "date": "Mar 21 - Apr 19", "icon": "♈"},
    {"name": "वृषभ", "en": "Taurus", "key": "Taurus", "date": "Apr 20 - May 20", "icon": "♉"},
    {"name": "मिथुन", "en": "Gemini", "key": "Gemini", "date": "May 21 - Jun 20", "icon": "♊"},
    {"name": "कर्क", "en": "Cancer", "key": "Cancer", "date": "Jun 21 - Jul 22", "icon": "♋"},
    {"name": "सिंह", "en": "Leo", "key": "Leo", "date": "Jul 23 - Aug 22", "icon": "♌"},
    {"name": "कन्या", "en": "Virgo", "key": "Virgo", "date": "Aug 23 - Sep 22", "icon": "♍"},
    {"name": "तुला", "en": "Libra", "key": "Libra", "date": "Sep 23 - Oct 22", "icon": "♎"},
    {"name": "वृश्चिक", "en": "Scorpio", "key": "Scorpio", "date": "Oct 23 - Nov 21", "icon": "♏"},
    {"name": "धनु", "en": "Sagittarius", "key": "Sagittarius", "date": "Nov 22 - Dec 21", "icon": "♐"},
    {"name": "मकर", "en": "Capricorn", "key": "Capricorn", "date": "Dec 22 - Jan 19", "icon": "♑"},
    {"name": "कुंभ", "en": "Aquarius", "key": "Aquarius", "date": "Jan 20 - Feb 18", "icon": "♒"},
    {"name": "मीन", "en": "Pisces", "key": "Pisces", "date": "Feb 19 - Mar 20", "icon": "♓"},
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    
    // मेमोरी लीक रोकने के लिए ऑडियो कंप्लीशन लिसनर कोफिशिएंटली असाइन करें
    _audioCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlayingAudio = false);
    });

    _fetchLiveRashifalFromSupabase();
  }

  @override
  void dispose() {
    _audioCompleteSubscription?.cancel(); // सब्सक्रिप्शन कैंसिल करना जरूरी है (मेमोरी लीक प्रिवेंशन)
    _audioPlayer.dispose();
    super.dispose();
  }

  // 👁️ व्यूज काउंट और यूजर ट्रैकिंग Supabase में जोड़ने के लिए (Safe & Non-blocking)
  Future<void> _recordViewAndLikeStatus(String recordId, List? viewedUsers, List? likedUsers) async {
    try {
      final userPhone = Supabase.instance.client.auth.currentUser?.id ?? "guest_user";
      
      List updatedViews = viewedUsers != null ? List.from(viewedUsers) : [];
      if (!updatedViews.contains(userPhone)) {
        updatedViews.add(userPhone);
        await Supabase.instance.client
            .from('rashifal')
            .update({
              'views_count': updatedViews.length,
              'viewed_users': updatedViews,
            })
            .eq('id', recordId);
      }

      if (mounted) {
        setState(() {
          _isLiked = likedUsers != null && likedUsers.contains(userPhone);
          _likesCount = likedUsers?.length ?? 0;
        });
      }
    } catch (e) {
      debugPrint("View Record Error: $e");
    }
  }

  // 💙 लाइक टॉगल करने का सुरक्षित फंक्शन
  Future<void> _toggleLike() async {
    if (_fetchedRecordId == null) return;

    try {
      final userPhone = Supabase.instance.client.auth.currentUser?.id ?? "guest_user";
      
      final res = await Supabase.instance.client
          .from('rashifal')
          .select('liked_users')
          .eq('id', _fetchedRecordId!)
          .maybeSingle();

      List currentLikedUsers = res?['liked_users'] != null ? List.from(res!['liked_users']) : [];

      if (_isLiked) {
        currentLikedUsers.remove(userPhone);
      } else {
        if (!currentLikedUsers.contains(userPhone)) {
          currentLikedUsers.add(userPhone);
        }
      }

      await Supabase.instance.client
          .from('rashifal')
          .update({'liked_users': currentLikedUsers})
          .eq('id', _fetchedRecordId!);

      if (mounted) {
        setState(() {
          _isLiked = !_isLiked;
          _likesCount = currentLikedUsers.length;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isLiked ? "❤️ राशिफल पसंद किया गया!" : "🤍 लाइक हटाया गया"),
            duration: const Duration(milliseconds: 900),
            backgroundColor: kPrimaryBhagwa,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint("Like Error: $e");
    }
  }

  Future<void> _fetchLiveRashifalFromSupabase() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    await _audioPlayer.stop();
    if (mounted) setState(() => _isPlayingAudio = false);

    try {
      final currentSignKey = _zodiacSigns[_selectedZodiacIndex]["key"]!;
      final currentSignName = _zodiacSigns[_selectedZodiacIndex]["name"]!;
      
      final periodString = _timeframeIndex == 0 ? 'Daily' : (_timeframeIndex == 1 ? 'Weekly' : 'Yearly');
      final periodHindi = _timeframeIndex == 0 ? 'दैनिक' : (_timeframeIndex == 1 ? 'साप्ताहिक' : 'वार्षिक');

      final response = await Supabase.instance.client
          .from('rashifal')
          .select('*')
          .order('created_at', ascending: false);

      if (!mounted) return;

      if (response.isNotEmpty) {
        var matchedData = response.firstWhere(
          (item) {
            final rName = item['rashi_name']?.toString().trim().toLowerCase() ?? '';
            final pType = item['period_type']?.toString().trim().toLowerCase() ?? '';
            
            bool matchSign = rName == currentSignKey.toLowerCase() || rName == currentSignName.toLowerCase();
            bool matchPeriod = pType == periodString.toLowerCase() || pType == periodHindi.toLowerCase();
            
            return matchSign && matchPeriod;
          },
          orElse: () => {},
        );

        if (matchedData.isNotEmpty) {
          final recordId = matchedData['id'];
          setState(() {
            _fetchedRecordId = recordId;
            _fetchedPrediction = matchedData['prediction'] ?? matchedData['description'] ?? 'भविष्यफल उपलब्ध नहीं है।';
            _fetchedCareer = matchedData['career_finance'] ?? matchedData['career'] ?? '';
            _fetchedFamily = matchedData['family_love'] ?? matchedData['family'] ?? '';
            _fetchedHealth = matchedData['health'] ?? '';
            _fetchedLuckyNumber = (matchedData['lucky_number'] != null && matchedData['lucky_number'].toString().trim().isNotEmpty)
                ? matchedData['lucky_number'].toString()
                : '7';
            _fetchedLuckyColor = (matchedData['lucky_color'] != null && matchedData['lucky_color'].toString().trim().isNotEmpty)
                ? matchedData['lucky_color'].toString()
                : 'लाल (Red)';
            _fetchedDateRange = matchedData['date_range'] ?? '';
            _fetchedAudioUrl = matchedData['audio_url'];
            _isLoading = false;
          });

          _recordViewAndLikeStatus(recordId, matchedData['viewed_users'], matchedData['liked_users']);
        } else {
          setState(() {
            _fetchedRecordId = null;
            _fetchedPrediction = "इस अवधि (${_timeframeIndex == 0 ? 'दैनिक' : (_timeframeIndex == 1 ? 'साप्ताहिक' : 'वार्षिक')}) के लिए इस राशि का कोई राशिफल उपलब्ध नहीं है।";
            _fetchedCareer = "";
            _fetchedFamily = "";
            _fetchedHealth = "";
            _fetchedLuckyNumber = "-";
            _fetchedLuckyColor = "-";
            _fetchedDateRange = "";
            _fetchedAudioUrl = null;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _fetchedRecordId = null;
          _fetchedPrediction = "डेटाबेस में कोई रिकॉर्ड नहीं मिला।";
          _fetchedAudioUrl = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("❌ [StrictFetch Error]: $e");
      if (mounted) {
        setState(() {
          _fetchedPrediction = "डेटा लोड करने में त्रुटि हुई।";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentSign = _zodiacSigns[_selectedZodiacIndex];

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPrimaryBhagwa, size: 18),
          onPressed: () {
            _audioPlayer.stop();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "राशिफल (Horoscope)",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
        ),
        actions: [
          if (_fetchedRecordId != null)
            IconButton(
              icon: Icon(
                _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: Colors.red,
              ),
              onPressed: _toggleLike,
              tooltip: "राशिफल लाइक करें",
            ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Horizontal Zodiac Selector
            SizedBox(
              height: 88,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _zodiacSigns.length,
                itemBuilder: (context, index) {
                  final sign = _zodiacSigns[index];
                  final isSelected = _selectedZodiacIndex == index;
                  return GestureDetector(
                    onTap: () {
                      if (_selectedZodiacIndex == index) return;
                      setState(() => _selectedZodiacIndex = index);
                      _fetchLiveRashifalFromSupabase();
                    },
                    child: Container(
                      width: 72,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFFFF8F00), Color(0xFFFF6F00)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : const LinearGradient(
                                colors: [Colors.white, Color(0xFFFFF8F0)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.orange.shade200,
                          width: 1.2,
                        ),
                        boxShadow: isSelected
                            ? [const BoxShadow(color: Color(0x33FF6F00), blurRadius: 8, offset: Offset(0, 4))]
                            : kSmoothShadow,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(sign["icon"]!, style: const TextStyle(fontSize: 24)),
                          const SizedBox(height: 4),
                          Text(
                            sign["name"]!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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

            const SizedBox(height: 14),

            // 2. Timeframe Selector (Daily, Weekly, Yearly)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade100),
                boxShadow: kSmoothShadow,
              ),
              child: Row(
                children: [
                  _buildTimeframeTab("दैनिक (Daily)", 0),
                  _buildTimeframeTab("साप्ताहिक (Weekly)", 1),
                  _buildTimeframeTab("वार्षिक (Yearly)", 2),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 3. Selected Zodiac Info & Audio Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFAF0), Color(0xFFFFF3E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.orange.shade200),
                boxShadow: kSmoothShadow,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.orange.shade100, blurRadius: 4)],
                            ),
                            child: Text(currentSign["icon"]!, style: const TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${currentSign["name"]} राशि (${currentSign["en"]})",
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _fetchedDateRange.isNotEmpty ? "📅 $_fetchedDateRange" : currentSign["date"]!,
                                style: const TextStyle(fontSize: 11.5, color: kPrimaryBhagwa, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            if (_isPlayingAudio) {
                              await _audioPlayer.pause();
                              if (mounted) setState(() => _isPlayingAudio = false);
                            } else {
                              if (_fetchedAudioUrl != null && _fetchedAudioUrl!.trim().isNotEmpty) {
                                await _audioPlayer.play(UrlSource(_fetchedAudioUrl!));
                                if (mounted) setState(() => _isPlayingAudio = true);
                              } else {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("इस राशिफल के लिए अभी कोई ऑडियो उपलब्ध नहीं है!"),
                                      backgroundColor: Colors.red.shade700,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              }
                            }
                          } catch (e) {
                            debugPrint("Audio Play Error: $e");
                          }
                        },
                        icon: Icon(_isPlayingAudio ? Icons.pause_rounded : Icons.volume_up_rounded, size: 14, color: Colors.white),
                        label: Text(_isPlayingAudio ? "रोकें" : "सुनें", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryBhagwa,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),
                      ),
                    ],
                  ),
                  if (_isPlayingAudio) ...[
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      backgroundColor: Colors.orange.shade100,
                      valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryBhagwa),
                      minHeight: 4,
                    ),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("▶ ऑडियो चलाया जा रहा है (आचार्य जी की वाणी)", style: TextStyle(fontSize: 9.5, color: kSubTextColor)),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 4. Detailed Prediction Card (Live from Supabase)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.orange.shade100),
                boxShadow: kSmoothShadow,
              ),
              child: _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: CircularProgressIndicator(color: kPrimaryBhagwa),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.auto_stories_rounded, color: kPrimaryBhagwa, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  _timeframeIndex == 0 ? "आज का विस्तृत भविष्यफल" : (_timeframeIndex == 1 ? "इस सप्ताह का विस्तृत भविष्यफल" : "संपूर्ण भविष्यफल"),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor),
                                ),
                              ],
                            ),
                            if (_likesCount > 0)
                              Row(
                                children: [
                                  const Icon(Icons.favorite, color: Colors.red, size: 14),
                                  const SizedBox(width: 4),
                                  Text("$_likesCount", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red)),
                                ],
                              ),
                          ],
                        ),
                        const Divider(height: 20, color: Color(0xFFFDEED9)),
                        
                        Text(
                          _fetchedPrediction,
                          style: const TextStyle(fontSize: 12.5, color: kTextColor, height: 1.6),
                        ),
                        const SizedBox(height: 14),

                        if (_fetchedCareer.isNotEmpty) ...[
                          _buildSectionTitle("💼 करियर एवं व्यापार (Career & Business)"),
                          const SizedBox(height: 4),
                          Text(_fetchedCareer, style: const TextStyle(fontSize: 12, color: kSubTextColor, height: 1.5)),
                          const SizedBox(height: 14),
                        ],

                        if (_fetchedFamily.isNotEmpty) ...[
                          _buildSectionTitle("❤️ पारिवारिक जीवन एवं प्रेम संबंध"),
                          const SizedBox(height: 4),
                          Text(_fetchedFamily, style: const TextStyle(fontSize: 12, color: kSubTextColor, height: 1.5)),
                          const SizedBox(height: 14),
                        ],

                        if (_fetchedHealth.isNotEmpty) ...[
                          _buildSectionTitle("🧘 स्वास्थ्य एवं सावधानी (Health)"),
                          const SizedBox(height: 4),
                          Text(_fetchedHealth, style: const TextStyle(fontSize: 12, color: kSubTextColor, height: 1.5)),
                          const SizedBox(height: 16),
                        ],

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8F0),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.spaceAround,
                            spacing: 20,
                            runSpacing: 10,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("🔢 शुभ अंक: ", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: kTextColor)),
                                  Text(_fetchedLuckyNumber, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("🎨 शुभ रंग: ", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: kTextColor)),
                                  Text(_fetchedLuckyColor, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeframeTab(String title, int index) {
    final isSelected = _timeframeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_timeframeIndex == index) return;
          setState(() => _timeframeIndex = index);
          _fetchLiveRashifalFromSupabase();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryBhagwa : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [const BoxShadow(color: Color(0x33FF6F00), blurRadius: 4, offset: Offset(0, 2))] : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : kSubTextColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: kPrimaryBhagwa),
    );
  }
}