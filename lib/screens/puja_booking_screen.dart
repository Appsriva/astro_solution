import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);

class VedicPujaItem {
  final String id;
  final String title;
  final String deity;
  final String templeLocation;
  final String templeAddress;
  final String benefit;
  final String duration;
  final String category;
  final String priceSingle;
  final String priceFamily;
  final String priceMaha;
  final String imageUrl;
  final String nextDate;
  final List<String> onlineSlots;

  const VedicPujaItem({
    required this.id,
    required this.title,
    required this.deity,
    required this.templeLocation,
    required this.templeAddress,
    required this.benefit,
    required this.duration,
    required this.category,
    required this.priceSingle,
    required this.priceFamily,
    required this.priceMaha,
    required this.imageUrl,
    required this.nextDate,
    required this.onlineSlots,
  });
}

class PujaBookingScreen extends StatefulWidget {
  const PujaBookingScreen({super.key});

  @override
  State<PujaBookingScreen> createState() => _PujaBookingScreenState();
}

class _PujaBookingScreenState extends State<PujaBookingScreen> {
  String _selectedCategory = "सभी";
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _categories = [
    "सभी",
    "दोष निवारण",
    "स्वास्थ्य व आयु",
    "धन व व्यापार",
    "विवाह व दांपत्य",
    "शत्रु व ग्रह शांति",
  ];

  static const List<VedicPujaItem> _pujasList = [
    VedicPujaItem(
      id: "pj_1",
      title: "श्री महाकाल रुद्राभिषेक एवं भस्म आरती महापूजा",
      deity: "देवाधिदेव महादेव (महाकाल)",
      templeLocation: "उज्जैन धाम, मध्य प्रदेश",
      templeAddress: "श्री महाकालेश्वर ज्योतिर्लिंग मंदिर परिसर, जयसिंहपुरा, उज्जैन (म.प्र.) - 456006",
      benefit: "समस्त पापों, अकाल मृत्यु भय व कालसर्प दोष से मुक्ति।",
      duration: "2 घंटे 30 मिनट",
      category: "दोष निवारण",
      priceSingle: "₹1,100",
      priceFamily: "₹2,100",
      priceMaha: "₹5,100",
      imageUrl: "https://images.unsplash.com/photo-1609766857041-ed402ea8069a?w=600&auto=format&fit=crop&q=80",
      nextDate: "आगामी सोमवार (सोम प्रदोष)",
      onlineSlots: ["प्रातः 07:30 AM - 09:30 AM", "दोपहर 11:30 AM - 01:30 PM", "संध्या 06:30 PM - 08:30 PM"],
    ),
    VedicPujaItem(
      id: "pj_2",
      title: "सवा लाख महामृत्युंजय मंत्र जाप एवं हवन",
      deity: "भगवान शिव मृत्युंजय",
      templeLocation: "काशी विश्वनाथ धाम, वाराणसी",
      templeAddress: "श्री काशी विश्वनाथ मंदिर कॉरीडोर, ललिता घाट मार्ग, वाराणसी (उ.प्र.) - 221001",
      benefit: "गंभीर रोग निवारण, दीर्घायु स्वास्थ्य एवं नकारात्मक ऊर्जा का नाश।",
      duration: "4 घंटे अनुष्ठान",
      category: "स्वास्थ्य व आयु",
      priceSingle: "₹2,100",
      priceFamily: "₹5,100",
      priceMaha: "₹11,000",
      imageUrl: "https://images.unsplash.com/photo-1561361513-2d000a50f0dc?w=600&auto=format&fit=crop&q=80",
      nextDate: "आगामी त्रयोदशी तिथि",
      onlineSlots: ["प्रातः 06:00 AM - 10:00 AM", "दोपहर 02:00 PM - 06:00 PM"],
    ),
    VedicPujaItem(
      id: "pj_3",
      title: "कनकधारा स्तोत्र पाठ एवं श्री सूक्त महालक्ष्मी महायज्ञ",
      deity: "माता महालक्ष्मी एवं कुबेर देव",
      templeLocation: "महालक्ष्मी मंदिर, कोल्हापुर / मुंबई",
      templeAddress: "श्री महालक्ष्मी मंदिर, भुलाबाई देसाई रोड, महालक्ष्मी, मुंबई - 400026",
      benefit: "कर्ज मुक्ति, व्यापार वृद्धि एवं अटके हुए धन की शीघ्र प्राप्ति।",
      duration: "2 घंटे",
      category: "धन व व्यापार",
      priceSingle: "₹1,500",
      priceFamily: "₹3,100",
      priceMaha: "₹7,500",
      imageUrl: "https://images.unsplash.com/photo-1567591414240-e1e3b2e3a139?w=600&auto=format&fit=crop&q=80",
      nextDate: "आगामी शुक्रवार (वैभव लक्ष्मी दिवस)",
      onlineSlots: ["प्रातः 08:00 AM - 10:00 AM", "संध्या 07:00 PM - 09:00 PM"],
    ),
    VedicPujaItem(
      id: "pj_4",
      title: "मां कात्यायनी शीघ्र विवाह एवं मांगलिक दोष निवारण पूजा",
      deity: "मां भगवती कात्यायनी",
      templeLocation: "वृंदावन धाम, मथुरा",
      templeAddress: "मां कात्यायनी शक्तिपीठ, रंगनाथ मंदिर मार्ग, वृंदावन (मथुरा) - 281121",
      benefit: "विवाह में आ रही अड़चनों का नाश, मनचाहा योग्य जीवनसाथी।",
      duration: "1 घंटा 45 मिनट",
      category: "विवाह व दांपत्य",
      priceSingle: "₹1,250",
      priceFamily: "₹2,500",
      priceMaha: "₹5,500",
      imageUrl: "https://images.unsplash.com/photo-1545128485-c400e7702796?w=600&auto=format&fit=crop&q=80",
      nextDate: "आगामी गुरुवार",
      onlineSlots: ["प्रातः 09:00 AM - 10:45 AM", "दोपहर 03:30 PM - 05:15 PM"],
    ),
    VedicPujaItem(
      id: "pj_5",
      title: "मां बगलामुखी शत्रु विनाशक एवं कोर्ट-कचहरी विजय अनुष्ठान",
      deity: "मां पीतांबरा बगलामुखी",
      templeLocation: "नलखेड़ा / दतिया शक्तिपीठ",
      templeAddress: "मां बगलामुखी मंदिर, लखुंदर नदी तट, नलखेड़ा, आगर मालवा (म.प्र.) - 465445",
      benefit: "शत्रु बाधा शांति, मुकदमों में विजय व व्यापारिक प्रतिस्पर्धा निवारण।",
      duration: "3 घंटे",
      category: "शत्रु व ग्रह शांति",
      priceSingle: "₹2,500",
      priceFamily: "₹5,500",
      priceMaha: "₹15,000",
      imageUrl: "https://images.unsplash.com/photo-1590736969955-71cc94801759?w=600&auto=format&fit=crop&q=80",
      nextDate: "आगामी अष्टमी तिथि",
      onlineSlots: ["रात्रि 08:00 PM - 11:00 PM (निशीथ काल)"],
    ),
    VedicPujaItem(
      id: "pj_6",
      title: "नवग्रह शांति एवं संपूर्ण वास्तु दोष निवारण हवन",
      deity: "नवग्रह देवता एवं वास्तु पुरुष",
      templeLocation: "वैदिक गुरुकुल तीर्थ, प्रयागराज",
      templeAddress: "त्रिवेणी संगम तट, दारागंज, प्रयागराज (उ.प्र.) - 211006",
      benefit: "घर-परिवार में गृह क्लेश समाप्ति, सुख-शांति एवं 9 ग्रहों की शुभ दृष्टि।",
      duration: "2 घंटे 15 मिनट",
      category: "दोष निवारण",
      priceSingle: "₹1,100",
      priceFamily: "₹2,100",
      priceMaha: "₹4,500",
      imageUrl: "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&auto=format&fit=crop&q=80",
      nextDate: "आगामी पूर्णिमा तिथि",
      onlineSlots: ["प्रातः 08:30 AM - 10:45 AM", "दोपहर 12:00 PM - 02:15 PM"],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openBookingModal(VedicPujaItem puja) {
    String pujaMode = "online"; // 'online' or 'offline'
    String selectedPackageType = "family"; // 'single', 'family', 'maha'
    String selectedSlot = puja.onlineSlots.first;
    final TextEditingController nameController = TextEditingController(text: "यजमान");
    final TextEditingController gotraController = TextEditingController(text: "कश्यप");
    final TextEditingController addressController = TextEditingController();
    final TextEditingController phoneController = TextEditingController(text: "9876543210");
    final TextEditingController sankalpWishController = TextEditingController(text: "समस्त पारिवारिक सुख, समृद्धि एवं कार्य सिद्धि");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final currentPrice = selectedPackageType == "single"
                ? puja.priceSingle
                : (selectedPackageType == "family" ? puja.priceFamily : puja.priceMaha);

            return Container(
              height: MediaQuery.of(context).size.height * 0.90,
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

                  // Header with Puja Title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF0E6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.local_fire_department_rounded, color: kDeepSaffron, size: 24),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              puja.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor),
                            ),
                            Text(
                              "${puja.templeLocation} • ${puja.duration}",
                              style: const TextStyle(fontSize: 11, color: kPrimaryBhagwa, fontWeight: FontWeight.bold),
                            ),
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

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. ONLINE VS OFFLINE TOGGLE SWITCH
                          const Text(
                            "पूजा का प्रकार चुनें (Select Mode):",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor),
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setModalState(() => pujaMode = "online"),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: pujaMode == "online" ? const Color(0xFFFFF7F0) : Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: pujaMode == "online" ? kPrimaryBhagwa : Colors.orange.shade100,
                                        width: pujaMode == "online" ? 2 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.videocam_rounded, color: pujaMode == "online" ? kPrimaryBhagwa : Colors.grey, size: 20),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "ऑनलाइन लाइव पूजा 🔴",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: pujaMode == "online" ? kPrimaryBhagwa : kTextColor,
                                                ),
                                              ),
                                              const Text("घर बैठे लाइव संकल्प + प्रसाद", style: TextStyle(fontSize: 9, color: kSubTextColor)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setModalState(() => pujaMode = "offline"),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: pujaMode == "offline" ? const Color(0xFFFFF7F0) : Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: pujaMode == "offline" ? kPrimaryBhagwa : Colors.orange.shade100,
                                        width: pujaMode == "offline" ? 2 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.temple_hindu_rounded, color: pujaMode == "offline" ? kPrimaryBhagwa : Colors.grey, size: 20),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "ऑफलाइन मंदिर पूजा 🛕",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: pujaMode == "offline" ? kPrimaryBhagwa : kTextColor,
                                                ),
                                              ),
                                              const Text("मंदिर में प्रत्यक्ष उपस्थिति", style: TextStyle(fontSize: 9, color: kSubTextColor)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // 2. DYNAMIC MODE DETAILS
                          if (pujaMode == "online") ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF9F4),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.orange.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.access_time_filled_rounded, color: kPrimaryBhagwa, size: 16),
                                      SizedBox(width: 6),
                                      Text("लाइव संकल्प का समय स्लॉट चुनें:", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kTextColor)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: puja.onlineSlots.map((slot) {
                                      final isSlotSelected = selectedSlot == slot;
                                      return GestureDetector(
                                        onTap: () => setModalState(() => selectedSlot = slot),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isSlotSelected ? kPrimaryBhagwa : Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: isSlotSelected ? kPrimaryBhagwa : Colors.orange.shade200),
                                          ),
                                          child: Text(
                                            slot,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: isSlotSelected ? FontWeight.bold : FontWeight.w600,
                                              color: isSlotSelected ? Colors.white : kTextColor,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "✨ पुरोहित जी लाइव वीडियो पर आपका नाम व गोत्र उच्चारित कर संकल्प करवाएंगे। पूजा उपरांत अभिमंत्रित भस्म, रक्षासूत्र व प्रसाद आपके पते पर भेजा जाएगा।",
                                    style: TextStyle(fontSize: 10, color: kSubTextColor, height: 1.3),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F8E9),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.green.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_rounded, color: Colors.green.shade800, size: 18),
                                      const SizedBox(width: 6),
                                      Text(
                                        "मंदिर / तीर्थ स्थल का पूरा पता:",
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    puja.templeAddress,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kTextColor, height: 1.35),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      "📍 रिपोर्टिंग समय: पूजा से 30 मिनट पूर्व • पुरोहित संपर्क नंबर पास में मिलेगा।",
                                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 14),

                          // 3. PACKAGE / DAKSHINA SELECTION
                          const Text(
                            "संकल्प प्रकार चुनें (Select Package):",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor),
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Expanded(
                                child: _buildPackageOption(
                                  title: "एकल संकल्प",
                                  price: puja.priceSingle,
                                  desc: "1 व्यक्ति का नाम",
                                  isSelected: selectedPackageType == "single",
                                  onTap: () => setModalState(() => selectedPackageType = "single"),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: _buildPackageOption(
                                  title: "परिवार संकल्प",
                                  price: puja.priceFamily,
                                  desc: "पूरे परिवार के नाम",
                                  isSelected: selectedPackageType == "family",
                                  onTap: () => setModalState(() => selectedPackageType = "family"),
                                  isPopular: true,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: _buildPackageOption(
                                  title: "महा अनुष्ठान",
                                  price: puja.priceMaha,
                                  desc: "विशेष व्यक्तिगत हवन",
                                  isSelected: selectedPackageType == "maha",
                                  onTap: () => setModalState(() => selectedPackageType = "maha"),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // 4. DEVOTEE DETAILS INPUTS
                          const Text(
                            "यजमान एवं संकल्प विवरण:",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor),
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: nameController,
                                  style: const TextStyle(fontSize: 12, color: kTextColor),
                                  decoration: InputDecoration(
                                    labelText: "यजमान का नाम",
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

                          const SizedBox(height: 10),

                          TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(fontSize: 12, color: kTextColor),
                            decoration: InputDecoration(
                              labelText: "मोबाइल नंबर",
                              labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                              prefixIcon: const Icon(Icons.phone_outlined, color: kPrimaryBhagwa, size: 18),
                              filled: true,
                              fillColor: const Color(0xFFFFFDF9),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                              contentPadding: const EdgeInsets.all(10),
                            ),
                          ),

                          const SizedBox(height: 10),

                          TextField(
                            controller: sankalpWishController,
                            style: const TextStyle(fontSize: 12, color: kTextColor),
                            decoration: InputDecoration(
                              labelText: "विशेष मनोकामना / संकल्प उद्देश्य",
                              labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                              prefixIcon: const Icon(Icons.stars_rounded, color: kPrimaryBhagwa, size: 18),
                              filled: true,
                              fillColor: const Color(0xFFFFFDF9),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                              contentPadding: const EdgeInsets.all(10),
                            ),
                          ),

                          if (pujaMode == "online") ...[
                            const SizedBox(height: 10),
                            TextField(
                              controller: addressController,
                              style: const TextStyle(fontSize: 12, color: kTextColor),
                              decoration: InputDecoration(
                                labelText: "प्रसाद डिलीवरी का पूरा पता (मकान, शहर, पिनकोड)",
                                labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                                prefixIcon: const Icon(Icons.home_rounded, color: kPrimaryBhagwa, size: 18),
                                filled: true,
                                fillColor: const Color(0xFFFFFDF9),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                contentPadding: const EdgeInsets.all(10),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Confirmation Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final yajmanName = nameController.text.trim().isEmpty ? "यजमान" : nameController.text.trim();
                        final gotra = gotraController.text.trim().isEmpty ? "कश्यप" : gotraController.text.trim();
                        final phone = phoneController.text.trim().isEmpty ? "9876543210" : phoneController.text.trim();
                        final sankalp = sankalpWishController.text.trim();
                        final numericDakshina = double.tryParse(currentPrice.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1100.0;

                        // Insert to Supabase puja_bookings
                        try {
                          final user = Supabase.instance.client.auth.currentUser;
                          if (user != null) {
                            await Supabase.instance.client.from('puja_bookings').insert({
                              'user_id': user.id,
                              'puja_title': puja.title,
                              'temple_location': puja.templeLocation,
                              'dakshina': numericDakshina,
                              'puja_date': puja.nextDate,
                              'yajman_name': yajmanName,
                              'gotra': gotra,
                              'sankalp_text': sankalp,
                              'phone': phone,
                              'status': 'Sankalp Registered',
                            });
                          }
                        } catch (_) {}

                        Navigator.pop(modalContext);
                        _showPujaSuccessDialog(
                          puja: puja,
                          mode: pujaMode,
                          price: currentPrice,
                          name: yajmanName,
                          gotra: gotra,
                          slotOrAddress: pujaMode == "online" ? selectedSlot : puja.templeAddress,
                          sankalp: sankalp,
                        );
                      },
                      icon: const Icon(Icons.check_circle_rounded, size: 18),
                      label: Text(
                        "$currentPrice में ${pujaMode == 'online' ? 'ऑनलाइन' : 'मंदिर'} पूजा बुक करें 🚩",
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
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
            );
          },
        );
      },
    );
  }

  Widget _buildPackageOption({
    required String title,
    required String price,
    required String desc,
    required bool isSelected,
    required VoidCallback onTap,
    bool isPopular = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF7F0) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? kPrimaryBhagwa : Colors.orange.shade100,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            if (isPopular)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                child: const Text("POPULAR", style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
              ),
            Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kTextColor)),
            const SizedBox(height: 2),
            Text(price, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
            const SizedBox(height: 2),
            Text(desc, style: const TextStyle(fontSize: 8, color: kSubTextColor)),
          ],
        ),
      ),
    );
  }

  void _showPujaSuccessDialog({
    required VedicPujaItem puja,
    required String mode,
    required String price,
    required String name,
    required String gotra,
    required String slotOrAddress,
    required String sankalp,
  }) {
    final isOnline = mode == "online";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.shade300, width: 2),
                ),
                child: const Icon(Icons.verified_rounded, color: Colors.green, size: 34),
              ),
              const SizedBox(height: 10),
              Text(
                isOnline ? "ऑनलाइन पूजा संकल्प बुक हुआ! 🚩" : "मंदिर पूजा बुकिंग कन्फर्म! 🛕",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
              ),
              const SizedBox(height: 4),
              Text(
                puja.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(fontSize: 11, color: kSubTextColor, height: 1.3),
              ),
              const SizedBox(height: 12),

              // Digital Sankalp / Entry Pass Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9F4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFCC80)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        isOnline ? "📜 ई-संकल्प रसीद (Live Puja Pass)" : "🛕 मंदिर दर्शन व पूजा पास",
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kPrimaryBhagwa),
                      ),
                    ),
                    const Divider(height: 12),
                    _buildReceiptRow("यजमान:", name),
                    _buildReceiptRow("गोत्र:", gotra),
                    _buildReceiptRow("पूजा माध्यम:", isOnline ? "ऑनलाइन लाइव वीडियो" : "मंदिर में प्रत्यक्ष"),
                    _buildReceiptRow(
                      isOnline ? "लाइव स्लॉट समय:" : "मंदिर का पता:",
                      slotOrAddress,
                    ),
                    _buildReceiptRow("दक्षिणा राशि:", price),
                    _buildReceiptRow("बुकिंग ID:", "PUJA_${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}"),
                  ],
                ),
              ),

              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryBhagwa,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text("धन्यवाद एवं जय श्री राम", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: kSubTextColor, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kTextColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filteredPujas = _pujasList.where((puja) {
      final matchesQuery = puja.title.toLowerCase().contains(query) ||
          puja.deity.toLowerCase().contains(query) ||
          puja.templeLocation.toLowerCase().contains(query);

      if (!matchesQuery) return false;
      if (_selectedCategory == "सभी") return true;
      return puja.category == _selectedCategory;
    }).toList();

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
          "वैदिक पूजा एवं अनुष्ठान 🪔",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: kTextColor),
        ),
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() {}),
              style: const TextStyle(fontSize: 13, color: kTextColor),
              decoration: InputDecoration(
                hintText: "पूजा का नाम, देवता या मंदिर खोजें...",
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
              ),
            ),
          ),

          // 2. Category Filters
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? kPrimaryBhagwa : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSelected ? kPrimaryBhagwa : Colors.orange.shade200),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? Colors.white : kTextColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // 3. Puja Cards Listing
          Expanded(
            child: filteredPujas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text("कोई पूजा नहीं मिली!", style: TextStyle(fontSize: 14, color: kSubTextColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: filteredPujas.length,
                    itemBuilder: (context, index) {
                      final puja = filteredPujas[index];
                      return _buildPujaCard(puja);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPujaCard(VedicPujaItem puja) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image with Badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.network(
                  puja.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    color: const Color(0xFFFFF0E6),
                    child: const Center(
                      child: Icon(Icons.temple_hindu_rounded, color: kPrimaryBhagwa, size: 48),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xCC000000),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: kGoldAccent, size: 11),
                      const SizedBox(width: 3),
                      Text(puja.templeLocation, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(puja.nextDate, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),

          // Details Body
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  puja.title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor),
                ),
                const SizedBox(height: 2),
                Text(
                  "देवता: ${puja.deity} • अवधि: ${puja.duration}",
                  style: const TextStyle(fontSize: 10, color: kPrimaryBhagwa, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  puja.benefit,
                  style: const TextStyle(fontSize: 11, color: kSubTextColor),
                ),
                const Divider(height: 14),

                // Modes & Pricing Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("दक्षिणा शुल्क:", style: TextStyle(fontSize: 9, color: kSubTextColor)),
                        Row(
                          children: [
                            Text(puja.priceSingle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
                            const SizedBox(width: 4),
                            const Text("से शुरू", style: TextStyle(fontSize: 10, color: kSubTextColor)),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _openBookingModal(puja),
                      icon: const Icon(Icons.calendar_month_rounded, size: 14),
                      label: const Text("पूजा बुक करें", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryBhagwa,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}