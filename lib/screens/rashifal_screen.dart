import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase इम्पोर्ट किया गया है

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

class RashifalScreen extends StatefulWidget {
  const RashifalScreen({super.key});

  @override
  State<RashifalScreen> createState() => _RashifalScreenState();
}

class _RashifalScreenState extends State<RashifalScreen> {
  int _selectedZodiacIndex = 0; // 0: मेष (Aries), etc.
  int _timeframeIndex = 0; // 0: दैनिक (Daily), 1: साप्ताहिक (Weekly), 2: वार्षिक (Yearly)
  bool _isPlayingAudio = false;

  bool _isLoading = true;
  String _fetchedPrediction = "";
  String _fetchedCareer = "";
  String _fetchedFamily = "";
  String _fetchedHealth = "";
  String _fetchedLuckyNumber = "7";
  String _fetchedLuckyColor = "लाल (Red)";

  final List<Map<String, String>> _zodiacSigns = [
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
    _fetchLiveRashifalFromSupabase();
  }

  // Supabase से लाइव डेटा फेच करने का फंक्शन
  Future<void> _fetchLiveRashifalFromSupabase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentSignKey = _zodiacSigns[_selectedZodiacIndex]["key"]!;
      final periodString = _timeframeIndex == 0 ? 'Daily' : (_timeframeIndex == 1 ? 'Weekly' : 'Yearly');

      final response = await Supabase.instance.client
          .from('rashifal')
          .select('*')
          .eq('rashi_name', currentSignKey)
          .eq('period_type', periodString)
          .order('created_at', ascending: false)
          .limit(1);

      if (response.isNotEmpty) {
        final data = response[0];
        setState(() {
          _fetchedPrediction = data['prediction'] ?? 'भविष्यफल उपलब्ध नहीं है।';
          _fetchedCareer = data['career_finance'] ?? 'जानकारी उपलब्ध नहीं।';
          _fetchedFamily = data['family_love'] ?? 'जानकारी उपलब्ध नहीं।';
          _fetchedHealth = data['health'] ?? 'जानकारी उपलब्ध नहीं।';
          _fetchedLuckyNumber = data['lucky_number'] ?? '7';
          _fetchedLuckyColor = data['lucky_color'] ?? 'लाल (Red)';
          _isLoading = false;
        });
      } else {
        setState(() {
          _fetchedPrediction = "इस राशि के लिए अभी कोई नया राशिफल अपडेट नहीं किया गया है। कृपया एडमिन पैनल से पब्लिश करें।";
          _fetchedCareer = "-";
          _fetchedFamily = "-";
          _fetchedHealth = "-";
          _fetchedLuckyNumber = "-";
          _fetchedLuckyColor = "-";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _fetchedPrediction = "डेटा लोड करने में त्रुटि: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentSign = _zodiacSigns[_selectedZodiacIndex];

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
          "राशिफल (Horoscope)",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 85,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _zodiacSigns.length,
                itemBuilder: (context, index) {
                  final sign = _zodiacSigns[index];
                  final isSelected = _selectedZodiacIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedZodiacIndex = index);
                      _fetchLiveRashifalFromSupabase(); // राशि बदलने पर नया डेटा लाएगा
                    },
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(colors: [kPrimaryBhagwa, kDeepSaffron])
                            : const LinearGradient(colors: [Colors.white, Color(0xFFFFF0E6)]),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? kPrimaryBhagwa : Colors.orange.shade200, width: isSelected ? 2 : 1),
                        boxShadow: kCardShadow,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(sign["icon"]!, style: const TextStyle(fontSize: 22)),
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

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  _buildTimeframeTab("दैनिक (Daily)", 0),
                  _buildTimeframeTab("साप्ताहिक (Weekly)", 1),
                  _buildTimeframeTab("वार्षिक (Yearly)", 2),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFCC80)),
                boxShadow: kCardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(currentSign["icon"]!, style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${currentSign["name"]} राशि (${currentSign["en"]})", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
                              Text(currentSign["date"]!, style: const TextStyle(fontSize: 10.5, color: kSubTextColor)),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isPlayingAudio = !_isPlayingAudio;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_isPlayingAudio ? "🎧 ऑडियो राशिफल चलाया जा रहा है..." : "⏸️ ऑडियो रोका गया"),
                              duration: const Duration(seconds: 2),
                              backgroundColor: kPrimaryBhagwa,
                            ),
                          );
                        },
                        icon: Icon(_isPlayingAudio ? Icons.pause_rounded : Icons.volume_up_rounded, size: 16, color: Colors.white),
                        label: Text(_isPlayingAudio ? "रोकें" : "सुनें (Audio)", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryBhagwa,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                  if (_isPlayingAudio) ...[
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      backgroundColor: Colors.orange.shade100,
                      valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryBhagwa),
                    ),
                    const SizedBox(height: 4),
                    const Text("▶ 0:15 / 3:45 (आचार्य जी की वाणी)", style: TextStyle(fontSize: 9.5, color: kSubTextColor)),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // एडमिन पैनल से आया हुआ लाइव डेटा यहाँ शो होगा
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade100),
                boxShadow: kCardShadow,
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
                          children: [
                            const Icon(Icons.auto_stories_rounded, color: kPrimaryBhagwa, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              _timeframeIndex == 0 ? "आज का विस्तृत भविष्यफल" : (_timeframeIndex == 1 ? "इस सप्ताह का विस्तृत भविष्यफल" : "संपूर्ण भविष्यफल"),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        
                        // मुख्य भविष्यफल
                        Text(_fetchedPrediction, style: const TextStyle(fontSize: 13, color: kTextColor, height: 1.6)),
                        const SizedBox(height: 14),

                        // करियर एवं व्यापार
                        if (_fetchedCareer.isNotEmpty) ...[
                          const Text("💼 करियर एवं व्यापार (Career & Business):", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
                          const SizedBox(height: 4),
                          Text(_fetchedCareer, style: const TextStyle(fontSize: 12.5, color: kTextColor, height: 1.5)),
                          const SizedBox(height: 14),
                        ],

                        // पारिवारिक जीवन
                        if (_fetchedFamily.isNotEmpty) ...[
                          const Text("❤️ पारिवारिक जीवन एवं प्रेम संबंध:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
                          const SizedBox(height: 4),
                          Text(_fetchedFamily, style: const TextStyle(fontSize: 12.5, color: kTextColor, height: 1.5)),
                          const SizedBox(height: 14),
                        ],

                        // स्वास्थ्य
                        if (_fetchedHealth.isNotEmpty) ...[
                          const Text("🧘 स्वास्थ्य एवं सावधानी (Health):", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
                          const SizedBox(height: 4),
                          Text(_fetchedHealth, style: const TextStyle(fontSize: 12.5, color: kTextColor, height: 1.5)),
                          const SizedBox(height: 16),
                        ],

                        // शुभ अंक और शुभ रंग कार्ड
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  const Text("🔢 शुभ अंक: ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                                  Text(_fetchedLuckyNumber, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("🎨 शुभ रंग: ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                                  Text(_fetchedLuckyColor, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 24),
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
          setState(() => _timeframeIndex = index);
          _fetchLiveRashifalFromSupabase(); // काल (दैनिक/साप्ताहिक/वार्षिक) बदलने पर डेटा लाएगा
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryBhagwa : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : kTextColor,
            ),
          ),
        ),
      ),
    );
  }
}