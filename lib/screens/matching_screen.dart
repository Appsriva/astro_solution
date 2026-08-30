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

class AshtakootItem {
  final String name;
  final String description;
  final double received;
  final double total;

  const AshtakootItem({
    required this.name,
    required this.description,
    required this.received,
    required this.total,
  });
}

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  // Boy details
  final TextEditingController _boyNameController = TextEditingController(text: "रोहित शर्मा");
  final TextEditingController _boyPlaceController = TextEditingController(text: "नई दिल्ली");
  DateTime _boyDob = DateTime(1998, 8, 15);
  TimeOfDay _boyTob = const TimeOfDay(hour: 10, minute: 30);

  // Girl details
  final TextEditingController _girlNameController = TextEditingController(text: "पूजा वर्मा");
  final TextEditingController _girlPlaceController = TextEditingController(text: "जयपुर");
  DateTime _girlDob = DateTime(2000, 11, 24);
  TimeOfDay _girlTob = const TimeOfDay(hour: 14, minute: 15);

  bool _isMatched = false;

  static const List<AshtakootItem> _ashtakootList = [
    AshtakootItem(name: "वर्ण (Varna)", description: "कार्य प्रवृत्ति एवं सामाजिक सामंजस्य", received: 1.0, total: 1.0),
    AshtakootItem(name: "वश्य (Vashya)", description: "पारस्परिक आकर्षण एवं प्रभुत्व", received: 2.0, total: 2.0),
    AshtakootItem(name: "तारा (Tara)", description: "भाग्य, स्वास्थ्य एवं दीर्घायु", received: 1.5, total: 3.0),
    AshtakootItem(name: "योनि (Yoni)", description: "शारीरिक व मानसिक अनुकूलता", received: 4.0, total: 4.0),
    AshtakootItem(name: "ग्रह मैत्री (Maitri)", description: "मानसिक तालमेल एवं मित्रता", received: 5.0, total: 5.0),
    AshtakootItem(name: "गण (Gana)", description: "स्वभाव एवं व्यवहार अनुकूलता", received: 5.0, total: 6.0),
    AshtakootItem(name: "भकूट (Bhakoot)", description: "पारिवारिक समृद्धि एवं वंश वृद्धि", received: 7.0, total: 7.0),
    AshtakootItem(name: "नाड़ी (Nadi)", description: "स्वास्थ्य, आनुवंशिकी एवं संतान सुख", received: 4.0, total: 8.0),
  ];

  void _calculateMatch() {
    if (_boyNameController.text.trim().isEmpty || _girlNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("कृपया वर और वधू दोनों का नाम भरें!"), backgroundColor: Colors.redAccent),
      );
      return;
    }
    setState(() {
      _isMatched = true;
    });
  }

  @override
  void dispose() {
    _boyNameController.dispose();
    _boyPlaceController.dispose();
    _girlNameController.dispose();
    _girlPlaceController.dispose();
    super.dispose();
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
          "कुंडली एवं गुण मिलान 💑",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: kTextColor),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isMatched) ...[
              // Boy Details Card
              _buildPersonForm(
                title: "वर का विवरण (Boy's Details) 🤵",
                color: Colors.blue.shade700,
                nameController: _boyNameController,
                placeController: _boyPlaceController,
                dob: _boyDob,
                tob: _boyTob,
                onDatePick: (dt) => setState(() => _boyDob = dt),
                onTimePick: (tm) => setState(() => _boyTob = tm),
              ),

              const SizedBox(height: 16),

              // Girl Details Card
              _buildPersonForm(
                title: "वधू का विवरण (Girl's Details) 👰",
                color: Colors.pink.shade700,
                nameController: _girlNameController,
                placeController: _girlPlaceController,
                dob: _girlDob,
                tob: _girlTob,
                onDatePick: (dt) => setState(() => _girlDob = dt),
                onTimePick: (tm) => setState(() => _girlTob = tm),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _calculateMatch,
                  icon: const Icon(Icons.favorite_rounded, size: 20),
                  label: const Text("36 गुण मिलान रिपोर्ट देखें", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryBhagwa,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ] else ...[
              // Match Result Dashboard
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_boyNameController.text.trim()} ❤️ ${_girlNameController.text.trim()}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
                      ),
                      const Text("अष्टकूट 36 गुण मिलान परिणाम", style: TextStyle(fontSize: 11, color: kSubTextColor)),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () => setState(() => _isMatched = false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kPrimaryBhagwa,
                      side: const BorderSide(color: kPrimaryBhagwa),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    child: const Text("पुनः मिलान", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Total Score Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2C1304), Color(0xFF4A1F05)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kGoldAccent.withValues(alpha: 0.6)),
                  boxShadow: kCardShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: kGoldAccent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: kGoldAccent, width: 2),
                      ),
                      child: const Center(
                        child: Text(
                          "29.5\n/ 36",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: kGoldAccent, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("अति उत्तम एवं शुभ मिलान 🌟", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 3),
                          Text(
                            "18 से अधिक गुण मिलने पर विवाह शास्त्रसम्मत माना जाता है। दोनों का वैवाहिक जीवन अत्यंत सुखमय रहेगा।",
                            style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Manglik Match Analysis
              const Text("मांगलिक दोष मिलान (Mangal Dosha)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
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
                          Text("वर (Boy)", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                          SizedBox(height: 2),
                          Text("मांगलिक दोष मुक्त ✅", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
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
                          Text("वधू (Girl)", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                          SizedBox(height: 2),
                          Text("मांगलिक दोष मुक्त ✅", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Ashtakoot Breakdown Table
              const Text("36 गुणों का अष्टकूट विवरण", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.orange.shade100),
                  boxShadow: kCardShadow,
                ),
                child: Column(
                  children: _ashtakootList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor)),
                                    Text(item.description, style: const TextStyle(fontSize: 10, color: kSubTextColor)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: item.received >= (item.total / 2) ? const Color(0xFFFFF0E6) : Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${item.received.toStringAsFixed(1)} / ${item.total.toStringAsFixed(0)}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: item.received >= (item.total / 2) ? kPrimaryBhagwa : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (index < _ashtakootList.length - 1) const Divider(height: 1),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPersonForm({
    required String title,
    required Color color,
    required TextEditingController nameController,
    required TextEditingController placeController,
    required DateTime dob,
    required TimeOfDay tob,
    required ValueChanged<DateTime> onDatePick,
    required ValueChanged<TimeOfDay> onTimePick,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange.shade100),
        boxShadow: kCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 10),
          TextField(
            controller: nameController,
            style: const TextStyle(fontSize: 12, color: kTextColor),
            decoration: InputDecoration(
              labelText: "नाम (Full Name)",
              prefixIcon: const Icon(Icons.person_outline_rounded, size: 18, color: kPrimaryBhagwa),
              filled: true,
              fillColor: const Color(0xFFFFFDF9),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.orange.shade100)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.orange.shade100)),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: dob,
                      firstDate: DateTime(1960),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) onDatePick(picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDF9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange.shade100),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded, color: kPrimaryBhagwa, size: 16),
                        const SizedBox(width: 6),
                        Text("${dob.day}/${dob.month}/${dob.year}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kTextColor)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showTimePicker(context: context, initialTime: tob);
                    if (picked != null) onTimePick(picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDF9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange.shade100),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_rounded, color: kPrimaryBhagwa, size: 16),
                        const SizedBox(width: 6),
                        Text(tob.format(context), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kTextColor)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: placeController,
            style: const TextStyle(fontSize: 12, color: kTextColor),
            decoration: InputDecoration(
              labelText: "जन्म स्थान (Birth City)",
              prefixIcon: const Icon(Icons.location_on_outlined, size: 18, color: kPrimaryBhagwa),
              filled: true,
              fillColor: const Color(0xFFFFFDF9),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.orange.shade100)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.orange.shade100)),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }
}