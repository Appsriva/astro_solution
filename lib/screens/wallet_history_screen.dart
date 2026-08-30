import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);

class WalletTransactionItem {
  final String id;
  final String description;
  final double amount;
  final String type; // 'credit' or 'debit'
  final String fullFormattedDate;
  final String platform;

  const WalletTransactionItem({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.fullFormattedDate,
    required this.platform,
  });
}

class WalletHistoryScreen extends StatefulWidget {
  const WalletHistoryScreen({super.key});

  @override
  State<WalletHistoryScreen> createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<WalletTransactionItem> _transactions = [];

  static const List<String> _hindiWeekDays = [
    "सोमवार", "मंगलवार", "बुधवार", "गुरुवार", "शुक्रवार", "शनिवार", "रविवार"
  ];

  static const List<String> _hindiMonths = [
    "जनवरी", "फ़रवरी", "मार्च", "अप्रैल", "मई", "जून", "जुलाई", "अगस्त", "सितंबर", "अक्टूबर", "नवंबर", "दिसंबर"
  ];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  String _formatFullDateHindi(DateTime dt) {
    final dayName = _hindiWeekDays[dt.weekday - 1];
    final monthName = _hindiMonths[dt.month - 1];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? "PM" : "AM";

    return "$dayName, ${dt.day} $monthName ${dt.year} • $hour:$minute $period";
  }

  Future<void> _fetchTransactions() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final data = await supabase
          .from('wallet_transactions')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final List<WalletTransactionItem> loaded = [];
      for (var item in (data as List)) {
        final created = DateTime.tryParse(item['created_at'] ?? '')?.toLocal() ?? DateTime.now();
        final type = item['type'] ?? 'debit';
        final platformName = type == 'credit' ? 'UPI / Google Pay / PhonePe' : 'इन-ऐप वॉलेट डिडक्शन';

        loaded.add(
          WalletTransactionItem(
            id: item['id'].toString(),
            description: item['description'] ?? "वॉलेट लेन-देन",
            amount: (item['amount'] ?? 0).toDouble(),
            type: type,
            fullFormattedDate: _formatFullDateHindi(created),
            platform: platformName,
          ),
        );
      }

      if (mounted) {
        setState(() {
          _transactions = loaded;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
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
          "वॉलेट ट्रांजैक्शन हिस्ट्री 💳",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: kPrimaryBhagwa),
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchTransactions();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryBhagwa))
          : _transactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text("कोई लेन-देन इतिहास उपलब्ध नहीं है!", style: TextStyle(fontSize: 13, color: kSubTextColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    final tx = _transactions[index];
                    final isCredit = tx.type == 'credit';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: kCardColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFFFE0B2)),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isCredit ? Colors.green.shade50 : Colors.red.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                  color: isCredit ? Colors.green.shade700 : Colors.red.shade700,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx.description,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      "माध्यम: ${tx.platform}",
                                      style: const TextStyle(fontSize: 10.5, color: kPrimaryBhagwa, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "${isCredit ? '+' : '-'}₹${tx.amount.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isCredit ? Colors.green.shade700 : Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF9F4),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFFFCC80)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  tx.fullFormattedDate, // 👈 यहाँ सही नाम कर दिया गया है
                                  style: const TextStyle(fontSize: 10.5, color: kSubTextColor, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}