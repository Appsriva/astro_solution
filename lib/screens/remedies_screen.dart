import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    blurRadius: 6,
    offset: Offset(0, 3),
  ),
];

class RemedyItem {
  final String id;
  final String category;
  final String title;
  final String subtitle;
  final String planetOrDeity;
  final String mantra;
  final String readTime;
  final String imageUrl;
  final List<String> benefits;
  final String detailedBlog;

  const RemedyItem({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.planetOrDeity,
    required this.mantra,
    required this.readTime,
    required this.imageUrl,
    required this.benefits,
    required this.detailedBlog,
  });

  // 🌟 Supabase JSON से मॉडल बनाने के लिए फैक्ट्री मेथड
  factory RemedyItem.fromSupabase(Map<String, dynamic> map) {
    var rawBenefits = map['key_benefits'];
    List<String> parsedBenefits = [];
    if (rawBenefits is List) {
      parsedBenefits = rawBenefits.map((e) => e.toString()).toList();
    }

    return RemedyItem(
      id: map['id']?.toString() ?? '',
      category: map['category']?.toString() ?? 'नवग्रह शांति',
      title: map['title']?.toString() ?? '',
      subtitle: map['short_description']?.toString() ?? '',
      planetOrDeity: map['planet_or_deity']?.toString() ?? 'वैदिक उपाय',
      mantra: map['siddh_mantra']?.toString() ?? '',
      readTime: map['read_time']?.toString() ?? '3 मिनट का पाठ',
      imageUrl: map['banner_image']?.toString() ?? '',
      benefits: parsedBenefits.isNotEmpty ? parsedBenefits : ['समस्या का स्थायी समाधान', 'मानसिक शांति व सकारात्मक ऊर्जा'],
      detailedBlog: map['blog_body']?.toString() ?? '',
    );
  }
}

class RemediesScreen extends StatefulWidget {
  const RemediesScreen({super.key});

  @override
  State<RemediesScreen> createState() => _RemediesScreenState();
}

class _RemediesScreenState extends State<RemediesScreen> {
  String _selectedCategory = "सभी उपाय";
  final TextEditingController _searchController = TextEditingController();

  List<RemedyItem> _supabaseRemedies = [];
  bool _isLoading = true;

  static const List<String> _categories = [
    "सभी उपाय",
    "नवग्रह शांति",
    "कालसर्प / दोष",
    "धन एवं व्यापार",
    "विवाह एवं प्रेम",
    "स्वास्थ्य एवं दीर्घायु",
    "वास्तु उपाय",
  ];

  // 🌟 पुराने हार्डकोडेड फॉलबैक डेटा (सुरक्षा के लिए बरकरार)
  static const List<RemedyItem> _fallbackRemediesList = [
    RemedyItem(
      id: "rem_1",
      category: "नवग्रह शांति",
      title: "सूर्य ग्रह को बलवान करने के 5 अचूक वैदिक उपाय",
      subtitle: "सरकारी नौकरी, मान-सम्मान, पिता का सुख एवं आत्मविश्वास वृद्धि हेतु।",
      planetOrDeity: "भगवान सूर्य देव",
      mantra: "ॐ ह्रीं सूर्याय नमः (नित्य 108 बार)",
      readTime: "3 मिनट का पाठ",
      imageUrl: "https://images.unsplash.com/photo-1534447677768-be436bb09401?w=600&auto=format&fit=crop&q=80",
      benefits: [
        "सरकारी नौकरी एवं उच्च पद प्राप्ति के योग",
        "हड्डियों और नेत्र विकारों से मुक्ति",
        "समाज व कार्यक्षेत्र में नेतृत्व क्षमता में वृद्धि",
      ],
      detailedBlog: """
वैदिक ज्योतिष में सूर्य को 'आत्मा का कारक' और नवग्रहों का राजा माना गया है। जब कुंडली में सूर्य कमजोर या पीड़ित होता है, तो व्यक्ति को पिता से मतभेद, नौकरी में बाधा और आत्मसम्मान की कमी का सामना करना पड़ता है।

सूर्य को प्रसन्न करने के मुख्य वैदिक नियम:
1. नित्य प्रातः अर्घ्य: तांबे के लोटे में जल, रोली, लाल चंदन, गुड़ और लाल पुष्प मिलाकर उगते सूर्य को 'ॐ सूर्याय नमः' बोलते हुए जल अर्पित करें।
2. गायत्री मंत्र का जाप: प्रातःकाल पूर्व दिशा की ओर मुख करके गायत्री मंत्र या आदित्य हृदय स्तोत्र का पाठ करें।
3. दान पुण्य: रविवार के दिन तांबा, गेहूं, गुड़ और लाल वस्त्र का दान किसी योग्य ब्राह्मण को करें।
4. पिता का सम्मान: अपने पिता और बुजुर्गों के चरण स्पर्श कर नित्य आशीर्वाद लें।

सावधानी:
रविवार को नमक का कम से कम सेवन करें और किसी का अपमान न करें।
""",
    ),
    RemedyItem(
      id: "rem_2",
      category: "धन एवं व्यापार",
      title: "व्यापार में वृद्धि एवं कर्ज मुक्ति के गुप्त महालक्ष्मी उपाय",
      subtitle: "रुका हुआ धन वापस पाने, दुकान में बिक्री बढ़ाने एवं बरकत हेतु।",
      planetOrDeity: "माता महालक्ष्मी व कुबेर देव",
      mantra: "ॐ श्रीं ह्रीं क्लीं महालक्ष्म्यै नमः",
      readTime: "4 मिनट का पाठ",
      imageUrl: "https://images.unsplash.com/photo-1544717305-2782549b5136?w=600&auto=format&fit=crop&q=80",
      benefits: [
        "दुकान व व्यापार में ग्राहकों का आगमन बढ़ता है",
        "कर्ज के भारी बोझ से शीघ्र मुक्ति मिलती है",
        "अनावश्यक खर्चों पर रोक और बचत में वृद्धि",
      ],
      detailedBlog: """
व्यापार में लगातार घाटा या कर्ज की स्थिति तब बनती है जब कुंडली का दूसरा (धन) और ग्यारहवां (लाभ) भाव पाप ग्रहों से पीड़ित हो जाता है।

अचूक समृद्धि प्रयोग:
1. श्रीयंत्र स्थापना: शुक्रवार के दिन व्यापार स्थल या घर के पूजा कक्ष में प्राण-प्रतिष्ठित कनकधारा अथवा श्रीयंत्र स्थापित करें।
2. कमल गट्टे की माला: शुक्रवार की संध्या को शुद्ध घी का दीपक जलाकर कमल गट्टे की माला से महालक्ष्मी मंत्र की एक माला जपें।
3. झाड़ू दान: शनिवार या शुक्रवार की सुबह किसी मंदिर में गुप्त रूप से झाड़ू का दान करें।
4. तिजोरी का वास्तु: अपनी तिजोरी या गल्ले को उत्तर दिशा में रखें, ताकि उसका मुख कुबेर की दिशा (उत्तर) की ओर खुले।

सावधानी:
संध्या के समय घर में झाड़ू न लगाएं और मुख्य द्वार पर जूते-चप्पल न रखें।
""",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchRemediesFromSupabase();
  }

  // 🌟 Supabase से लाइव डेटा फेच करने का फंक्शन (Null-safety & Mounted check के साथ)
  Future<void> _fetchRemediesFromSupabase() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('vedic_upays')
          .select()
          .order('created_at', ascending: false);

      if (!mounted) return;

      if (response.isNotEmpty) {
        final List<RemedyItem> loaded = response.map((item) => RemedyItem.fromSupabase(item)).toList();
        setState(() {
          _supabaseRemedies = loaded;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching remedies from Supabase: $e");
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openRemedyBlogReader(RemedyItem remedy) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.92,
          decoration: const BoxDecoration(
            color: kCardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Top Bar Handle
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Action Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0E6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        remedy.category,
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

              // Blog Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Featured Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          remedy.imageUrl,
                          height: 190,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 190,
                            color: const Color(0xFFFFF0E6),
                            child: const Icon(Icons.auto_fix_high_rounded, color: kPrimaryBhagwa, size: 50),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        remedy.title,
                        style: const TextStyle(color: kTextColor, fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 13, color: kSubTextColor),
                          const SizedBox(width: 4),
                          Text(remedy.readTime, style: const TextStyle(color: kSubTextColor, fontSize: 11)),
                          const SizedBox(width: 12),
                          const Icon(Icons.temple_hindu_rounded, size: 13, color: kPrimaryBhagwa),
                          const SizedBox(width: 4),
                          Text(remedy.planetOrDeity, style: const TextStyle(color: kPrimaryBhagwa, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Mantra Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFFFCC80), width: 1.2),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.flare_rounded, color: kPrimaryBhagwa, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("सिद्ध महामंत्र:", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kSubTextColor)),
                                  Text(remedy.mantra, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: kTextColor)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Benefits List
                      const Text("इस उपाय से क्या लाभ होंगे?", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: kTextColor)),
                      const SizedBox(height: 6),
                      ...remedy.benefits.map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                            const SizedBox(width: 8),
                            Expanded(child: Text(b, style: const TextStyle(fontSize: 12, color: kTextColor))),
                          ],
                        ),
                      )),

                      const Divider(height: 24),

                      // Detailed Article Text
                      const Text("संपूर्ण विधि एवं शास्त्रीय नियम 📜", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor)),
                      const SizedBox(height: 8),
                      Text(
                        remedy.detailedBlog,
                        style: const TextStyle(fontSize: 13, color: kTextColor, height: 1.6),
                      ),

                      const SizedBox(height: 20),

                      // Bottom Consult CTA
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFFFF8F0), Color(0xFFFFE0B2)]),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.orange.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.psychology_rounded, color: kPrimaryBhagwa, size: 28),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("व्यक्तिगत कुंडली अनुसार उपाय चाहिए?", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                                  Text("हमारे शीर्ष वैदिक ज्योतिषियों से परामर्श लें", style: TextStyle(fontSize: 10, color: kSubTextColor)),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("ज्योतिषी कॉल/चैट स्क्रीन पर जाएं!"), backgroundColor: kPrimaryBhagwa),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryBhagwa,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(60, 32),
                              ),
                              child: const Text("पूछें", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    // 🌟 यदि Supabase से डेटा आ गया है तो उसे दिखाएं, अन्यथा फॉलबैक डेटा का उपयोग करें
    final activeList = _supabaseRemedies.isNotEmpty ? _supabaseRemedies : _fallbackRemidiesHelper();

    final filteredRemedies = _selectedCategory == "सभी उपाय"
        ? activeList
        : activeList.where((r) => r.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        title: const Text(
          "वैदिक उपाय एवं समाधान (Remedies) 🪔",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: kTextColor),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input Field
            TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 12, color: kTextColor),
              decoration: InputDecoration(
                hintText: "सूर्य दोष, व्यापार वृद्धि, मांगलिक उपाय खोजें...",
                hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                prefixIcon: const Icon(Icons.search_rounded, color: kPrimaryBhagwa, size: 20),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: kPrimaryBhagwa, width: 1.5)),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            const SizedBox(height: 12),

            // Category Chips List
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimaryBhagwa : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isSelected ? kPrimaryBhagwa : Colors.orange.shade200),
                        boxShadow: isSelected ? [BoxShadow(color: kPrimaryBhagwa.withAlpha(80), blurRadius: 4, offset: const Offset(0, 2))] : [],
                      ),
                      child: Center(
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : kTextColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Modern Magazine Style Remedy Cards List
            ...filteredRemedies.map((remedy) {
              return GestureDetector(
                onTap: () => _openRemedyBlogReader(remedy),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: kCardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.shade100),
                    boxShadow: kCardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Featured Blog Image with Badges
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: Image.network(
                              remedy.imageUrl,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 150,
                                color: const Color(0xFFFFF0E6),
                                child: const Icon(Icons.auto_fix_high_rounded, color: kPrimaryBhagwa, size: 40),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(190),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                remedy.category,
                                style: const TextStyle(color: kGoldAccent, fontSize: 9.5, fontWeight: FontWeight.bold),
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
                              ),
                              child: Text(
                                remedy.readTime,
                                style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Text Content
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              remedy.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: kTextColor, height: 1.25),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              remedy.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, color: kSubTextColor, height: 1.3),
                            ),
                            const SizedBox(height: 10),

                            // Inline Mantra Highlight
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF8F0),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFFFE0B2)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.flare_rounded, color: kPrimaryBhagwa, size: 14),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      remedy.mantra,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF5D2403)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Read Full Article Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "संपूर्ण विधि एवं ब्लॉग पढ़ें",
                                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: kPrimaryBhagwa),
                                ),
                                Icon(Icons.arrow_forward_rounded, color: kPrimaryBhagwa, size: 16),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<RemedyItem> _fallbackRemidiesHelper() {
    return _fallbackRemediesList;
  }
}