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
}

class RemediesScreen extends StatefulWidget {
  const RemediesScreen({super.key});

  @override
  State<RemediesScreen> createState() => _RemediesScreenState();
}

class _RemediesScreenState extends State<RemediesScreen> {
  String _selectedCategory = "सभी उपाय";
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _categories = [
    "सभी उपाय",
    "नवग्रह शांति",
    "कालसर्प / दोष",
    "धन एवं व्यापार",
    "विवाह एवं प्रेम",
    "स्वास्थ्य एवं दीर्घायु",
    "वास्तु उपाय",
  ];

  static const List<RemedyItem> _remediesList = [
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
    RemedyItem(
      id: "rem_3",
      category: "कालसर्प / दोष",
      title: "कालसर्प एवं राहु-केतु दोष निवारण महा-अनुष्ठान",
      subtitle: "अचानक बनते काम बिगड़ने, डरावने सपने व मानसिक तनाव से मुक्ति।",
      planetOrDeity: "देवाधिदेव महादेव (शिव)",
      mantra: "ॐ नमः शिवाय • ॐ रां राहवे नमः",
      readTime: "5 मिनट का पाठ",
      imageUrl: "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&auto=format&fit=crop&q=80",
      benefits: [
        "मानसिक बेचैनी और अज्ञात भय समाप्त होता है",
        "विवाह और संतान प्राप्ति की रुकावटें दूर होती हैं",
        "कार्यक्षेत्र में स्थिरता और अचानक लाभ",
      ],
      detailedBlog: """
जब जन्मकुंडली में सभी सातों मुख्य ग्रह राहु और केतु की धुरी के बीच आ जाते हैं, तब कालसर्प योग का निर्माण होता है। इससे जीवन में बार-बार उतार-चढ़ाव आते हैं।

कालसर्प शांति के सरल उपाय:
1. महामृत्युंजय मंत्र: प्रतिदिन या प्रति सोमवार रुद्राक्ष की माला से 108 बार महामृत्युंजय मंत्र का सस्वर जाप करें।
2. नाग-नागिन का अर्पण: नागपंचमी या सोमवार को चांदी या तांबे का नाग-नागिन जोड़ा शिवलिंग पर अर्पित करें।
3. शिवलिंग अभिषेक: सोमवार को कच्चे दूध में काले तिल मिलाकर शिवलिंग का अभिषेक करें।
4. पक्षियों को दाना: नित्य सुबह सात प्रकार के अनाजों (सप्तधान्य) को पक्षियों को खिलाएं।
""",
    ),
    RemedyItem(
      id: "rem_4",
      category: "विवाह एवं प्रेम",
      title: "शीघ्र विवाह एवं मांगलिक दोष शांति के चमत्कारी नियम",
      subtitle: "रिश्ते पक्के होने में आ रही रुकावटों और दांपत्य कलह का निवारण।",
      planetOrDeity: "भगवान विष्णु एवं मां कात्यायनी",
      mantra: "कात्यायनि महामाये महायोगिन्यधीश्वरि",
      readTime: "3 मिनट का पाठ",
      imageUrl: "https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=600&auto=format&fit=crop&q=80",
      benefits: [
        "योग्य एवं मनपसंद जीवनसाथी की प्राप्ति",
        "मांगलिक दोष के प्रभाव में भारी कमी",
        "दांपत्य जीवन में प्रेम और सामंजस्य",
      ],
      detailedBlog: """
गुरु ग्रह (बृहस्पति) और शुक्र ग्रह की कमजोरी के कारण विवाह में अनावश्यक विलंब होता है। 

शीघ्र विवाह के उपाय:
1. गुरुवार का व्रत: गुरुवार के दिन पीले वस्त्र धारण करें और केले के वृक्ष में हल्दी मिला जल अर्पित कर दीपक लगाएं।
2. कात्यायनी स्तुति: कन्याएं शीघ्र विवाह हेतु माता कात्यायनी के मंत्र का जप करें।
3. विष्णु-सहस्रनाम: लड़कों को अपने विवाह में आ रही अड़चनों को दूर करने के लिए नित्य विष्णु सहस्रनाम का पाठ करना चाहिए।
4. पुखराज या टोपाज: किसी योग्य ज्योतिषी से कुंडली दिखाकर तर्जनी उंगली में पीला पुखराज धारण करें।
""",
    ),
    RemedyItem(
      id: "rem_5",
      category: "स्वास्थ्य एवं दीर्घायु",
      title: "शनि साढ़ेसाती एवं असाध्य रोगों से रक्षा हेतु हनुमान साधना",
      subtitle: "शनिदेव की क्रूर दृष्टि से बचाव और शारीरिक व्याधियों का नाश।",
      planetOrDeity: "पवनपुत्र हनुमान एवं शनिदेव",
      mantra: "ॐ शं शनैश्चराय नमः • ॐ हनुमते नमः",
      readTime: "4 मिनट का पाठ",
      imageUrl: "https://images.unsplash.com/photo-1532274402911-5a369e4c4bb5?w=600&auto=format&fit=crop&q=80",
      benefits: [
        "दुर्घटनाओं और गंभीर बीमारियों से सुरक्षा कवच",
        "शनि साढ़ेसाती और ढैय्या के कष्टों में राहत",
        "शत्रु बाधा और नकारात्मक शक्तियों का नाश",
      ],
      detailedBlog: """
शनि न्याय के देवता हैं। यदि कुंडली में शनि अशुभ स्थान पर हो तो जोड़ों का दर्द, आलस्य और मानसिक तनाव बढ़ जाता है।

शनि कृपा पाने के उपाय:
1. सुंदरकांड का पाठ: प्रत्येक मंगलवार और शनिवार को संध्याकाल में सुंदरकांड या हनुमान चालीसा का पाठ करें।
2. छाया दान: शनिवार की सुबह कांसे या लोहे की कटोरी में सरसों का तेल डालकर उसमें अपना चेहरा देखें और उसे दान करें।
3. पीपल प्रदक्षिणा: शनिवार की शाम पीपल के वृक्ष के नीचे सरसों के तेल का चौमुखा दीपक जलाकर 7 परिक्रमा करें।
4. काले कुत्ते की सेवा: नित्य काले कुत्ते को सरसों का तेल लगी रोटी खिलाएं।
""",
    ),
  ];

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
    final filteredRemedies = _selectedCategory == "सभी उपाय"
        ? _remediesList
        : _remediesList.where((r) => r.category == _selectedCategory).toList();

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
}