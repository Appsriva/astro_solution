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

class PujaBookingRecord {
  final String id;
  final String pujaTitle;
  final String templeLocation;
  final String dakshina;
  final String pujaDate;
  final String yajmanName;
  final String gotra;
  final String sankalpText;
  final String status;
  final String statusText;

  const PujaBookingRecord({
    required this.id,
    required this.pujaTitle,
    required this.templeLocation,
    required this.dakshina,
    required this.pujaDate,
    required this.yajmanName,
    required this.gotra,
    required this.sankalpText,
    required this.status,
    required this.statusText,
  });
}

class PujaBookingsHistoryScreen extends StatefulWidget {
  const PujaBookingsHistoryScreen({super.key});

  @override
  State<PujaBookingsHistoryScreen> createState() => _PujaBookingsHistoryScreenState();
}

class _PujaBookingsHistoryScreenState extends State<PujaBookingsHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final supabase = Supabase.instance.client;
  StreamSubscription? _pujaSubscription;
  bool _isLoading = true;

  List<PujaBookingRecord> _bookingsList = [];

  final List<PujaBookingRecord> _fallbackList = [
    const PujaBookingRecord(
      id: "PUJA_98412",
      pujaTitle: "श्री महाकाल रुद्राभिषेक एवं भस्म आरती महापूजा",
      templeLocation: "उज्जैन धाम, मध्य प्रदेश",
      dakshina: "₹2,100",
      pujaDate: "आगामी सोमवार (सोम प्रदोष)",
      yajmanName: "यजमान",
      gotra: "कश्यप",
      sankalpText: "समस्त पारिवारिक सुख, समृद्धि एवं कार्य सिद्धि",
      status: "Sankalp Registered",
      statusText: "ई-संकल्प दर्ज हुआ 🚩",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _listenToRealtimePujaBookings();
  }

  void _listenToRealtimePujaBookings() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      _pujaSubscription = supabase
          .from('puja_bookings')
          .stream(primaryKey: ['id'])
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .listen((List<Map<String, dynamic>> data) {
            if (!mounted) return;
            if (data.isNotEmpty) {
              final liveRecords = data.map((item) {
                final status = item['status'] ?? 'Sankalp Registered';
                final isCompleted = status == 'Completed';

                return PujaBookingRecord(
                  id: "PUJA_${item['id'].toString().substring(0, 5).toUpperCase()}",
                  pujaTitle: item['puja_title'] ?? "वैदिक अनुष्ठान",
                  templeLocation: item['temple_location'] ?? "तीर्थ क्षेत्र",
                  dakshina: "₹${item['dakshina']}",
                  pujaDate: item['puja_date'] ?? "शीघ्र",
                  yajmanName: item['yajman_name'] ?? "यजमान",
                  gotra: item['gotra'] ?? "कश्यप",
                  sankalpText: item['sankalp_text'] ?? "सर्व मनोकामना सिद्धि",
                  status: status,
                  statusText: isCompleted ? "पूजा संपन्न हुई ✅" : "संकल्प पंजीकृत 🚩",
                );
              }).toList();

              setState(() {
                _bookingsList = liveRecords;
                _isLoading = false;
              });
            } else {
              setState(() {
                _bookingsList = _fallbackList;
                _isLoading = false;
              });
            }
          }, onError: (e) {
            if (mounted) {
              setState(() {
                _bookingsList = _fallbackList;
                _isLoading = false;
              });
            }
          });
    } else {
      setState(() {
        _bookingsList = _fallbackList;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pujaSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeBookings = _bookingsList.where((b) => b.status != 'Completed').toList();
    final completedBookings = _bookingsList.where((b) => b.status == 'Completed').toList();

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
          "मेरी पूजा व अनुष्ठान बुकिंग्स 🪔",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: kPrimaryBhagwa,
          unselectedLabelColor: kSubTextColor,
          indicatorColor: kPrimaryBhagwa,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "सभी संकल्प"),
            Tab(text: "प्रगति में 🔔"),
            Tab(text: "संपन्न पूजा ✅"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryBhagwa))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildListView(_bookingsList),
                _buildListView(activeBookings),
                _buildListView(completedBookings),
              ],
            ),
    );
  }

  Widget _buildListView(List<PujaBookingRecord> records) {
    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.temple_hindu_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text("कोई पूजा संकल्प इतिहास नहीं मिला!",
                style: TextStyle(fontSize: 13, color: kSubTextColor, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final rec = records[index];
        final isCompleted = rec.status == 'Completed';

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("संकल्प ID: ${rec.id}",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kSubTextColor)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.green.shade50 : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      rec.statusText,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.green.shade800 : Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0E6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.local_fire_department_rounded, color: kDeepSaffron, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rec.pujaTitle,
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: kTextColor)),
                        const SizedBox(height: 2),
                        Text(rec.templeLocation,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9F4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFCC80)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("यजमान: ${rec.yajmanName} (गोत्र: ${rec.gotra})",
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kTextColor)),
                    const SizedBox(height: 4),
                    Text("तिथि / मुहूर्त: ${rec.pujaDate}",
                        style: const TextStyle(fontSize: 10.5, color: kSubTextColor)),
                    const SizedBox(height: 4),
                    Text("मनोकामना: ${rec.sankalpText}",
                        style: const TextStyle(fontSize: 10.5, color: kSubTextColor)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("दक्षिणा: ${rec.dakshina}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                  const Text("प्रसाद घर भेजा जाएगा 📦",
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}