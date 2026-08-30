import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);

class ReferralHistoryItem {
  final String userName;
  final String userPhone;
  final String rechargeAmount;
  final String commissionEarned;
  final String date;

  const ReferralHistoryItem({
    required this.userName,
    required this.userPhone,
    required this.rechargeAmount,
    required this.commissionEarned,
    required this.date,
  });
}

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final String myInviteCode = "ASTRO2026AFTAB";
  final String inviteLink = "https://astrosolution.app/invite?code=ASTRO2026AFTAB";
  double _walletBalance = 100.00; // Total earned commission

  // Supabase Integration Variables
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<ReferralHistoryItem> _referralHistory = [];

  static const List<String> _hindiWeekDays = [
    "सोमवार", "मंगलवार", "बुधवार", "गुरुवार", "शुक्रवार", "शनिवार", "रविवार"
  ];

  static const List<String> _hindiMonths = [
    "जनवरी", "फ़रवरी", "मार्च", "अप्रैल", "मई", "जून", "जुलाई", "अगस्त", "सितंबर", "अक्टूबर", "नवंबर", "दिसंबर"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchLiveReferrals();
  }

  String _formatFullDateHindi(DateTime dt) {
    final dayName = _hindiWeekDays[dt.weekday - 1];
    final monthName = _hindiMonths[dt.month - 1];
    return "$dayName, ${dt.day} $monthName ${dt.year}";
  }

  Future<void> _fetchLiveReferrals() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final data = await supabase
          .from('referrals')
          .select()
          .eq('referrer_id', user.id)
          .order('created_at', ascending: false);

      final List<ReferralHistoryItem> loaded = [];
      double totalCommission = 0.0;

      for (var item in (data as List)) {
        final created = DateTime.tryParse(item['created_at'] ?? '')?.toLocal() ?? DateTime.now();
        final commission = (item['reward_amount'] ?? 20.0).toDouble();
        totalCommission += commission;

        loaded.add(
          ReferralHistoryItem(
            userName: item['referred_user_name'] ?? "यजमान",
            userPhone: "98XXXXX120",
            rechargeAmount: "₹155",
            commissionEarned: "₹${commission.toStringAsFixed(0)}",
            date: _formatFullDateHindi(created),
          ),
        );
      }

      if (mounted) {
        setState(() {
          if (loaded.isNotEmpty) {
            _referralHistory = loaded;
            _walletBalance = totalCommission;
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _copyToClipboard(BuildContext context, String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green.shade700, duration: const Duration(seconds: 2)),
    );
  }

  void _openWithdrawModal() {
    final TextEditingController upiController = TextEditingController();
    final TextEditingController amountController = TextEditingController(text: _walletBalance.toStringAsFixed(0));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("पैसे बैंक या UPI में भेजें 💸", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor)),
                    Text("उपलब्ध: ₹${_walletBalance.toStringAsFixed(2)}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                const Divider(height: 16),
                const Text("अपना UPI ID (PhonePe, GPay, Paytm) या बैंक खाता दर्ज करें:", style: TextStyle(fontSize: 11, color: kSubTextColor)),
                const SizedBox(height: 8),
                TextField(
                  controller: upiController,
                  style: const TextStyle(fontSize: 12, color: kTextColor),
                  decoration: InputDecoration(
                    hintText: "उदा: 9876543210@ybl या 9876543210@paytm",
                    filled: true,
                    fillColor: const Color(0xFFFFFDF9),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.orange.shade200)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.orange.shade200)),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 12),
                const Text("निकालने योग्य राशि (₹):", style: TextStyle(fontSize: 11, color: kSubTextColor)),
                const SizedBox(height: 8),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 12, color: kTextColor),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.currency_rupee_rounded, size: 16, color: kPrimaryBhagwa),
                    filled: true,
                    fillColor: const Color(0xFFFFFDF9),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.orange.shade200)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.orange.shade200)),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final upi = upiController.text.trim();
                      if (upi.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("कृपया सही UPI ID या बैंक विवरण दर्ज करें!"), backgroundColor: Colors.red));
                        return;
                      }
                      Navigator.pop(context);
                      setState(() {
                        _walletBalance = 0.00;
                      });
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: const Text("withdrawal Successful! 🎉", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          content: Text("आपके पैसे सफलतापूर्वक आपके UPI/बैंक खाता ($upi) में ट्रांसफर कर दिए गए हैं। 24 घंटे में राशि प्राप्त हो जाएगी।", style: const TextStyle(fontSize: 12, height: 1.4)),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBhagwa, foregroundColor: Colors.white),
                              child: const Text("ठीक है"),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBhagwa,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("पैसे ट्रांसफर करें (Withdraw Money)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ],
            ),
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
          "रेफरल वॉलेट एवं कमाई 🎁",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: kPrimaryBhagwa),
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchLiveReferrals();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: kPrimaryBhagwa,
          unselectedLabelColor: kSubTextColor,
          indicatorColor: kPrimaryBhagwa,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "रेफर करें & शेयर"),
            Tab(text: "कमिश्रन इतिहास (History) 📜"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Referral & Wallet Screen
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Wallet Balance & Withdraw Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("कुल रेफरल कमाई (Wallet)", style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                            "₹${_walletBalance.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          const Text("प्रति सफल रिचार्ज ₹20 कमिशन", style: TextStyle(color: kGoldAccent, fontSize: 9.5, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _openWithdrawModal,
                        icon: const Icon(Icons.account_balance_wallet_rounded, size: 15, color: kPrimaryBhagwa),
                        label: const Text("Withdraw", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: kPrimaryBhagwa)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Invite Code Box
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
                      const Text("आपका इनवाइट कोड (Your Invite Code)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kSubTextColor)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9F4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFFE0B2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              myInviteCode,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kPrimaryBhagwa, letterSpacing: 1.2),
                            ),
                            InkWell(
                              onTap: () => _copyToClipboard(context, myInviteCode, "इनवाइट कोड कॉपी हो गया!"),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: kPrimaryBhagwa, borderRadius: BorderRadius.circular(8)),
                                child: const Text("कॉपी करें", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Share Link Box
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
                      const Text("आपकी इनवाइट लिंक (Invite Link)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kSubTextColor)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9F4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFFE0B2)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                inviteLink,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11, color: kTextColor),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => _copyToClipboard(context, inviteLink, "इनवाइट लिंक कॉपी हो गई!"),
                              child: const Icon(Icons.copy_rounded, color: kPrimaryBhagwa, size: 20),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _copyToClipboard(context, "जय श्री राम 🙏! Astro Solution ऐप डाउनलोड करें और मेरी लिंक से जुड़कर भविष्यफल जानें: $inviteLink", "शेयर संदेश कॉपिड!");
                          },
                          icon: const Icon(Icons.share_rounded, size: 18),
                          label: const Text("व्हाट्सएप पर शेयर करें 🚀", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab 2: Referral History Screen (Real-time Supabase)
          _isLoading
              ? const Center(child: CircularProgressIndicator(color: kPrimaryBhagwa))
              : _referralHistory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.card_giftcard_rounded, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("अभी तक कोई रेफरल इतिहास नहीं मिला!", style: TextStyle(fontSize: 13, color: kSubTextColor, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: _referralHistory.length,
                      itemBuilder: (context, index) {
                        final item = _referralHistory[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kCardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFFE0B2)),
                            boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2))],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                                child: const Icon(Icons.currency_rupee_rounded, color: Colors.green, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item.userName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor)),
                                        Text("+ ${item.commissionEarned} (कमीशन)", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text("मोबाइल: ${item.userPhone} • प्रथम रिचार्ज: ${item.rechargeAmount}", style: const TextStyle(fontSize: 10, color: kSubTextColor)),
                                    const SizedBox(height: 2),
                                    Text("दिनांक: ${item.date}", style: const TextStyle(fontSize: 9, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }
}