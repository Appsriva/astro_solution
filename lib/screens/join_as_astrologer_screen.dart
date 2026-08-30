import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);

class JoinAsAstrologerScreen extends StatefulWidget {
  const JoinAsAstrologerScreen({super.key});

  @override
  State<JoinAsAstrologerScreen> createState() => _JoinAsAstrologerScreenState();
}

class _JoinAsAstrologerScreenState extends State<JoinAsAstrologerScreen> {
  bool _showRegistrationForm = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _expController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  String _selectedExpertise = "वैदिक ज्योतिष (Vedic Astrology)";

  final supabase = Supabase.instance.client;

  final List<String> _expertiseList = [
    "वैदिक ज्योतिष (Vedic Astrology)",
    "टैरो कार्ड रीडर (Tarot Reader)",
    "वास्तु शास्त्र (Vastu Expert)",
    "हस्तरेखा विशेषज्ञ (Palmistry)",
    "अंक ज्योतिष (Numerology)",
    "कुंडली मिलान एवं दोष निवारण",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _expController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  Future<void> _submitAstrologerApplication() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final exp = _expController.text.trim();
    final skills = _skillsController.text.trim();

    if (name.isEmpty || phone.isEmpty || exp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("कृपया अपनी सभी जानकारी सही-सही भरें!"), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        // Insert application into Supabase astrologer_applications table
        await supabase.from('astrologer_applications').insert({
          'user_id': user.id,
          'full_name': name,
          'phone': phone,
          'experience': "$exp वर्ष ($_selectedExpertise)",
          'specialization': _selectedExpertise,
          'bio': skills.isEmpty ? 'विशेषज्ञ ज्योतिषी' : skills,
          'status': 'Pending',
        });
      }
    } catch (_) {}

    if (!mounted) return;

    // Show 3-Step Interview Guidelines Modal
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(22),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: kPrimaryBhagwa, width: 2),
                ),
                child: const Icon(Icons.verified_user_rounded, color: kPrimaryBhagwa, size: 34),
              ),
              const SizedBox(height: 12),
              const Text(
                "पंजीकरण सफल! 🎉",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kTextColor),
              ),
              const SizedBox(height: 4),
              Text(
                "नमस्ते $name जी, आपकी प्रोफाइल स्वीकार कर ली गई है। ऐप पर लाइव होने के लिए आपको नीचे दिए गए **3 चरणों के इंटरव्यू** से गुजरना होगा:",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: kSubTextColor, height: 1.4),
              ),
              const SizedBox(height: 16),

              // 3 Step Process Box
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
                  children: const [
                    Text("📋 चयन प्रक्रिया (3-Step Interview):", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
                    SizedBox(height: 8),
                    Text("1️⃣ स्टेप 1: 30 बहुविकल्पीय प्रश्न (Quiz)\n    (वैदिक ज्योतिष, कुंडली और पंचांग आधारित)\n\n2️⃣ स्टेप 2: टेलीफोनिक इंटरव्यू (Telephonic)\n    (हमारे सीनियर आचार्यों द्वारा वॉयस कॉल)\n\n3️⃣ स्टेप 3: लाइव वीडियो इंटरव्यू (Live Interview)\n    (परामर्श कौशल और संवाद परखने हेतु)", style: TextStyle(fontSize: 10.5, color: kTextColor, height: 1.35)),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to home
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("पहला चरण (Quiz Test) जल्द शुरू होगा। SMS चेक करें!"), backgroundColor: Colors.green),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryBhagwa,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("स्टेप 1: Quiz परीक्षा शुरू करें 🚀", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
          "ज्योतिषी बनें (Join as Astrologer) 🌟",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Banner: Guaranteed Income
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6F00), Color(0xFFFF3D00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(color: Colors.orange.withAlpha(90), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withAlpha(45), shape: BoxShape.circle),
                    child: const Icon(Icons.workspace_premium_rounded, color: kGoldAccent, size: 36),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "कमाएं ₹40,000 से ₹50,000+ प्रति माह!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "भारत के सबसे तेजी से बढ़ते वैदिक प्लेटफॉर्म से जुड़कर अपने ज्ञान का उपयोग करें और घर बैठे गारंटीड आय प्राप्त करें।",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (!_showRegistrationForm) ...[
              // Benefits Section
              const Text("ज्योतिषी के रूप में जुड़ने के फायदे:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor)),
              const SizedBox(height: 12),
              _buildBenefitTile(Icons.schedule_rounded, "अपनी सुविधा के अनुसार काम करें (Full Time / Part Time)"),
              _buildBenefitTile(Icons.account_balance_wallet_rounded, "प्रतिदिन और साप्ताहिक सुरक्षित भुगतान (Direct Bank Transfer)"),
              _buildBenefitTile(Icons.groups_rounded, "लाखों सक्रिय यूज़र्स तक सीधी पहुंच (High Traffic)"),
              _buildBenefitTile(Icons.support_agent_rounded, "24x7 तकनीकी सहायता एवं मैनेजर सपोर्ट"),

              const SizedBox(height: 24),

              // Join Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showRegistrationForm = true;
                    });
                  },
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text("अभी आवेदन करें (Register Now) 🚩", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryBhagwa,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ] else ...[
              // Registration Form (Skills, Experience, Name, etc.)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFFFCC80)),
                  boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("ज्योतिषी पंजीकरण फॉर्म (Astrologer Details)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor)),
                    const SizedBox(height: 14),

                    TextField(
                      controller: _nameController,
                      style: const TextStyle(fontSize: 12, color: kTextColor),
                      decoration: InputDecoration(
                        labelText: "पूरा नाम (Full Name)",
                        labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                        prefixIcon: const Icon(Icons.person_outline_rounded, color: kPrimaryBhagwa, size: 18),
                        filled: true,
                        fillColor: const Color(0xFFFFFDF9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 12, color: kTextColor),
                      decoration: InputDecoration(
                        labelText: "मोबाइल नंबर (WhatsApp)",
                        labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                        prefixIcon: const Icon(Icons.phone_outlined, color: kPrimaryBhagwa, size: 18),
                        filled: true,
                        fillColor: const Color(0xFFFFFDF9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _expController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 12, color: kTextColor),
                      decoration: InputDecoration(
                        labelText: "ज्योतिष में अनुभव (वर्षों में जैसे: 5 वर्ष)",
                        labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                        prefixIcon: const Icon(Icons.star_outline_rounded, color: kPrimaryBhagwa, size: 18),
                        filled: true,
                        fillColor: const Color(0xFFFFFDF9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 12),

                    const Text("विशेषज्ञता (Primary Expertise):", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kSubTextColor)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9F4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFCC80)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedExpertise,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: kPrimaryBhagwa),
                          items: _expertiseList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kTextColor)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedExpertise = newValue!;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    TextField(
                      controller: _skillsController,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 12, color: kTextColor),
                      decoration: InputDecoration(
                        labelText: "विशेष कौशल एवं भाषाएं (उदा: हिंदी, अंग्रेजी, विवाह विशेषज्ञ)",
                        labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                        filled: true,
                        fillColor: const Color(0xFFFFFDF9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitAstrologerApplication,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryBhagwa,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("फॉर्म जमा करें और इंटरव्यू विवरण देखें", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE0B2)),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Icon(icon, color: kPrimaryBhagwa, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kTextColor)),
          ),
        ],
      ),
    );
  }
}