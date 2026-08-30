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

class ChoghadiyaItem {
  final String name;
  final String time;
  final String type; // 'शुभ', 'मध्यम', 'अशुभ'
  final Color color;

  const ChoghadiyaItem({
    required this.name,
    required this.time,
    required this.type,
    required this.color,
  });
}

class PanchangScreen extends StatefulWidget {
  const PanchangScreen({super.key});

  @override
  State<PanchangScreen> createState() => _PanchangScreenState();
}

class _PanchangScreenState extends State<PanchangScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedChoghadiyaTab = "दिन का चौघड़िया";

  static const List<ChoghadiyaItem> _dayChoghadiya = [
    ChoghadiyaItem(name: "शुभ (Shubh)", time: "06:05 AM - 07:38 AM", type: "अति शुभ", color: Colors.green),
    ChoghadiyaItem(name: "रोग (Rog)", time: "07:38 AM - 09:12 AM", type: "अशुभ (त्याज्य)", color: Colors.red),
    ChoghadiyaItem(name: "उद्वेग (Udveg)", time: "09:12 AM - 10:45 AM", type: "अशुभ", color: Colors.red),
    ChoghadiyaItem(name: "चल (Chal)", time: "10:45 AM - 12:18 PM", type: "सामान्य शुभ", color: Colors.blue),
    ChoghadiyaItem(name: "लाभ (Labh)", time: "12:18 PM - 01:52 PM", type: "अति शुभ (उन्नति)", color: Colors.green),
    ChoghadiyaItem(name: "अमृत (Amrit)", time: "01:52 PM - 03:25 PM", type: "सर्वोत्तम मुहूर्त", color: Colors.green),
    ChoghadiyaItem(name: "काल (Kaal)", time: "03:25 PM - 04:58 PM", type: "हानिकारक (अशुभ)", color: Colors.red),
    ChoghadiyaItem(name: "शुभ (Shubh)", time: "04:58 PM - 06:32 PM", type: "अति शुभ", color: Colors.green),
  ];

  static const List<ChoghadiyaItem> _nightChoghadiya = [
    ChoghadiyaItem(name: "अमृत (Amrit)", time: "06:32 PM - 07:58 PM", type: "सर्वोत्तम", color: Colors.green),
    ChoghadiyaItem(name: "चल (Chal)", time: "07:58 PM - 09:25 PM", type: "सामान्य", color: Colors.blue),
    ChoghadiyaItem(name: "रोग (Rog)", time: "09:25 PM - 10:51 PM", type: "अशुभ", color: Colors.red),
    ChoghadiyaItem(name: "काल (Kaal)", time: "10:51 PM - 12:18 AM", type: "अशुभ", color: Colors.red),
    ChoghadiyaItem(name: "लाभ (Labh)", time: "12:18 AM - 01:44 AM", type: "शुभ", color: Colors.green),
    ChoghadiyaItem(name: "उद्वेग (Udveg)", time: "01:44 AM - 03:11 AM", type: "अशुभ", color: Colors.red),
    ChoghadiyaItem(name: "शुभ (Shubh)", time: "03:11 AM - 04:38 AM", type: "अति शुभ", color: Colors.green),
    ChoghadiyaItem(name: "अमृत (Amrit)", time: "04:38 AM - 06:05 AM", type: "सर्वोत्तम", color: Colors.green),
  ];

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeChoghadiya = _selectedChoghadiyaTab == "दिन का चौघड़िया"
        ? _dayChoghadiya
        : _nightChoghadiya;

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
          "दैनिक पंचांग एवं चौघड़िया 🕉️",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: kTextColor),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Date Selector Bar with Previous/Next Arrows
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade100),
                boxShadow: kCardShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded, size: 18, color: kPrimaryBhagwa),
                    onPressed: () => _changeDate(-1),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) setState(() => _selectedDate = picked);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded, color: kPrimaryBhagwa, size: 20),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor),
                            ),
                            const Text("नई दिल्ली, भारत 📍", style: TextStyle(fontSize: 10, color: kSubTextColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: kPrimaryBhagwa),
                    onPressed: () => _changeDate(1),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 2. Sun & Moon Timing Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2C1304), Color(0xFF4A1F05)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kGoldAccent.withValues(alpha: 0.6)),
                boxShadow: kCardShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSunMoonCol(Icons.wb_sunny_rounded, "सूर्योदय", "06:05 AM", kGoldAccent),
                  Container(height: 36, width: 1, color: Colors.white24),
                  _buildSunMoonCol(Icons.nights_stay_rounded, "सूर्यास्त", "06:32 PM", Colors.orangeAccent),
                  Container(height: 36, width: 1, color: Colors.white24),
                  _buildSunMoonCol(Icons.brightness_3_rounded, "चंद्रोदय", "04:15 PM", Colors.lightBlueAccent),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. Main Panchang Elements (पंचांग के पांच अंग)
            const Text("पंचांग विवरण (Panchang Details)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade100),
                boxShadow: kCardShadow,
              ),
              child: Column(
                children: [
                  _buildPanchangRow("तिथि (Tithi)", "शुक्ल पक्ष त्रयोदशी (रात 09:40 तक)", "वार (Day)", "गुरुवार (Thursday)"),
                  const Divider(height: 16),
                  _buildPanchangRow("नक्षत्र (Nakshatra)", "पुष्य (दोपहर 01:15 तक)", "योग (Yoga)", "शोभन योग (शाम 05:22 तक)"),
                  const Divider(height: 16),
                  _buildPanchangRow("करण (Karana)", "तैतिल (सुबह 10:10 तक)", "पक्ष / संवत", "शुक्ल पक्ष / विक्रम 2083"),
                  const Divider(height: 16),
                  _buildPanchangRow("सूर्य राशि", "सिंह (Leo)", "चंद्र राशि", "कर्क (Cancer)"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. Shubh & Ashubh Muhurat
            const Text("शुभ एवं अशुभ काल (Auspicious & Inauspicious)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                            SizedBox(width: 4),
                            Text("शुभ मुहूर्त ✅", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text("अभिजीत मुहूर्त:", style: TextStyle(fontSize: 10, color: kSubTextColor)),
                        Text("11:52 AM - 12:44 PM", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kTextColor)),
                        SizedBox(height: 4),
                        Text("विजय मुहूर्त:", style: TextStyle(fontSize: 10, color: kSubTextColor)),
                        Text("02:28 PM - 03:20 PM", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kTextColor)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.cancel_rounded, color: Colors.red, size: 16),
                            SizedBox(width: 4),
                            Text("अशुभ काल ❌", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11)),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text("राहुकाल (त्याज्य):", style: TextStyle(fontSize: 10, color: kSubTextColor)),
                        Text("01:52 PM - 03:25 PM", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red)),
                        SizedBox(height: 4),
                        Text("यमगंड काल:", style: TextStyle(fontSize: 10, color: kSubTextColor)),
                        Text("06:05 AM - 07:38 AM", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kTextColor)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // 5. Choghadiya Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("आज का चौघड़िया (Choghadiya)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
                Row(
                  children: [
                    _buildChoghadiyaTabChip("दिन का चौघड़िया"),
                    const SizedBox(width: 6),
                    _buildChoghadiyaTabChip("रात का चौघड़िया"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade100),
                boxShadow: kCardShadow,
              ),
              child: Column(
                children: activeChoghadiya.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item.name,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor),
                                ),
                              ],
                            ),
                            Text(
                              item.time,
                              style: const TextStyle(fontSize: 11, color: kSubTextColor, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: item.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.type,
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: item.color),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index < activeChoghadiya.length - 1) const Divider(height: 1),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSunMoonCol(IconData icon, String title, String time, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        Text(time, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPanchangRow(String t1, String v1, String t2, String v2) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t1, style: const TextStyle(fontSize: 10, color: kSubTextColor)),
              const SizedBox(height: 2),
              Text(v1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t2, style: const TextStyle(fontSize: 10, color: kSubTextColor)),
              const SizedBox(height: 2),
              Text(v2, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChoghadiyaTabChip(String label) {
    final isSelected = _selectedChoghadiyaTab == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedChoghadiyaTab = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryBhagwa : const Color(0xFFFFF0E6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label.replaceAll(" का चौघड़िया", ""),
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : kPrimaryBhagwa,
          ),
        ),
      ),
    );
  }
}