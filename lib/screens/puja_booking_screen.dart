import 'dart:async';
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);

// शुभ मुहूर्त / विशेष तिथि मॉडल
class ShubhDateItem {
  final String date;
  final String badge;
  final bool isRecommended;

  ShubhDateItem({
    required this.date,
    required this.badge,
    required this.isRecommended,
  });

  factory ShubhDateItem.fromMap(Map<String, dynamic> map) {
    return ShubhDateItem(
      date: map['date']?.toString() ?? '',
      badge: map['badge']?.toString() ?? 'शुभ मुहूर्त',
      isRecommended: map['is_recommended'] ?? true,
    );
  }
}

// पंडित प्रोफाइल मॉडल
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
  final String category;
  final double baseDakshinaNumeric; // 💡 एडमिन पैनल से आया हुआ शुद्ध बेस अमाउंट
  final double adminProfitNumeric;  // 💡 छिपा हुआ एडमिन प्रॉफिट
  final double totalPayableNumeric; // 💡 18% GST सहित कुल राशि
  final String priceSingle;
  final String priceFamily;
  final String priceMaha;
  final String basePrice;
  final List<String> imageUrls;
  final String nextDate;
  final List<String> onlineSlots;
  final List<PanditProfile> assignedPandits;
  final List<ShubhDateItem> recommendedDates;

  VedicPujaItem({
    required this.id,
    required this.title,
    required this.deity,
    required this.templeLocation,
    required this.templeAddress,
    required this.benefit,
    required this.category,
    required this.baseDakshinaNumeric,
    required this.adminProfitNumeric,
    required this.totalPayableNumeric,
    required this.priceSingle,
    required this.priceFamily,
    required this.priceMaha,
    required this.basePrice,
    required this.imageUrls,
    required this.nextDate,
    required this.onlineSlots,
    required this.assignedPandits,
    required this.recommendedDates,
  });

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

    List<String> parsedSlots = const [
      "प्रातः 07:30 AM - 09:30 AM",
      "दोपहर 11:30 AM - 01:30 PM",
      "संध्या 06:30 PM - 08:30 PM"
    ];
    if (map['available_slots'] != null && map['available_slots'] is List && (map['available_slots'] as List).isNotEmpty) {
      parsedSlots = (map['available_slots'] as List).map((e) => e.toString()).toList();
    }

    List<ShubhDateItem> parsedDates = [];
    if (map['recommended_dates'] != null && map['recommended_dates'] is List && (map['recommended_dates'] as List).isNotEmpty) {
      parsedDates = (map['recommended_dates'] as List)
          .map((e) => ShubhDateItem.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } else {
      parsedDates = [
        ShubhDateItem(date: "2026-09-15", badge: "पूर्णिमा विशेष", isRecommended: true),
        ShubhDateItem(date: "2026-09-22", badge: "सोम प्रदोष", isRecommended: true),
        ShubhDateItem(date: "2026-10-04", badge: "नवरात्रि घटस्थापना", isRecommended: true),
      ];
    }

    List<String> parsedImages = [];
    if (map['image_urls'] != null && map['image_urls'] is List && (map['image_urls'] as List).isNotEmpty) {
      parsedImages = (map['image_urls'] as List).map((e) => e.toString()).toList();
    } else if (map['image_url'] != null && map['image_url'].toString().trim().isNotEmpty) {
      parsedImages = [
        map['image_url'].toString(),
        "https://images.unsplash.com/photo-1609766857041-ed402ea8069a?w=600&auto=format&fit=crop&q=80",
        "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=600&auto=format&fit=crop&q=80",
      ];
    } else {
      parsedImages = [
        "https://images.unsplash.com/photo-1609766857041-ed402ea8069a?w=600&auto=format&fit=crop&q=80",
        "https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=600&auto=format&fit=crop&q=80",
      ];
    }

    // 💡 सटीक वित्तीय कैलकुलेशन: सीधे एडमिन पैनल की फाइनल वैल्यू लेना
    double calculatedTotal = double.tryParse(map['total_payable_amount']?.toString() ?? '') ?? 
        double.tryParse(map['dakshina_amount']?.toString() ?? '') ?? 12980;
    
    double rawBase = double.tryParse(map['base_dakshina']?.toString() ?? '') ?? (calculatedTotal / 1.18);
    double rawProfit = double.tryParse(map['admin_profit']?.toString() ?? '1000') ?? 1000;

    final priceStr = "₹${calculatedTotal.toStringAsFixed(0)}";

    String resolvedTempleName = map['temples']?['name']?.toString() ?? map['temple_location']?.toString() ?? 'श्री महाकालेश्वर ज्योतिर्लिंग मंदिर';
    String resolvedCity = map['temples']?['city']?.toString() ?? map['temple_city']?.toString() ?? 'उज्जैन';
    String finalTempleLocation = "$resolvedTempleName, $resolvedCity";

    return VedicPujaItem(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? 'वैदिक पूजा',
      deity: map['deity']?.toString() ?? 'देवाधिदेव महादेव',
      templeLocation: finalTempleLocation,
      templeAddress: map['temples']?['full_address']?.toString() ?? map['temple_address']?.toString() ?? 'श्री महाकालेश्वर ज्योतिर्लिंग मंदिर परिसर, उज्जैन (म.प्र.) - 456006',
      benefit: map['description']?.toString() ?? 'समस्त कष्टों का निवारण, मनोकामना पूर्ति हेतु विशेष वैदिक अनुष्ठान।',
      category: map['category']?.toString() ?? 'दोष निवारण',
      baseDakshinaNumeric: rawBase,
      adminProfitNumeric: rawProfit,
      totalPayableNumeric: calculatedTotal,
      priceSingle: priceStr,
      priceFamily: priceStr,
      priceMaha: priceStr,
      basePrice: priceStr,
      imageUrls: parsedImages,
      nextDate: map['next_date']?.toString() ?? 'आगामी शुभ मुहूर्त',
      onlineSlots: parsedSlots,
      assignedPandits: parsedPandits,
      recommendedDates: parsedDates,
    );
  }
}

// 🎡 ऑटोमैटिक इमेज कैरोसेल स्लाइडर विजेट
class AutoImageCarousel extends StatefulWidget {
  final List<String> images;
  final double height;
  final BorderRadius? borderRadius;

  const AutoImageCarousel({
    super.key,
    required this.images,
    this.height = 150,
    this.borderRadius,
  });

  @override
  State<AutoImageCarousel> createState() => _AutoImageCarouselState();
}

class _AutoImageCarouselState extends State<AutoImageCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    if (widget.images.length > 1) {
      _timer = Timer.periodic(const Duration(milliseconds: 3500), (timer) {
        if (_pageController.hasClients) {
          int nextPage = _currentPage + 1;
          if (nextPage >= widget.images.length) {
            nextPage = 0;
          }
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(color: const Color(0xFFFFF0E6), borderRadius: widget.borderRadius),
        child: const Center(child: Icon(Icons.temple_hindu_rounded, color: kPrimaryBhagwa, size: 48)),
      );
    }

    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: Stack(
        children: [
          SizedBox(
            height: widget.height,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return Image.network(
                  widget.images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: widget.height,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFFFF0E6),
                    child: const Center(child: Icon(Icons.temple_hindu_rounded, color: kPrimaryBhagwa, size: 48)),
                  ),
                );
              },
            ),
          ),
          if (widget.images.length > 1)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    width: _currentPage == index ? 14 : 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? kGoldAccent : Colors.white60,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
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

  late Future<List<VedicPujaItem>> _pujasFuture;

  @override
  void initState() {
    super.initState();
    _pujasFuture = _fetchPujasFromSupabase();
  }

  void _openRazorpayWebCheckout({
    required Map<String, dynamic> bookingPayload,
    required VedicPujaItem puja,
    required String currentPrice,
    required String yajmanName,
    required String gotra,
    required String slotOrAddress,
    required String sankalp,
    required double numericDakshina,
    required String phone,
  }) {
    if (!kIsWeb) return;

    final options = js.JsObject.jsify({
      'key': 'rzp_test_TWmOm1Jf5m551b',
      'amount': (numericDakshina * 100).toInt(),
      'name': 'वैदिक पूजा संकल्प',
      'description': puja.title,
      'prefill': {
        'contact': phone,
        'email': 'devotee@astrosolution.com',
      },
      'theme': {
        'color': '#FF6F00',
      },
      'handler': js.allowInterop((response) async {
        final paymentId = response['razorpay_payment_id'] ?? 'PAY_TEST_${DateTime.now().millisecondsSinceEpoch}';
        debugPrint("✅ Razorpay Payment ID: $paymentId");

        try {
          final payload = Map<String, dynamic>.from(bookingPayload);
          payload['sankalp_details'] = "${payload['sankalp_details']} | PaymentID: $paymentId";
          payload['status'] = 'Paid';

          await Supabase.instance.client.from('pooja_bookings').insert(payload);
          debugPrint("✅ Booking Saved to Supabase successfully as Paid!");

          if (mounted) {
            _showPujaSuccessDialog(
              puja: puja,
              price: currentPrice,
              name: yajmanName,
              gotra: gotra,
              slotOrAddress: slotOrAddress,
              sankalp: sankalp,
            );
          }
        } catch (e) {
          debugPrint("🔴 Insert error after payment: $e");
        }
      }),
      'modal': {
        'ondismiss': js.allowInterop(() {
          debugPrint("Payment dismissed by user");
        })
      }
    });

    try {
      final rzp = js.JsObject(js.context['Razorpay'], [options]);
      rzp.callMethod('open');
    } catch (e) {
      debugPrint("Razorpay Web Open Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Razorpay लोड नहीं हो सका: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<List<VedicPujaItem>> _fetchPujasFromSupabase() async {
    try {
      final response = await Supabase.instance.client
          .from('poojas')
          .select('*, temples(name, full_address, city)')
          .order('created_at');

      if (response.isNotEmpty) {
        return response.map((item) => VedicPujaItem.fromMap(item)).toList();
      }
    } catch (e) {
      debugPrint("Supabase fetch error: $e");
    }
    return _fallbackPujasList;
  }

  static final List<VedicPujaItem> _fallbackPujasList = [
    VedicPujaItem(
      id: "pj_1",
      title: "श्री महाकाल रुद्राभिषेक एवं भस्म आरती महापूजा",
      deity: "देवाधिदेव महादेव (महाकाल)",
      templeLocation: "श्री महाकालेश्वर ज्योतिर्लिंग, उज्जैन (म.प्र.)",
      templeAddress: "श्री महाकालेश्वर ज्योतिर्लिंग मंदिर परिसर, उज्जैन (म.प्र.) - 456006",
      benefit: "समस्त पापों, अकाल मृत्यु भय व कालसर्प दोष से मुक्ति। सुख, शांति व आरोग्य की प्राप्ति।",
      category: "दोष निवारण",
      baseDakshinaNumeric: 10000,
      adminProfitNumeric: 1000,
      totalPayableNumeric: 12980,
      priceSingle: "₹12,980",
      priceFamily: "₹12,980",
      priceMaha: "₹12,980",
      basePrice: "₹12,980",
      imageUrls: [
        "https://images.unsplash.com/photo-1609766857041-ed402ea8069a?w=600&auto=format&fit=crop&q=80",
        "https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=600&auto=format&fit=crop&q=80",
      ],
      nextDate: "आगामी सोमवार",
      onlineSlots: const [
        "प्रातः 07:30 AM - 09:30 AM",
        "दोपहर 11:30 AM - 01:30 PM",
        "संध्या 06:30 PM - 08:30 PM"
      ],
      assignedPandits: [
        PanditProfile(name: 'पं. राधेश्याम शास्त्री', skills: 'मुख्य आचार्य, महाकाल विशेषज्ञ', rating: '5.0 ⭐', imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200'),
      ],
      recommendedDates: [
        ShubhDateItem(date: "2026-09-15", badge: "पूर्णिमा विशेष", isRecommended: true),
        ShubhDateItem(date: "2026-09-22", badge: "सोम प्रदोष", isRecommended: true),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openPujaDetailsSheet(VedicPujaItem puja) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 44,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoImageCarousel(
                        images: puja.imageUrls,
                        height: 190,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        puja.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kTextColor),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: kPrimaryBhagwa, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              puja.templeLocation,
                              style: const TextStyle(fontSize: 12, color: kPrimaryBhagwa, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      const Text(
                        "🪔 पूजा का महात्म्य एवं फल (Significance & Benefits):",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        puja.benefit,
                        style: const TextStyle(fontSize: 12, color: kSubTextColor, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _openBookingModal(puja);
                    },
                    icon: const Icon(Icons.event_available_rounded, size: 20),
                    label: const Text("शुभ मुहूर्त देखकर बुक करें (Book Pooja)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBhagwa,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 2. मुख्य बुकिंग बॉटम शीट (सटीक प्राइस कैलकुलेशन फिक्स)
  void _openBookingModal(VedicPujaItem puja) {
    String selectedPackageType = "परिवार संकल्प";
    String selectedMonth = "सितंबर 2026";
    String selectedDate = puja.recommendedDates.isNotEmpty ? puja.recommendedDates.first.date : "2026-09-15";
    String selectedSlot = puja.onlineSlots.first;

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController gotraController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController altPhoneController = TextEditingController();
    final TextEditingController sankalpWishController = TextEditingController();

    final List<String> monthsList = ["सितंबर 2026", "अक्टूबर 2026", "नवंबर 2026", "दिसंबर 2026"];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            
            // 💡 फिक्स: सीधे एडमिन पैनल की अंतिम तय राशि (Final Amount) का उपयोग
            double finalPayableAmount = puja.totalPayableNumeric;
            double baseAmountWithoutGst = (finalPayableAmount / 1.18);
            double gstAmount = finalPayableAmount - baseAmountWithoutGst;

            final currentPriceStr = "₹${finalPayableAmount.toStringAsFixed(0)}";

            const Color kPrimaryBhagwa = Color(0xFFFF6F00);

            return Container(
              height: MediaQuery.of(context).size.height * 0.92,
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

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color(0xFFFFF0E6), shape: BoxShape.circle),
                        child: const Icon(Icons.temple_hindu_rounded, color: kDeepSaffron, size: 24),
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
                              "${puja.templeLocation} • 100% प्रत्यक्ष मंदिर पूजा",
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
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Mandir Venue Card
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
                                        "पूजन स्थल (Mandir Venue Address):",
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    puja.templeAddress,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kTextColor, height: 1.35),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Month Selector
                            const Text("महीना चुनें (Select Month):", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 34,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: monthsList.length,
                                itemBuilder: (context, index) {
                                  final month = monthsList[index];
                                  final isMonthSelected = selectedMonth == month;
                                  return GestureDetector(
                                    onTap: () => setModalState(() => selectedMonth = month),
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isMonthSelected ? kPrimaryBhagwa : const Color(0xFFFFF9F4),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(color: isMonthSelected ? kPrimaryBhagwa : Colors.orange.shade200),
                                      ),
                                      child: Text(
                                        month,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: isMonthSelected ? FontWeight.bold : FontWeight.w600,
                                          color: isMonthSelected ? Colors.white : kTextColor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Shubh Dates Selector
                            Row(
                              children: const [
                                Icon(Icons.stars_rounded, color: kPrimaryBhagwa, size: 16),
                                SizedBox(width: 4),
                                Text("शुभ मुहूर्त एवं विशेष तिथियां (Select Shubh Date):", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 58,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: puja.recommendedDates.length,
                                itemBuilder: (context, index) {
                                  final item = puja.recommendedDates[index];
                                  final isDateSelected = selectedDate == item.date;
                                  return GestureDetector(
                                    onTap: () => setModalState(() => selectedDate = item.date),
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isDateSelected ? const Color(0xFFFFF7F0) : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isDateSelected ? kPrimaryBhagwa : Colors.orange.shade100,
                                          width: isDateSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                            decoration: BoxDecoration(color: Colors.green.shade700, borderRadius: BorderRadius.circular(4)),
                                            child: Text(item.badge, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(item.date, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kTextColor)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Package Options
                            const Text("संकल्प प्रकार चुनें (Select Package):", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildPackageOption(
                                    title: "एकल संकल्प",
                                    price: currentPriceStr,
                                    desc: "1 व्यक्ति का नाम",
                                    isSelected: selectedPackageType == "एकल संकल्प",
                                    onTap: () => setModalState(() => selectedPackageType = "एकल संकल्प"),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: _buildPackageOption(
                                    title: "परिवार संकल्प",
                                    price: currentPriceStr,
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
                                    price: currentPriceStr,
                                    desc: "विशेष व्यक्तिगत हवन",
                                    isSelected: selectedPackageType == "महा अनुष्ठान",
                                    onTap: () => setModalState(() => selectedPackageType = "महा अनुष्ठान"),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // 💰 Price & Tax Breakdown Card
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.amber.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("💰 दक्षिणा एवं कर विवरण (Price & Tax Breakdown):", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.brown)),
                                  const Divider(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("पूजा बेस मूल्य (सेवा शुल्क सहित):", style: TextStyle(fontSize: 11)),
                                      Text("₹${baseAmountWithoutGst.toStringAsFixed(0)}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("18% GST (समाहित कर):", style: TextStyle(fontSize: 11, color: Colors.grey)),
                                      Text("₹${gstAmount.toStringAsFixed(0)}", style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const Padding(padding: EdgeInsets.symmetric(vertical: 4.0), child: Divider(height: 1)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("कुल देय राशि (Total Payable):", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                                      Text("₹${finalPayableAmount.toStringAsFixed(0)}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.deepOrange)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Sankalp Form Fields
                            const Text("यजमान एवं संकल्प विवरण:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: nameController,
                                    validator: (val) => (val == null || val.trim().isEmpty) ? 'नाम दर्ज करें' : null,
                                    style: const TextStyle(fontSize: 12, color: kTextColor),
                                    decoration: _buildInputDecoration("यजमान का पूरा नाम *", Icons.person_outline_rounded),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: gotraController,
                                    validator: (val) => (val == null || val.trim().isEmpty) ? 'गोत्र दर्ज करें' : null,
                                    style: const TextStyle(fontSize: 12, color: kTextColor),
                                    decoration: _buildInputDecoration("गोत्र *", Icons.temple_hindu_rounded),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    validator: (val) => (val == null || val.trim().length != 10) ? '10-अंकीय नंबर डालें' : null,
                                    style: const TextStyle(fontSize: 12, color: kTextColor),
                                    decoration: _buildInputDecoration("मोबाइल नंबर (+91) *", Icons.phone_outlined),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: altPhoneController,
                                    keyboardType: TextInputType.phone,
                                    style: const TextStyle(fontSize: 12, color: kTextColor),
                                    decoration: _buildInputDecoration("वैकल्पिक नंबर", Icons.phone_forwarded_outlined),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            TextFormField(
                              controller: sankalpWishController,
                              maxLines: 3,
                              validator: (val) => (val == null || val.trim().isEmpty) ? 'मनोकामना दर्ज करें' : null,
                              style: const TextStyle(fontSize: 12, color: kTextColor),
                              decoration: InputDecoration(
                                labelText: "विशेष मनोकामना / संकल्प उद्देश्य *",
                                labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                                prefixIcon: const Icon(Icons.stars_rounded, color: kPrimaryBhagwa, size: 18),
                                filled: true,
                                fillColor: const Color(0xFFFFFDF9),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                contentPadding: const EdgeInsets.all(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) return;

                        final yajmanName = nameController.text.trim();
                        final gotra = gotraController.text.trim();
                        final phone = phoneController.text.trim();
                        final altPhone = altPhoneController.text.trim();
                        final sankalp = sankalpWishController.text.trim();

                        final timeInfo = "दिनांक: $selectedDate | समय: $selectedSlot | स्थान: मंदिर प्रत्यक्ष";
                        final finalDetails = "गोत्र: $gotra | वैकल्पिक: ${altPhone.isEmpty ? 'N/A' : altPhone} | $timeInfo | पैकेज: $selectedPackageType | संकल्प: $sankalp";

                        final user = Supabase.instance.client.auth.currentUser;

                        final payload = {
                          if (user != null) 'user_id': user.id,
                          'user_name': yajmanName,
                          'user_phone': phone,
                          'pooja_id': puja.id,
                          'puja_title': puja.title,
                          'booking_amount': finalPayableAmount,
                          'admin_profit': puja.adminProfitNumeric,
                          'mode': 'Offline',
                          'sankalp_details': finalDetails,
                          'status': 'Confirmed',
                        };

                        Navigator.pop(modalContext);

                        _openRazorpayWebCheckout(
                          bookingPayload: payload,
                          puja: puja,
                          currentPrice: currentPriceStr,
                          yajmanName: yajmanName,
                          gotra: gotra,
                          slotOrAddress: "$selectedDate ($selectedSlot)",
                          sankalp: sankalp,
                          numericDakshina: finalPayableAmount,
                          phone: phone,
                        );
                      },
                      icon: const Icon(Icons.payment_rounded, size: 18),
                      label: Text(
                        "₹${finalPayableAmount.toStringAsFixed(0)} में निहित पूजा बुक करें 🚩",
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

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
      prefixIcon: Icon(icon, color: kPrimaryBhagwa, size: 18),
      filled: true,
      fillColor: const Color(0xFFFFFDF9),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
      contentPadding: const EdgeInsets.all(10),
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
    required String price,
    required String name,
    required String gotra,
    required String slotOrAddress,
    required String sankalp,
  }) {
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
              const Text(
                "मंदिर पूजा बुकिंग कन्फर्म! 🛕",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
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
                    const Center(
                      child: Text(
                        "🛕 मंदिर दर्शन व पूजन पास",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kPrimaryBhagwa),
                      ),
                    ),
                    const Divider(height: 12),
                    _buildReceiptRow("यजमान:", name),
                    _buildReceiptRow("गोत्र:", gotra),
                    _buildReceiptRow("मंदिर / तीर्थ स्थल:", puja.templeLocation),
                    _buildReceiptRow("मुहूर्त एवं समय:", slotOrAddress),
                    _buildReceiptRow("कुल भुगतान राशि:", price),
                    _buildReceiptRow("बुकिंग ID:", "PUJA_${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}"),
                  ],
                ),
              ),

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
    return GestureDetector(
      onTap: () => _openPujaDetailsSheet(puja),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFFFE0B2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AutoImageCarousel(
                  images: puja.imageUrls,
                  height: 150,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
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

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    puja.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.temple_hindu_rounded, color: kPrimaryBhagwa, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          puja.templeLocation,
                          style: const TextStyle(fontSize: 11, color: kPrimaryBhagwa, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    puja.benefit,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: kSubTextColor),
                  ),
                  const Divider(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("दक्षिणा शुल्क (GST सहित):", style: TextStyle(fontSize: 9, color: kSubTextColor)),
                          Row(
                            children: [
                              Text(puja.basePrice, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextColor)),
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
      ),
    );
  }
}  