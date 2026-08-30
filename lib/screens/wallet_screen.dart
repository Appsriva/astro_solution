import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Brand Color Constants
const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);

class WalletPackage {
  final String id;
  final String price;
  final int amount;
  final String duration;
  final String durationHi;
  final String badge;
  final String extraBenefit;
  final bool isPopular;

  const WalletPackage({
    required this.id,
    required this.price,
    required this.amount,
    required this.duration,
    required this.durationHi,
    required this.badge,
    required this.extraBenefit,
    this.isPopular = false,
  });
}

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  // Default selected package is the ₹155 pack
  int _selectedPackageIndex = 1;

  // Supabase Realtime Variables
  final supabase = Supabase.instance.client;
  double _currentBalance = 50.00;
  bool _isLoading = false;
  StreamSubscription? _profileSubscription;

  // 5 Distinct Astrological Packages
  static const List<WalletPackage> _packages = [
    WalletPackage(
      id: "pkg_50",
      price: "₹50",
      amount: 50,
      duration: "10 Mins Talktime",
      durationHi: "10 मिनट परामर्श",
      badge: "STARTER",
      extraBenefit: "+ ₹20 एक्स्ट्रा कैशबैक",
    ),
    WalletPackage(
      id: "pkg_155",
      price: "₹155",
      amount: 155,
      duration: "30 Mins Talktime",
      durationHi: "30 मिनट तक बात होगी",
      badge: "MOST POPULAR 🔥",
      extraBenefit: "करियर व विवाह पर सटीक उपाय",
      isPopular: true,
    ),
    WalletPackage(
      id: "pkg_299",
      price: "₹299",
      amount: 299,
      duration: "60 Mins Talktime",
      durationHi: "60 मिनट (1 घंटा) बात होगी",
      badge: "BEST VALUE ✨",
      extraBenefit: "संपूर्ण कुंडली दोष निवारण",
    ),
    WalletPackage(
      id: "pkg_555",
      price: "₹555",
      amount: 555,
      duration: "Unlimited Session",
      durationHi: "अनलिमिटेड बात होगी (नो टाइम लिमिट)",
      badge: "UNLIMITED PACK 🔱",
      extraBenefit: "पूरा परिवार परामर्श + उपाय",
    ),
    WalletPackage(
      id: "pkg_1100",
      price: "₹1,100",
      amount: 1100,
      duration: "150 Mins + VIP",
      durationHi: "150 मिनट बात + VIP प्रायोरिटी",
      badge: "VIP MAHA PACK 👑",
      extraBenefit: "फ्री जन्मपत्रिका PDF रिपोर्ट",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchLiveBalance();
  }

  void _fetchLiveBalance() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      _profileSubscription = supabase
          .from('profiles')
          .stream(primaryKey: ['id'])
          .eq('id', user.id)
          .listen((List<Map<String, dynamic>> data) {
        if (data.isNotEmpty && mounted) {
          setState(() {
            _currentBalance = (data.first['wallet_balance'] ?? 50.0).toDouble();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    super.dispose();
  }

  Future<void> _processRecharge(WalletPackage pkg) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final double updatedBalance = _currentBalance + pkg.amount;

      // 1. Update balance in profiles table
      await supabase.from('profiles').update({
        'wallet_balance': updatedBalance,
      }).eq('id', user.id);

      // 2. Insert record in wallet_transactions table (Added credit entry for history)
      await supabase.from('wallet_transactions').insert({
        'user_id': user.id,
        'amount': pkg.amount,
        'type': 'credit',
        'description': "वॉलेट ऑनलाइन रिचार्ज (${pkg.badge} - ${pkg.price})",
      });

      if (!mounted) return;
      setState(() => _isLoading = false);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.shade300, width: 2),
                ),
                child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 38),
              ),
              const SizedBox(height: 12),
              const Text(
                "रिचार्ज सफल रहा! 🎉",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: kTextColor),
              ),
              const SizedBox(height: 6),
              Text(
                "${pkg.price} आपके वॉलेट में सफलतापूर्वक जोड़ दिए गए हैं।",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: kSubTextColor),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9F4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFCC80)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("नया बैलेंस:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kSubTextColor)),
                    Text("₹${updatedBalance.toStringAsFixed(2)}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryBhagwa,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  child: const Text("ठीक है", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("रिचार्ज में समस्या आई: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = kPrimaryBhagwa.withValues(alpha: 0.15);
    final selectedPkg = _packages[_selectedPackageIndex];

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kTextColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "वॉलेट एवं रिचार्ज (Recharge)",
          style: TextStyle(color: kTextColor, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.lock_outline_rounded, color: Colors.green, size: 13),
                SizedBox(width: 3),
                Text(
                  "100% Safe",
                  style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Current Balance Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kPrimaryBhagwa, kDeepSaffron],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryBhagwa.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "उपलब्ध बैलेंस (Available Balance)",
                              style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "₹${_currentBalance.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_rounded,
                            color: kGoldAccent,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // 2. Section Heading
                  Row(
                    children: const [
                      Icon(Icons.stars_rounded, color: kPrimaryBhagwa, size: 20),
                      SizedBox(width: 6),
                      Text(
                        "रिचार्ज पैकेज चुनें (Select Package)",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 3. 5 Packages Cards List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _packages.length,
                    itemBuilder: (context, index) {
                      final pkg = _packages[index];
                      final isSelected = _selectedPackageIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPackageIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFFFF8F0) : kCardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected ? kPrimaryBhagwa : borderColor,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? kPrimaryBhagwa.withValues(alpha: 0.12)
                                    : Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Radio Selector Icon
                              Icon(
                                isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
                                color: isSelected ? kPrimaryBhagwa : Colors.grey.shade400,
                                size: 22,
                              ),
                              const SizedBox(width: 12),

                              // Package Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          pkg.price,
                                          style: const TextStyle(
                                            color: kTextColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: pkg.isPopular
                                                ? Colors.red.shade50
                                                : kPrimaryBhagwa.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            pkg.badge,
                                            style: TextStyle(
                                              color: pkg.isPopular ? Colors.red.shade700 : kPrimaryBhagwa,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.timer_outlined, size: 14, color: Color(0xFFE65100)),
                                        const SizedBox(width: 4),
                                        Text(
                                          pkg.durationHi,
                                          style: const TextStyle(
                                            color: Color(0xFFE65100),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      pkg.extraBenefit,
                                      style: const TextStyle(color: kSubTextColor, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),

                              // Call/Chat Icon Tag
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? kPrimaryBhagwa.withValues(alpha: 0.15)
                                      : Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.phone_in_talk_rounded,
                                  size: 18,
                                  color: isSelected ? kPrimaryBhagwa : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  // 4. Payment Modes Strip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.payment_rounded, color: kPrimaryBhagwa, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "UPI (GPay / PhonePe / Paytm), Cards",
                              style: TextStyle(color: kTextColor, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const Icon(Icons.verified_user_rounded, color: Colors.green, size: 16),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // 5. Fixed Bottom Add Money Button Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: borderColor)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "कुल राशि (Total)",
                      style: TextStyle(color: kSubTextColor, fontSize: 11),
                    ),
                    Text(
                      selectedPkg.price,
                      style: const TextStyle(
                        color: kTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _processRecharge(selectedPkg),
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.add_card_rounded, size: 18),
                    label: Text(
                      _isLoading ? "प्रोसेस हो रहा है..." : "Add Money in Wallet",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBhagwa,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}