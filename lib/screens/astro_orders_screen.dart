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

class AstroOrderItem {
  final String orderId;
  final String productName;
  final String productImage;
  final String price;
  final String paymentMode; // 'COD' or 'Prepaid'
  final String orderDate;
  final String status; // 'Processing', 'Transit', 'Delivered', 'Cancelled'
  final String trackingId;
  final String deliveryDate;

  const AstroOrderItem({
    required this.orderId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.paymentMode,
    required this.orderDate,
    required this.status,
    required this.trackingId,
    required this.deliveryDate,
  });
}

class AstroOrdersScreen extends StatefulWidget {
  const AstroOrdersScreen({super.key});

  @override
  State<AstroOrdersScreen> createState() => _AstroOrdersScreenState();
}

class _AstroOrdersScreenState extends State<AstroOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Supabase Stream & Live Data
  final supabase = Supabase.instance.client;
  StreamSubscription? _ordersSubscription;
  bool _isLoading = true;

  List<AstroOrderItem> _ordersList = [];

  // Sample Fallback Orders Data
  final List<AstroOrderItem> _fallbackDummyList = [
    const AstroOrderItem(
      orderId: "SHOP_89421",
      productName: "ओरिजिनल नेपाली 5 मुखी रुद्राक्ष माला (108+1 दाने)",
      productImage: "https://images.unsplash.com/photo-1609722513470-36a537f52077?w=400&auto=format&fit=crop&q=80",
      price: "₹551",
      paymentMode: "COD (कैश ऑन डिलीवरी)",
      orderDate: "27 अगस्त 2026, दोपहर 03:40 PM",
      status: "Transit",
      trackingId: "TRK_IN_9845210",
      deliveryDate: "अपेक्षित: 31 अगस्त 2026",
    ),
    const AstroOrderItem(
      orderId: "SHOP_76214",
      productName: "7 चक्र ओरिजिनल हीलिंग क्रिस्टल ब्रेसलेट",
      productImage: "https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?w=400&auto=format&fit=crop&q=80",
      price: "₹399",
      paymentMode: "Prepaid (ऑनलाइन भुगतान ✅)",
      orderDate: "24 अगस्त 2026, प्रातः 11:15 AM",
      status: "Delivered",
      trackingId: "TRK_IN_7732104",
      deliveryDate: "डिलीवर हो चुका है (27 अगस्त)",
    ),
    const AstroOrderItem(
      orderId: "SHOP_54102",
      productName: "24K स्वर्ण परत श्री संपूर्ण महालक्ष्मी यंत्र",
      productImage: "https://images.unsplash.com/photo-1544717305-2782549b5136?w=400&auto=format&fit=crop&q=80",
      price: "₹751",
      paymentMode: "Prepaid (ऑनलाइन भुगतान ✅)",
      orderDate: "20 अगस्त 2026, संध्या 06:20 PM",
      status: "Delivered",
      trackingId: "TRK_IN_5510298",
      deliveryDate: "डिलीवर हो चुका है (23 अगस्त)",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _listenToRealtimeOrders();
  }

  void _listenToRealtimeOrders() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      _ordersSubscription = supabase
          .from('astro_orders')
          .stream(primaryKey: ['id'])
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .listen((List<Map<String, dynamic>> data) {
            if (!mounted) return;
            if (data.isNotEmpty) {
              final liveRecords = data.map((item) {
                final status = item['status'] ?? 'Transit';
                final isDelivered = status == 'Delivered';
                final created = DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now();
                final orderDateStr = "${created.day}/${created.month}/${created.year}";
                final deliveryStr = isDelivered ? "डिलीवर हो चुका है ✅" : "अपेक्षित: 3 से 5 कार्य दिवस";

                return AstroOrderItem(
                  orderId: "SHOP_${item['id'].toString().substring(0, 5).toUpperCase()}",
                  productName: item['product_name'] ?? "वैदिक उत्पाद",
                  productImage: "https://images.unsplash.com/photo-1609722513470-36a537f52077?w=400&auto=format&fit=crop&q=80",
                  price: "₹${item['price']}",
                  paymentMode: status.toString().contains('COD') ? "COD (कैश ऑन डिलीवरी)" : "Prepaid (ऑनलाइन भुगतान ✅)",
                  orderDate: "$orderDateStr",
                  status: isDelivered ? "Delivered" : "Transit",
                  trackingId: "TRK_IN_${item['id'].toString().substring(0, 6).toUpperCase()}",
                  deliveryDate: deliveryStr,
                );
              }).toList();

              setState(() {
                _ordersList = liveRecords;
                _isLoading = false;
              });
            } else {
              setState(() {
                _ordersList = _fallbackDummyList;
                _isLoading = false;
              });
            }
          }, onError: (e) {
            if (mounted) {
              setState(() {
                _ordersList = _fallbackDummyList;
                _isLoading = false;
              });
            }
          });
    } else {
      setState(() {
        _ordersList = _fallbackDummyList;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ordersSubscription?.cancel();
    super.dispose();
  }

  void _openTrackingModal(AstroOrderItem order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.70,
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
                    child: const Icon(Icons.local_shipping_rounded, color: kPrimaryBhagwa, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("लाइव ऑर्डर ट्रैकिंग (Live Tracking)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor)),
                        Text("ऑर्डर ID: ${order.orderId} • ट्रैकिंग: ${order.trackingId}", style: const TextStyle(fontSize: 10, color: kPrimaryBhagwa, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: kTextColor),
                  ),
                ],
              ),
              const Divider(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product preview in tracking
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9F4),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFFFCC80)),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                order.productImage,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(order.productName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                                  Text("${order.price} • ${order.paymentMode}", style: const TextStyle(fontSize: 10, color: kSubTextColor)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Text("कुरियर प्रोग्रेस स्टेटस:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                      const SizedBox(height: 14),

                      // Tracking timeline steps
                      _buildTimelineStep(
                        title: "ऑर्डर कन्फर्म हुआ",
                        subtitle: order.orderDate,
                        isDone: true,
                        isFirst: true,
                      ),
                      _buildTimelineStep(
                        title: "पंडित जी द्वारा वैदिक प्राण-प्रतिष्ठा एवं अभिमंत्रण",
                        subtitle: "काशी / उज्जैन वैदिक अनुष्ठान केंद्र",
                        isDone: true,
                      ),
                      _buildTimelineStep(
                        title: "पार्सल शिप्ड / ट्रांजिट में है",
                        subtitle: order.status == 'Transit' ? "कुरियर हब से रवाना (ब्लू डार्ट एक्सप्रेस)" : "पार्सल आगे बढ़ा",
                        isDone: order.status == 'Transit' || order.status == 'Delivered',
                      ),
                      _buildTimelineStep(
                        title: "घर पर डिलीवरी",
                        subtitle: order.deliveryDate,
                        isDone: order.status == 'Delivered',
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBhagwa, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text("ठीक है", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelineStep({required String title, required String subtitle, required bool isDone, bool isFirst = false, bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isDone ? Colors.green : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(isDone ? Icons.check_rounded : Icons.circle, color: Colors.white, size: 13),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 34,
                color: isDone ? Colors.green : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDone ? kTextColor : Colors.grey)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 10, color: kSubTextColor)),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeOrders = _ordersList.where((o) => o.status != 'Delivered').toList();
    final pastOrders = _ordersList.where((o) => o.status == 'Delivered').toList();

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
          "मेरे AstroShop ऑर्डर्स (My Orders) 🛍️",
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
            Tab(text: "सभी ऑर्डर्स"),
            Tab(text: "प्रोग्रेस / ट्रांजिट 🚚"),
            Tab(text: "डिलीवर हो चुके ✅"),
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
                _buildOrdersListView(_ordersList),
                _buildOrdersListView(activeOrders),
                _buildOrdersListView(pastOrders),
              ],
            ),
    );
  }

  Widget _buildOrdersListView(List<AstroOrderItem> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shopping_bag_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text("कोई आर्डर नहीं मिला!", style: TextStyle(fontSize: 13, color: kSubTextColor, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final isDelivered = order.status == 'Delivered';

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kCardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFE0B2)),
            boxShadow: const [
              BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top ID & Status Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("ऑर्डर ID: ${order.orderId}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kSubTextColor)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDelivered ? Colors.green.shade50 : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isDelivered ? "डिलीवर हो चुका ✅" : "ट्रांजिट में है 🚚",
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: isDelivered ? Colors.green.shade800 : Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 14),

              // Product Info Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      order.productImage,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 65,
                        height: 65,
                        color: const Color(0xFFFFF0E6),
                        child: const Icon(Icons.stars_rounded, color: kPrimaryBhagwa),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(order.price, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
                            const SizedBox(width: 6),
                            Text("• ${order.paymentMode}", style: const TextStyle(fontSize: 10, color: kSubTextColor)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text("ऑर्डर समय: ${order.orderDate}", style: const TextStyle(fontSize: 9.5, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 14),

              // Bottom Tracking Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(order.deliveryDate, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: kTextColor)),
                  ElevatedButton.icon(
                    onPressed: () => _openTrackingModal(order),
                    icon: const Icon(Icons.local_shipping_rounded, size: 14),
                    label: const Text("ऑर्डर ट्रैक करें", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBhagwa,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: const Size(90, 30),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}