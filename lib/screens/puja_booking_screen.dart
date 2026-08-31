import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);

// पंडित प्रोफाइल मॉडल (कॉल/चैट स्क्रीन जैसा लुक)
class PanditProfile {
  final String name;
  final String skills;
  final String rating;
  final String imageUrl;

  PanditProfile({
    required this.name,
    required this.skills,
    required this.rating,
    required this.imageUrl,
  });
}

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
  final String basePrice;
  final String imageUrl;
  final String nextDate;
  final List<String> onlineSlots;
  final List<PanditProfile> assignedPandits; // पंडित प्रोफाइल लिस्ट

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
    required this.basePrice,
    required this.imageUrl,
    required this.nextDate,
    required this.onlineSlots,
    required this.assignedPandits,
  });

  // Supabase Map से ऑब्जेक्ट बनाने के लिए Factory Constructor
  factory VedicPujaItem.fromMap(Map<String, dynamic> map) {
    var panditsRaw = map['assigned_pandits'];
    List<PanditProfile> parsedPandits = [];
    
    if (panditsRaw != null && panditsRaw is List) {
      parsedPandits = panditsRaw.map((e) {
        return PanditProfile(
          name: e.toString(),
          skills: "कर्मकांड, वैदिक मंत्रोच्चार, रुद्राभिषेक",
          rating: "4.9 ⭐ (1.2k)",
          imageUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&auto=format&fit=crop&q=80",
        );
      }).toList();
    } else {
      parsedPandits = [
        PanditProfile(name: 'पं. राधेश्याम शास्त्री', skills: 'मुख्य आचार्य, महाकाल विशेषज्ञ', rating: '5.0 ⭐', imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200'),
        PanditProfile(name: 'आचार्य सुरेश शास्त्री', skills: 'काशी विद्वान, रुद्राभिषेक', rating: '4.8 ⭐', imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200'),
      ];
    }

    final priceStr = "₹${map['dakshina_amount'] ?? '1,100'}";

    return VedicPujaItem(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? 'वैदिक पूजा',
      deity: map['deity'] ?? 'देवाधिदेव महादेव',
      templeLocation: map['temples']?['name'] ?? map['temple_location'] ?? 'प्रमुख मंदिर, भारत',
      templeAddress: map['temples']?['full_address'] ?? map['temple_address'] ?? 'प्रमुख तीर्थ स्थल परिसर',
      benefit: map['description'] ?? 'समस्त कष्टों का निवारण एवं मनोकामना पूर्ति।',
      duration: map['duration'] ?? '2 घंटे',
      category: map['category'] ?? 'दोष निवारण',
      priceSingle: priceStr,
      priceFamily: priceStr,
      priceMaha: priceStr,
      basePrice: priceStr,
      imageUrl: map['image_url'] ?? "https://images.unsplash.com/photo-1609766857041-ed402ea8069a?w=600&auto=format&fit=crop&q=80",
      nextDate: map['next_date'] ?? 'आगामी शुभ मुहूर्त',
      onlineSlots: ["प्रातः 07:30 AM - 09:30 AM", "दोपहर 11:30 AM - 01:30 PM", "संध्या 06:30 PM - 08:30 PM"],
      assignedPandits: parsedPandits,
    );
  }
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

  // Supabase से लाइव डेटा फेच करने के लिए Future
  late Future<List<VedicPujaItem>> _pujasFuture;

  @override
  void initState() {
    super.initState();
    _pujasFuture = _fetchPujasFromSupabase();
  }

  Future<List<VedicPujaItem>> _fetchPujasFromSupabase() async {
    try {
      final response = await Supabase.instance.client
          .from('poojas')
          .select('*, temples(name, full_address, city)')
          .order('created_at');

      if ((response as List).isNotEmpty) {
        return (response as List).map((item) => VedicPujaItem.fromMap(item)).toList();
      }
    } catch (e) {
      debugPrint("Supabase fetch error: $e");
    }
    return _fallbackPujasList;
  }

  // पुराना डमी डेटा (फॉलबैक सुरक्षा के लिए)
  static final List<VedicPujaItem> _fallbackPujasList = [
    VedicPujaItem(
      id: "pj_1",
      title: "श्री महाकाल रुद्राभिषेक एवं भस्म आरती महापूजा",
      deity: "देवाधिदेव महादेव (महाकाल)",
      templeLocation: "उज्जैन धाम, मध्य प्रदेश",
      templeAddress: "श्री महाकालेश्वर ज्योतिर्लिंग मंदिर परिसर, उज्जैन (म.प्र.) - 456006",
      benefit: "समस्त पापों, अकाल मृत्यु भय व कालसर्प दोष से मुक्ति।",
      duration: "2 घंटे 30 मिनट",
      category: "दोष निवारण",
      priceSingle: "₹1,100",
      priceFamily: "₹1,100",
      priceMaha: "₹1,100",
      basePrice: "₹1,100",
      imageUrl: "https://images.unsplash.com/photo-1609766857041-ed402ea8069a?w=600&auto=format&fit=crop&q=80",
      nextDate: "आगामी सोमवार (सोम प्रदोष)",
      onlineSlots: ["प्रातः 07:30 AM - 09:30 AM", "दोपहर 11:30 AM - 01:30 PM", "संध्या 06:30 PM - 08:30 PM"],
      assignedPandits: [
        PanditProfile(name: 'पं. राधेश्याम शास्त्री', skills: 'मुख्य आचार्य, महाकाल विशेषज्ञ', rating: '5.0 ⭐', imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200'),
        PanditProfile(name: 'आचार्य सुरेश शास्त्री', skills: 'काशी विद्वान, रुद्राभिषेक', rating: '4.8 ⭐', imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200'),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openBookingModal(VedicPujaItem puja) {
    String pujaMode = "online"; // 'online' or 'offline'
    String selectedPackageType = "परिवार संकल्प"; // 'एकल संकल्प', 'परिवार संकल्प', 'महा अनुष्ठान'
    String selectedSlot = puja.onlineSlots.first;
    // डिफ़ॉल्ट रूप से पहला उपलब्ध पंडित चुनें
    PanditProfile selectedPandit = puja.assignedPandits.isNotEmpty 
        ? puja.assignedPandits.first 
        : PanditProfile(name: 'मुख्य आचार्य', skills: 'वैदिक पंडित', rating: '5.0 ⭐', imageUrl: '');
    
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
            final currentPrice = puja.basePrice;

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

                          // 1.5 PANDIT SELECTION SECTION (कॉल/चैट स्क्रीन जैसी प्रोफाईल लिस्ट)
                          const Text(
                            "पूजन संपन्न करने हेतु आचार्य/पंडित चुनें (Select Pandit):",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            children: puja.assignedPandits.map((pandit) {
                              final isSelected = selectedPandit.name == pandit.name;
                              return GestureDetector(
                                onTap: () => setModalState(() => selectedPandit = pandit),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFFFFF7F0) : Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isSelected ? kPrimaryBhagwa : Colors.orange.shade200,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage: NetworkImage(pandit.imageUrl),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  pandit.name,
                                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  pandit.rating,
                                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              pandit.skills,
                                              style: const TextStyle(fontSize: 10, color: kSubTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Radio<String>(
                                        value: pandit.name,
                                        groupValue: selectedPandit.name,
                                        activeColor: kPrimaryBhagwa,
                                        onChanged: (val) => setModalState(() => selectedPandit = pandit),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
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
                                    "✨ चयनित पुरोहित जी लाइव वीडियो पर आपका नाम व गोत्र उच्चारित कर संकल्प करवाएंगे। पूजा उपरांत अभिमंत्रित भस्म, रक्षासूत्र व प्रसाद आपके पते पर भेजा जाएगा।",
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
                                      "📍 रिपोर्टिंग समय: पूजा से 30 मिनट पूर्व • चयनित आचार्य जी का संपर्क नंबर पास में मिलेगा।",
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
                                  price: puja.basePrice,
                                  desc: "1 व्यक्ति का नाम",
                                  isSelected: selectedPackageType == "एकल संकल्प",
                                  onTap: () => setModalState(() => selectedPackageType = "एकल संकल्प"),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: _buildPackageOption(
                                  title: "परिवार संकल्प",
                                  price: puja.basePrice,
                                  desc: "पूरे परिवार के नाम",
                                  isSelected: selectedPackageType == "परिवार संकल्प",
                                  onTap: () => setModalState(() => selectedPackageType = "परिवार संकल्प"),
                                  isPopular: true,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: _buildPackageOption(
                                  title: "महा अनुष्ठान",
                                  price: puja.basePrice,
                                  desc: "विशेष व्यक्तिगत हवन",
                                  isSelected: selectedPackageType == "महा अनुष्ठान",
                                  onTap: () => setModalState(() => selectedPackageType = "महा अनुष्ठान"),
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

                        // Insert to Supabase matching your database columns (`puja_title`, `temple_location`, `dakshina`, `puja_date`, `yajman_name`)
                        try {
                          final user = Supabase.instance.client.auth.currentUser;
                          await Supabase.instance.client.from('pooja_bookings').insert({
                            if (user != null) 'user_id': user.id,
                            'puja_title': puja.title,
                            'temple_location': puja.templeLocation,
                            'dakshina': numericDakshina,
                            'puja_date': puja.nextDate,
                            'yajman_name': yajmanName,
                            'user_phone': phone,
                            'mode': pujaMode == "online" ? "Online" : "Offline",
                            'sankalp_details': "गोत्र: $gotra | आचार्य: ${selectedPandit.name} | संकल्प: $sankalp",
                            'status': 'Confirmed',
                          });
                        } catch (e) {
                          debugPrint("Insert error: $e");
                        }

                        Navigator.pop(modalContext);
                        _showPujaSuccessDialog(
                          puja: puja,
                          mode: pujaMode,
                          price: currentPrice,
                          name: yajmanName,
                          gotra: gotra,
                          slotOrAddress: pujaMode == "online" ? selectedSlot : puja.templeAddress,
                          sankalp: sankalp,
                          panditName: selectedPandit.name,
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
    required String panditName,
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
                    _buildReceiptRow("चयनित आचार्य:", panditName),
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

              // यदि ऑनलाइन पूजा है तो "Go Live & Start Puja" बटन दिखाएं
              if (isOnline) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // डायलॉग बंद करें
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LivePujaVideoCallScreen(
                            pujaTitle: puja.title,
                            panditName: panditName,
                            slotTime: slotOrAddress,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.video_call_rounded, size: 20),
                    label: const Text("🎥 Go Live & Start Puja", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],

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

          // 3. Supabase FutureBuilder Listing
          Expanded(
            child: FutureBuilder<List<VedicPujaItem>>(
              future: _pujasFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: kPrimaryBhagwa));
                }
                
                final pujasList = snapshot.data ?? _fallbackPujasList;
                final query = _searchController.text.trim().toLowerCase();
                
                final filteredPujas = pujasList.where((puja) {
                  final matchesQuery = puja.title.toLowerCase().contains(query) ||
                      puja.deity.toLowerCase().contains(query) ||
                      puja.templeLocation.toLowerCase().contains(query);

                  if (!matchesQuery) return false;
                  if (_selectedCategory == "सभी") return true;
                  return puja.category == _selectedCategory;
                }).toList();

                if (filteredPujas.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text("कोई पूजा नहीं मिली!", style: TextStyle(fontSize: 14, color: kSubTextColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  itemCount: filteredPujas.length,
                  itemBuilder: (context, index) {
                    final puja = filteredPujas[index];
                    return _buildPujaCard(puja);
                  },
                );
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
                            Text(puja.basePrice, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
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

// लाइव वीडियो कॉल / स्ट्रीमिंग स्क्रीन
class LivePujaVideoCallScreen extends StatelessWidget {
  final String pujaTitle;
  final String panditName;
  final String slotTime;

  const LivePujaVideoCallScreen({
    super.key,
    required this.pujaTitle,
    required this.panditName,
    required this.slotTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pujaTitle, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),
            Text("आचार्य: $panditName • स्लॉट: $slotTime", style: const TextStyle(fontSize: 10, color: Colors.orangeAccent)),
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.live_tv_rounded, size: 72, color: Colors.orangeAccent),
                const SizedBox(height: 20),
                const Text(
                  "पंडित जी के साथ लाइव पूजा कनेक्ट हो रही है...\nकृपया अपने कैमरे और माइक की अनुमति दें।",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: "mic",
                  backgroundColor: Colors.white24,
                  onPressed: () {},
                  child: const Icon(Icons.mic_rounded, color: Colors.white),
                ),
                const SizedBox(width: 24),
                FloatingActionButton(
                  heroTag: "end_call",
                  backgroundColor: Colors.red,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(Icons.call_end_rounded, color: Colors.white),
                ),
                const SizedBox(width: 24),
                FloatingActionButton(
                  heroTag: "camera",
                  backgroundColor: Colors.white24,
                  onPressed: () {},
                  child: const Icon(Icons.videocam_rounded, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}