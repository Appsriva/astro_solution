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

class PanditBookingRecord {
  final String bookingId;
  final String panditName;
  final String panditImage;
  final String karmkandType;
  final String yajmanName;
  final String address;
  final String dakshina;
  final String bookingDate;
  final String status; // 'Completed', 'Upcoming', 'InProcess'
  final String statusText;

  const PanditBookingRecord({
    required this.bookingId,
    required this.panditName,
    required this.panditImage,
    required this.karmkandType,
    required this.yajmanName,
    required this.address,
    required this.dakshina,
    required this.bookingDate,
    required this.status,
    required this.statusText,
  });
}

class PanditBookingsHistoryScreen extends StatefulWidget {
  const PanditBookingsHistoryScreen({super.key});

  @override
  State<PanditBookingsHistoryScreen> createState() =>
      _PanditBookingsHistoryScreenState();
}

class _PanditBookingsHistoryScreenState
    extends State<PanditBookingsHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Supabase Stream & Live Data
  final supabase = Supabase.instance.client;
  StreamSubscription? _bookingsSubscription;
  bool _isLoading = true;

  // Live and Default Fallback Bookings History
  List<PanditBookingRecord> _bookingsList = [];

  final List<PanditBookingRecord> _fallbackDummyList = [
    const PanditBookingRecord(
      bookingId: "PND_98412",
      panditName: "पं. राधेश्याम शास्त्री",
      panditImage:
          "https://images.unsplash.com/photo-1544717305-2782549b5136?w=200&auto=format&fit=crop&q=80",
      karmkandType: "गृह प्रवेश एवं वास्तु शांति (Griha Pravesh)",
      yajmanName: "आफ़ताब हुसैन",
      address: "फ्लैट नंबर 402, गंगा एन्क्लेव, जयपुर - 302018",
      dakshina: "₹2,100",
      bookingDate: "27 अगस्त 2026, प्रातः 10:00 AM",
      status: "InProcess",
      statusText: "पंडित जी सामग्री के साथ पधार रहे हैं 🪔",
    ),
    const PanditBookingRecord(
      bookingId: "Pnd_77301",
      panditName: "आचार्य विद्याधर त्रिपाठी",
      panditImage:
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80",
      karmkandType: "सत्यनारायण भगवान की कथा व पूजा",
      yajmanName: "आफ़ताब हुसैन",
      address: "मकान नंबर 12, शिव मार्ग, वाराणसी - 221001",
      dakshina: "₹1,500",
      bookingDate: "22 अगस्त 2026, संध्या 04:00 PM",
      status: "Completed",
      statusText: "पूजा सफलतापूर्वक संपन्न हुई ✅",
    ),
    const PanditBookingRecord(
      bookingId: "PND_55104",
      panditName: "पं. बृजमोहन शर्मा",
      panditImage:
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80",
      karmkandType: "रुद्राभिषेक एवं महामृत्युंजय अनुष्ठान",
      yajmanName: "आफ़ताब हुसैन",
      address: "ज्योति नगर, मुख्य बाजार, जयपुर",
      dakshina: "₹2,500",
      bookingDate: "15 अगस्त 2026, प्रातः 08:00 AM",
      status: "Completed",
      statusText: "पूजा सफलतापूर्वक संपन्न हुई ✅",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _listenToRealtimeBookings();
  }

  void _listenToRealtimeBookings() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      _bookingsSubscription = supabase
          .from('pandit_bookings')
          .stream(primaryKey: ['id'])
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .listen((List<Map<String, dynamic>> data) {
            if (!mounted) return;
            if (data.isNotEmpty) {
              final liveRecords = data.map((item) {
                final status = item['status'] ?? 'Confirmed';
                String statusMsg = "पंडित जी पुष्टि हो चुकी है 🪔";
                if (status == 'Completed') {
                  statusMsg = "पूजा सफलतापूर्वक संपन्न हुई ✅";
                } else if (status == 'InProcess') {
                  statusMsg = "पंडित जी सामग्री के साथ पधार रहे हैं 🪔";
                }

                return PanditBookingRecord(
                  bookingId:
                      "PND_${item['id'].toString().substring(0, 5).toUpperCase()}",
                  panditName: item['pandit_name'] ?? "आचार्य",
                  panditImage:
                      "https://images.unsplash.com/photo-1544717305-2782549b5136?w=200&auto=format&fit=crop&q=80",
                  karmkandType: item['karmkand'] ?? "वैदिक अनुष्ठान",
                  yajmanName: item['yajman_name'] ?? "यजमान",
                  address: item['address'] ?? "जयपुर, राजस्थान",
                  dakshina: item['dakshina'] ?? "₹1,100",
                  bookingDate: item['booking_date'] ?? "शीघ्र",
                  status: status,
                  statusText: statusMsg,
                );
              }).toList();

              setState(() {
                _bookingsList = liveRecords;
                _isLoading = false;
              });
            } else {
              setState(() {
                _bookingsList = _fallbackDummyList;
                _isLoading = false;
              });
            }
          }, onError: (e) {
            if (mounted) {
              setState(() {
                _bookingsList = _fallbackDummyList;
                _isLoading = false;
              });
            }
          });
    } else {
      setState(() {
        _bookingsList = _fallbackDummyList;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bookingsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeBookings =
        _bookingsList.where((b) => b.status != 'Completed').toList();
    final completedBookings =
        _bookingsList.where((b) => b.status == 'Completed').toList();

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: kPrimaryBhagwa, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "पंडित जी व पूजा बुकिंग इतिहास 🪔",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: kPrimaryBhagwa,
          unselectedLabelColor: kSubTextColor,
          indicatorColor: kPrimaryBhagwa,
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "सभी बुकिंग्स"),
            Tab(text: "आगामी / प्रोग्रेस 🔔"),
            Tab(text: "संपन्न पूजा ✅"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: kPrimaryBhagwa),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildBookingsListView(_bookingsList),
                _buildBookingsListView(activeBookings),
                _buildBookingsListView(completedBookings),
              ],
            ),
    );
  }

  Widget _buildBookingsListView(List<PanditBookingRecord> records) {
    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.temple_hindu_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text("कोई पूजा बुकिंग इतिहास नहीं मिला!",
                style: TextStyle(
                    fontSize: 13,
                    color: kSubTextColor,
                    fontWeight: FontWeight.bold)),
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
              BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 4,
                  offset: Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ID & Status Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("बुकिंग ID: ${rec.bookingId}",
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: kSubTextColor)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isCompleted ? "संपन्न हुई ✅" : "प्रक्रिया में 🔔",
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: isCompleted
                            ? Colors.green.shade800
                            : Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 14),

              // Pandit & Karmkand Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(rec.panditImage),
                    backgroundColor: const Color(0xFFFFF0E6),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rec.panditName,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: kTextColor)),
                        const SizedBox(height: 2),
                        Text(rec.karmkandType,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryBhagwa)),
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
                    Row(
                      children: [
                        const Icon(Icons.person_outline_rounded,
                            size: 14, color: kSubTextColor),
                        const SizedBox(width: 6),
                        Text("यजमान: ${rec.yajmanName}",
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: kTextColor)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: kSubTextColor),
                        const SizedBox(width: 6),
                        Expanded(
                            child: Text("पता: ${rec.address}",
                                style: const TextStyle(
                                    fontSize: 10.5, color: kSubTextColor))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded,
                            size: 14, color: kSubTextColor),
                        const SizedBox(width: 6),
                        Text("मुहूर्त/तिथि: ${rec.bookingDate}",
                            style: const TextStyle(
                                fontSize: 10.5, color: kSubTextColor)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("तय दक्षिणा: ${rec.dakshina}",
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                  Text(rec.statusText,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryBhagwa)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}