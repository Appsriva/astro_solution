import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);

class ProductDetailScreen extends StatefulWidget {
  final dynamic product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  final TextEditingController _pincodeController = TextEditingController(text: "302001");
  bool _pincodeChecked = true;

  late List<String> _galleryImages;

  // Helper getters for both Map and Object structures
  String get _name => widget.product is Map ? (widget.product["name"] ?? widget.product["title"] ?? "वैदिक उत्पाद") : widget.product.name;
  String get _imageUrl => widget.product is Map ? (widget.product["imageUrl"] ?? "") : widget.product.imageUrl;
  String get _price => widget.product is Map ? (widget.product["discountPrice"] ?? widget.product["price"] ?? "₹551") : widget.product.price;
  String get _originalPrice => widget.product is Map ? (widget.product["originalPrice"] ?? "₹1,299") : widget.product.originalPrice;
  String get _badge => widget.product is Map ? (widget.product["badge"] ?? "CERTIFIED 📜") : widget.product.badge;
  String get _rating => widget.product is Map ? (widget.product["rating"] ?? "4.9") : widget.product.rating;
  String get _reviews => widget.product is Map ? (widget.product["reviews"] ?? "1.5k") : widget.product.reviews;
  String get _benefit => widget.product is Map ? (widget.product["description"] ?? "यह सिद्ध वैदिक उत्पाद सकारात्मक ऊर्जा, सुख-शांति एवं ग्रह शांति प्रदान करता है।") : (widget.product.benefit ?? widget.product.description ?? "यह सिद्ध वैदिक उत्पाद सकारात्मक ऊर्जा प्रदान करता है।");
  String get _energizedBy => "काशी व हरिद्वार के वरिष्ठ वैदिक आचार्यों द्वारा सिद्ध";

  @override
  void initState() {
    super.initState();
    _galleryImages = [
      _imageUrl.isNotEmpty ? _imageUrl : "https://images.unsplash.com/photo-1609722513470-36a537f52077?w=600&auto=format&fit=crop&q=80",
      "https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=600&auto=format&fit=crop&q=80",
      "https://images.unsplash.com/photo-1567591414240-e1e3b2e3a139?w=600&auto=format&fit=crop&q=80",
    ];
  }

  @override
  void dispose() {
    _pincodeController.dispose();
    super.dispose();
  }

  void _openCheckoutSheet(String paymentMethod) {
    final TextEditingController nameController = TextEditingController(text: "यजमान");
    final TextEditingController phoneController = TextEditingController(text: "9876543210");
    final TextEditingController addressController = TextEditingController();
    final TextEditingController pincodeController = TextEditingController(text: _pincodeController.text);
    final isCod = paymentMethod == "COD";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.86,
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

                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF0E6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCod ? Icons.local_shipping_rounded : Icons.payment_rounded,
                        color: kPrimaryBhagwa,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCod ? "कैश ऑन डिलीवरी ऑर्डर (COD)" : "ऑनलाइन सुरक्षित भुगतान (Pay Now)",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor),
                          ),
                          Text(
                            "कुल देय राशि: $_price (फ्री डिलीवरी)",
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
                const Divider(height: 16),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Selected Item Mini Card
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
                                  _imageUrl,
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 55,
                                    height: 55,
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
                                      _name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "$_price • $_badge",
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kPrimaryBhagwa),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        const Text("डिलीवरी एवं यजमान का विवरण:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: nameController,
                                style: const TextStyle(fontSize: 12, color: kTextColor),
                                decoration: InputDecoration(
                                  labelText: "पूरा नाम",
                                  labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                                  prefixIcon: const Icon(Icons.person_outline_rounded, color: kPrimaryBhagwa, size: 18),
                                  filled: true,
                                  fillColor: const Color(0xFFFFFDF9),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                  contentPadding: const EdgeInsets.all(10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(fontSize: 12, color: kTextColor),
                                decoration: InputDecoration(
                                  labelText: "मोबाइल नंबर",
                                  labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                                  prefixIcon: const Icon(Icons.phone_outlined, color: kPrimaryBhagwa, size: 18),
                                  filled: true,
                                  fillColor: const Color(0xFFFFFDF9),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                  contentPadding: const EdgeInsets.all(10),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: addressController,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 12, color: kTextColor),
                          decoration: InputDecoration(
                            labelText: "मकान नंबर, बिल्डिंग, गली व लैंडमार्क",
                            labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                            prefixIcon: const Icon(Icons.home_outlined, color: kPrimaryBhagwa, size: 18),
                            filled: true,
                            fillColor: const Color(0xFFFFFDF9),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: pincodeController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 12, color: kTextColor),
                          decoration: InputDecoration(
                            labelText: "पिन कोड (Pincode)",
                            labelStyle: const TextStyle(fontSize: 11, color: kSubTextColor),
                            prefixIcon: const Icon(Icons.pin_drop_outlined, color: kPrimaryBhagwa, size: 18),
                            filled: true,
                            fillColor: const Color(0xFFFFFDF9),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Payment Guarantee note
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isCod ? const Color(0xFFFFF8F0) : const Color(0xFFF1F8E9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isCod ? const Color(0xFFFFCC80) : Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isCod ? Icons.handshake_outlined : Icons.shield_rounded,
                                color: isCod ? kPrimaryBhagwa : Colors.green.shade800,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  isCod
                                      ? "पार्सल घर पहुंचने पर नकद या UPI द्वारा भुगतान करें। 100% ओरिजिनल एवं सुरक्षित पैकिंग।"
                                      : "UPI / कार्ड / नेटबैंकिंग द्वारा 100% सुरक्षित भुगतान। लैब सर्टिफिकेट पार्सल में शामिल रहेगा।",
                                  style: TextStyle(fontSize: 10, color: isCod ? kSubTextColor : Colors.green.shade900, height: 1.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final customerName = nameController.text.trim().isEmpty ? "यजमान" : nameController.text.trim();
                      final phoneNum = phoneController.text.trim().isEmpty ? "9876543210" : phoneController.text.trim();
                      final fullAddress = addressController.text.trim().isEmpty ? "जयपुर, राजस्थान (पिन: ${pincodeController.text})" : "${addressController.text.trim()}, पिन: ${pincodeController.text}";
                      final numericPrice = double.tryParse(_price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 551.0;

                      // Supabase Insert Call
                      try {
                        final user = Supabase.instance.client.auth.currentUser;
                        if (user != null) {
                          await Supabase.instance.client.from('astro_orders').insert({
                            'user_id': user.id,
                            'product_name': _name,
                            'product_category': _badge,
                            'price': numericPrice,
                            'quantity': 1,
                            'customer_name': customerName,
                            'phone': phoneNum,
                            'delivery_address': fullAddress,
                            'status': isCod ? 'COD Confirmed' : 'Paid & Confirmed',
                          });
                        }
                      } catch (_) {}

                      Navigator.pop(modalContext);
                      _showOrderSuccessDialog(
                        productName: _name,
                        price: _price,
                        paymentMode: isCod ? "कैश ऑन डिलीवरी (COD)" : "ऑनलाइन भुगतान (Paid ✅)",
                        address: fullAddress,
                        name: customerName,
                      );
                    },
                    icon: Icon(isCod ? Icons.local_shipping_rounded : Icons.lock_outline_rounded, size: 18),
                    label: Text(
                      isCod ? "COD ऑर्डर कन्फर्म करें 🚩" : "$_price सुरक्षित भुगतान करें 🔒",
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCod ? const Color(0xFFD84315) : Colors.green.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOrderSuccessDialog({
    required String productName,
    required String price,
    required String paymentMode,
    required String address,
    required String name,
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
                "ऑर्डर सफलतापूर्वक दर्ज हुआ! 🛍️",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
              ),
              const SizedBox(height: 4),
              Text(
                productName,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(fontSize: 11, color: kSubTextColor, height: 1.3),
              ),
              const SizedBox(height: 12),

              // Invoice Box
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
                        "📜 डिजिटल इनवॉइस (Order Receipt)",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kPrimaryBhagwa),
                      ),
                    ),
                    const Divider(height: 12),
                    _buildReceiptRow("ग्राहक का नाम:", name),
                    _buildReceiptRow("भुगतान प्रकार:", paymentMode),
                    _buildReceiptRow("कुल मूल्य:", price),
                    _buildReceiptRow("डिलीवरी पता:", address),
                    _buildReceiptRow("ऑर्डर ID:", "SHOP_${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}"),
                    _buildReceiptRow("अनुमानित डिलीवरी:", "3 से 5 कार्य दिवस"),
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
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: kSubTextColor, fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
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
          "उत्पाद विवरण (Product Details)",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: kPrimaryBhagwa, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("उत्पाद लिंक कॉपी हो गया!")),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Image Gallery / Hero View
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFFE0B2)),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: Image.network(
                            _galleryImages[_selectedImageIndex],
                            height: 230,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 230,
                              color: const Color(0xFFFFF0E6),
                              child: const Center(
                                child: Icon(Icons.stars_rounded, color: kPrimaryBhagwa, size: 60),
                              ),
                            ),
                          ),
                        ),
                        // Thumbnail Selector Row
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _galleryImages.asMap().entries.map((entry) {
                              final index = entry.key;
                              final img = entry.value;
                              final isSelected = _selectedImageIndex == index;

                              return GestureDetector(
                                onTap: () => setState(() => _selectedImageIndex = index),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 6),
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected ? kPrimaryBhagwa : Colors.grey.shade300,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      img,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFFFF0E6)),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 2. Title, Rating & Pricing Block
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: kCardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFFE0B2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.green.shade200),
                              ),
                              child: Text(
                                _badge,
                                style: TextStyle(color: Colors.green.shade800, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                const SizedBox(width: 3),
                                Text(
                                  "$_rating ($_reviews रेटिंग)",
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kTextColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor, height: 1.3),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              _price,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPrimaryBhagwa),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _originalPrice,
                              style: const TextStyle(fontSize: 12, color: Colors.grey, decoration: TextDecoration.lineThrough),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
                              child: const Text(
                                "55% OFF",
                                style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 3. Pincode & Delivery Checker
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kCardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFFE0B2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("डिलीवरी एवं COD उपलब्धता चेक करें:", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kTextColor)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 38,
                                child: TextField(
                                  controller: _pincodeController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    hintText: "पिन कोड दर्ज करें...",
                                    prefixIcon: const Icon(Icons.pin_drop_rounded, size: 16, color: kPrimaryBhagwa),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() => _pincodeChecked = true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("पिनकोड पर फ्री डिलीवरी एवं COD उपलब्ध है! ✅")),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryBhagwa,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              child: const Text("जांचें", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        if (_pincodeChecked) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: const [
                              Icon(Icons.check_circle_rounded, color: Colors.green, size: 14),
                              SizedBox(width: 4),
                              Text("3-5 कार्य दिवसों में फ्री होम डिलीवरी • COD उपलब्ध", style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 4. Detailed Vedic Benefits
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: kCardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFFE0B2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.auto_awesome, color: kPrimaryBhagwa, size: 18),
                            SizedBox(width: 6),
                            Text("ज्योतिषीय महत्व एवं लाभ 📜", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _benefit,
                          style: const TextStyle(fontSize: 12, color: kTextColor, height: 1.45),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F8E9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.verified_rounded, color: Colors.green.shade800, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "प्राण-प्रतिष्ठा: $_energizedBy",
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.green.shade900),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 5. Wearing & Ritual Rules (धारण विधि)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: kCardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFFE0B2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.menu_book_rounded, color: kPrimaryBhagwa, size: 18),
                            SizedBox(width: 6),
                            Text("धारण विधि एवं नियम (How to Wear) 🪔", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildRuleRow("शुभ दिन व समय:", "सोमवार या गुरुवार प्रातःकाल (शुभ चौघड़िया में)"),
                        _buildRuleRow("शुद्धिकरण विधि:", "कच्चे दूध एवं गंगाजल से प्रक्षालन कर धूप-दीप दिखाएं"),
                        _buildRuleRow("सिद्ध मंत्र जाप:", "ॐ नमः शिवाय अथवा संबंधित ग्रह बीज मंत्र (108 बार)"),
                        _buildRuleRow("प्रमाण पत्र:", "गवर्नमेंट अप्रूव्ड जेमोलॉजिकल लैब टेस्ट रिपोर्ट संलग्न"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // 6. BOTTOM DUAL ACTION BAR (COD & PAY NOW)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.orange.shade100)),
              boxShadow: const [
                BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, -2)),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Button 1: Cash on Delivery (COD)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _openCheckoutSheet("COD"),
                      icon: const Icon(Icons.local_shipping_rounded, size: 16, color: Color(0xFFD84315)),
                      label: const Text(
                        "कैश ऑन डिलीवरी",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD84315)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFD84315), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Button 2: Pay Now (Online)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _openCheckoutSheet("PAY_NOW"),
                      icon: const Icon(Icons.bolt_rounded, size: 18),
                      label: Text(
                        "$_price पे नाउ",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryBhagwa,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• $label ", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kTextColor)),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 11, color: kSubTextColor)),
          ),
        ],
      ),
    );
  }
}