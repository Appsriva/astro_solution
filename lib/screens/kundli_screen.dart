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

class KundliScreen extends StatefulWidget {
  const KundliScreen({super.key});

  @override
  State<KundliScreen> createState() => _KundliScreenState();
}

class _KundliScreenState extends State<KundliScreen> {
  final TextEditingController _nameController = TextEditingController(text: "आफ़ताब");
  final TextEditingController _placeController = TextEditingController(text: "नई दिल्ली, भारत");
  DateTime _selectedDate = DateTime(2001, 5, 19);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 30);
  String _selectedGender = "पुरुष (Male)";

  bool _isGenerated = false;

  void _generateKundli() {
    if (_nameController.text.trim().isEmpty || _placeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("कृपया सभी विवरण भरें!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    setState(() {
      _isGenerated = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _placeController.dispose();
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
          "वैदिक जन्म कुंडली 🕉️",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: kTextColor),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isGenerated) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.shade100),
                  boxShadow: kCardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "जन्म विवरण दर्ज करें (Birth Details)",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor),
                    ),
                    const SizedBox(height: 14),
                    _buildTextField("पूरा नाम (Full Name)", _nameController, Icons.person_outline_rounded),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildGenderChip("पुरुष (Male)"),
                        const SizedBox(width: 8),
                        _buildGenderChip("महिला (Female)"),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => _selectedDate = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFDF9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade100),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded, color: kPrimaryBhagwa, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              "जन्म तिथि: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                              style: const TextStyle(fontSize: 13, color: kTextColor, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (picked != null) {
                          setState(() => _selectedTime = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFDF9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade100),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_rounded, color: kPrimaryBhagwa, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              "जन्म समय: ${_selectedTime.format(context)}",
                              style: const TextStyle(fontSize: 13, color: kTextColor, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField("जन्म स्थान (Birth City)", _placeController, Icons.location_on_outlined),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _generateKundli,
                        icon: const Icon(Icons.auto_awesome, size: 18),
                        label: const Text("मुफ़्त संपूर्ण कुंडली बनाएं", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryBhagwa,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_nameController.text.trim()} की कुंडली 🚩",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kTextColor),
                      ),
                      Text(
                        "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} • ${_selectedTime.format(context)}",
                        style: const TextStyle(fontSize: 11, color: kSubTextColor),
                      ),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () => setState(() => _isGenerated = false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kPrimaryBhagwa,
                      side: const BorderSide(color: kPrimaryBhagwa),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                    child: const Text("बदलें", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
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
                    _buildSummaryRow("लग्न (Ascendant)", "सिंह लग्न (Leo)", "राशि (Moon Sign)", "कर्क राशि (Cancer)"),
                    const Divider(height: 16),
                    _buildSummaryRow("नक्षत्र (Nakshatra)", "पुष्य (चरण 3)", "सूर्य राशि (Sun Sign)", "वृषभ (Taurus)"),
                    const Divider(height: 16),
                    _buildSummaryRow("वर्ण / गण", "विप्र / देव गण", "महादशा", "बृहस्पति (गुरु)"),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text("लग्न चक्र (Lagna Chart)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6ED),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.orange.shade300, width: 1.5),
                  boxShadow: kCardShadow,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kPrimaryBhagwa),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                border: Border.all(color: kPrimaryBhagwa.withValues(alpha: 0.5)),
                              ),
                            ),
                          ),
                          _buildHousePlanet(Alignment.topCenter, "1st House (Lagna)\n[सूर्य, बुध]"),
                          _buildHousePlanet(Alignment.topLeft, "12th (व्यय)\n[शुक्र]"),
                          _buildHousePlanet(Alignment.topRight, "2nd (धन)\n[गुरु]"),
                          _buildHousePlanet(Alignment.centerLeft, "10th (कर्म)\n[मंगल]"),
                          _buildHousePlanet(Alignment.centerRight, "4th (सुख)\n[चंद्र]"),
                          _buildHousePlanet(Alignment.bottomCenter, "7th (विवाह)\n[शनि]"),
                          _buildHousePlanet(Alignment.bottomLeft, "8th (आयु)\n[राहु]"),
                          _buildHousePlanet(Alignment.bottomRight, "6th (शत्रु)\n[केतु]"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "वैदिक उत्तर-भारतीय कुंडली चक्र (North-Indian Chart)",
                      style: TextStyle(fontSize: 10, color: kSubTextColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text("ग्रह स्थिति (Planetary Details)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade100),
                  boxShadow: kCardShadow,
                ),
                child: Column(
                  children: [
                    _buildPlanetRow("सूर्य (Sun)", "वृषभ (Taurus)", "14° 22'", "शुभ (Friendly)"),
                    const Divider(height: 1),
                    _buildPlanetRow("चंद्र (Moon)", "कर्क (Cancer)", "08° 15'", "स्वग्रही (Own Sign)"),
                    const Divider(height: 1),
                    _buildPlanetRow("मंगल (Mars)", "मेष (Aries)", "22° 40'", "उच्च (Exalted)"),
                    const Divider(height: 1),
                    _buildPlanetRow("बुध (Mercury)", "मिथुन (Gemini)", "11° 05'", "शुभ (Strong)"),
                    const Divider(height: 1),
                    _buildPlanetRow("गुरु (Jupiter)", "सिंह (Leo)", "19° 50'", "मित्र (Friendly)"),
                    const Divider(height: 1),
                    _buildPlanetRow("शनि (Saturn)", "कुंभ (Aquarius)", "04° 12'", "मूलत्रिकोण"),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text("कुंडली दोष विश्लेषण (Dosha Report)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
              const SizedBox(height: 8),
              _buildDoshaCard("मांगलिक दोष (Mangal Dosha)", "आंशिक मांगलिक (28 वर्ष बाद प्रभाव कम)", Colors.orange),
              const SizedBox(height: 8),
              _buildDoshaCard("कालसर्प योग (Kaal Sarp)", "दोष मुक्त (कुंडली में कालसर्प नहीं है)", Colors.green),
              const SizedBox(height: 8),
              _buildDoshaCard("शनि साढ़ेसाती (Sade Sati)", "वर्तमान में कोई साढ़ेसाती का प्रभाव नहीं", Colors.blue),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 13, color: kTextColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kSubTextColor, fontSize: 12),
        prefixIcon: Icon(icon, color: kPrimaryBhagwa, size: 20),
        filled: true,
        fillColor: const Color(0xFFFFFDF9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.orange.shade100)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.orange.shade100)),
        focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: kPrimaryBhagwa, width: 1.5)),
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildGenderChip(String label) {
    final isSelected = _selectedGender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFF0E6) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? kPrimaryBhagwa : Colors.orange.shade100, width: isSelected ? 1.5 : 1),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? kPrimaryBhagwa : kTextColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String t1, String v1, String t2, String v2) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t1, style: const TextStyle(fontSize: 10, color: kSubTextColor)),
              Text(v1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t2, style: const TextStyle(fontSize: 10, color: kSubTextColor)),
              Text(v2, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHousePlanet(Alignment align, String text) {
    return Align(
      alignment: align,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF2E1500)),
        ),
      ),
    );
  }

  Widget _buildPlanetRow(String planet, String rashi, String degree, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(planet, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
          Text(rashi, style: const TextStyle(fontSize: 11, color: kSubTextColor)),
          Text(degree, style: const TextStyle(fontSize: 11, color: kTextColor, fontWeight: FontWeight.w600)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0E6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(status, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
          ),
        ],
      ),
    );
  }

  Widget _buildDoshaCard(String title, String status, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.shade100),
        boxShadow: kCardShadow,
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                Text(status, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}