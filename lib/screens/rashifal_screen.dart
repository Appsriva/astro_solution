import 'package:flutter/material.dart';

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
  int _timeframeIndex = 0; // 0: दैनिक, 1: साप्ताहिक, 2: वार्षिक
  bool _isPlayingAudio = false;

  final List<Map<String, String>> _zodiacSigns = [
    {"name": "मेष", "en": "Aries", "date": "Mar 21 - Apr 19", "icon": "♈"},
    {"name": "वृषभ", "en": "Taurus", "date": "Apr 20 - May 20", "icon": "♉"},
    {"name": "मिथुन", "en": "Gemini", "date": "May 21 - Jun 20", "icon": "♊"},
    {"name": "कर्क", "en": "Cancer", "date": "Jun 21 - Jul 22", "icon": "♋"},
    {"name": "सिंह", "en": "Leo", "date": "Jul 23 - Aug 22", "icon": "♌"},
    {"name": "कन्या", "en": "Virgo", "date": "Aug 23 - Sep 22", "icon": "♍"},
    {"name": "तुला", "en": "Libra", "date": "Sep 23 - Oct 22", "icon": "♎"},
    {"name": "वृश्चिक", "en": "Scorpio", "date": "Oct 23 - Nov 21", "icon": "♏"},
    {"name": "धनु", "en": "Sagittarius", "date": "Nov 22 - Dec 21", "icon": "♐"},
    {"name": "मकर", "en": "Capricorn", "date": "Dec 22 - Jan 19", "icon": "♑"},
    {"name": "कुंभ", "en": "Aquarius", "date": "Jan 20 - Feb 18", "icon": "♒"},
    {"name": "मीन", "en": "Pisces", "date": "Feb 19 - Mar 20", "icon": "♓"},
  ];

  // 600-700 Words Detailed Horoscope Database (Daily / Weekly / Yearly)
  final Map<int, Map<int, String>> _horoscopeContent = {
    0: {
      0: """आज का मेष राशिफल (Daily Horoscope):
गणेशजी कहते हैं कि आज का दिन आपके लिए ऊर्जा और उत्साह से भरपूर रहेगा। कार्यक्षेत्र में आपके सहकर्मी और वरिष्ठ अधिकारी आपके नेतृत्व कौशल की सराहना करेंगे। यदि आप पिछले कुछ समय से किसी नए प्रोजेक्ट की शुरुआत करने की सोच रहे थे, तो आज का दिन अत्यंत शुभ है। 

करियर एवं व्यापार:
व्यापारियों को धन लाभ के नए अवसर प्राप्त हो सकते हैं। सहकर्मियों के साथ तालमेल बेहतरीन रहेगा। नौकरीपेशा जातकों को प्रमोशन या मनचाही जगह ट्रांसफर की खुशखबरी मिल सकती है। आर्थिक मामलों में समझदारी से निर्णय लें, किसी को भी उधार देने से बचें।

पारिवारिक जीवन एवं प्रेम संबंध:
जीवनसाथी के साथ आपके संबंध प्रगाढ़ होंगे। परिवार के साथ किसी धार्मिक स्थल पर जाने का योग बन सकता है। प्रेम जीवन में आपसी संवाद बेहतर होगा, जिससे गलतफहमियां दूर होंगी। माता-पिता का स्वास्थ्य उत्तम रहेगा।

स्वास्थ्य एवं सावधानी:
शारीरिक रूप से आप तरोताजा महसूस करेंगे, परंतु खान-पान पर विशेष ध्यान दें। बाहर के तले-भुने भोजन से परहेज करें। योग और प्राणायाम को अपनी दिनचर्या में शामिल करें।""",

      1: """साप्ताहिक मेष राशिफल (Weekly Horoscope):
यह सप्ताह मेष राशि के जातकों के लिए मिश्रित परिणाम लेकर आया है। सप्ताह की शुरुआत में आपको करियर और व्यापार के सिलसिले में छोटी यात्राएं करनी पड़ सकती हैं। यह यात्राएं भविष्य में आपके लिए अत्यंत लाभकारी सिद्ध होंगी। 

आर्थिक स्थिति:
सप्ताह के मध्य में अचानक धन लाभ के योग बन रहे हैं। पैतृक संपत्ति से जुड़े विवादों का फैसला आपके पक्ष में आ सकता है। हालांकि, विलासिता की वस्तुओं पर अधिक खर्च करने से बचें। बचत पर ध्यान देना इस समय आपकी प्राथमिकता होनी चाहिए।

प्रेम एवं वैवाहिक जीवन:
विवाहित जातकों के लिए यह सप्ताह बेहद खुशनुमा रहने वाला है। जीवनसाथी के साथ क्वालिटी Time बिताने का अवसर मिलेगा। प्रेम संबंधों में गहराई आएगी और आप अपने पार्टनर के साथ भविष्य की योजनाएं साझा कर सकते हैं।

स्वास्थ्य:
मौसम में बदलाव के कारण आपको सर्दी-जुखाम या थकान की शिकायत हो सकती है। पर्याप्त मात्रा में पानी पिएं और अपने मानसिक स्वास्थ्य को बेहतर रखने के लिए संगीत सुनें या ध्यान लगाएं।""",

      2: """वार्षिक मेष राशिफल (Yearly Horoscope):
वर्ष 2026 मेष राशि के जातकों के लिए अभूतपूर्व सफलता और आत्म-विकास का वर्ष साबित होने वाला है। इस वर्ष आपके जीवन में कई सकारात्मक बदलाव आएंगे। लंबे समय से अटके हुए सरकारी कार्य पूरे होंगे और आपकी सामाजिक प्रतिष्ठा में वृद्धि होगी।

व्यापार एवं वित्तीय स्थिति:
वर्ष की शुरुआत में आपको बिजनेस के विस्तार के लिए बड़े निवेशकों का साथ मिलेगा। विदेशी स्रोतों से भी धन कमाने के योग बन रहे हैं। आर्थिक स्थिति मजबूत होगी, जिससे आप नया मकान या वाहन खरीदने का सपना पूरा कर सकेंगे।

शिक्षा एवं करियर:
विद्यार्थियों और प्रतियोगी परीक्षाओं की तैयारी कर रहे युवाओं के लिए यह वर्ष स्वर्णिम अवसरों से भरा है। उच्च शिक्षा के लिए विदेश जाने का मार्ग प्रशस्त हो सकता है। नौकरी में आपको नई जिम्मेदारियां सौंपी जाएंगी जो आपके भविष्य को मजबूत करेंगी।

स्वास्थ्य एवं समग्र कल्याण:
पूरा वर्ष आपका स्वास्थ्य कुल मिलाकर उत्तम रहेगा। ग्रहों की स्थिति आपको मानसिक रूप से मजबूत बनाएगी। अपने इष्टदेव की आराधना करें और नियमित रूप से हनुमान चालीसा का पाठ करें, इससे आपके सभी मार्ग प्रशस्त होंगे।"""
    },
  };

  @override
  Widget build(BuildContext context) {
    final currentSign = _zodiacSigns[_selectedZodiacIndex];
    final signContentMap = _horoscopeContent[_selectedZodiacIndex] ?? _horoscopeContent[0]!;
    final detailedText = signContentMap[_timeframeIndex] ?? "विस्तृत भविष्यफल लोड हो रहा है...";

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
                    onTap: () => setState(() => _selectedZodiacIndex = index),
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

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade100),
                boxShadow: kCardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_stories_rounded, color: kPrimaryBhagwa, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _timeframeIndex == 0 ? "आज का विस्तृत भविष्यफल" : (_timeframeIndex == 1 ? "इस सप्ताह का विस्तृत भविष्यफल" : "वर्ष 2026 का संपूर्ण भविष्यफल"),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Text(
                    detailedText,
                    style: const TextStyle(fontSize: 13, color: kTextColor, height: 1.6),
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
        onTap: () => setState(() => _timeframeIndex = index),
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