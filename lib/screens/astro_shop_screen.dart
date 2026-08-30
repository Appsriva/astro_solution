import 'package:flutter/material.dart';
import 'product_detail_screen.dart';

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

class ShopCategory {
  final String id;
  final String name;
  final String subtitle;
  final String itemCount;
  final String imageUrl;
  final List<Color> gradient;

  const ShopCategory({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.itemCount,
    required this.imageUrl,
    required this.gradient,
  });
}

class AstroShopScreen extends StatefulWidget {
  const AstroShopScreen({super.key});

  @override
  State<AstroShopScreen> createState() => _AstroShopScreenState();
}

class _AstroShopScreenState extends State<AstroShopScreen> {
  String? _selectedCategoryId;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  static const List<ShopCategory> _categories = [
    ShopCategory(
      id: "cat_rudraksha",
      name: "सिद्ध रुद्राक्ष (Rudraksha)",
      subtitle: "1 से 14 मुखी नेपाल व इंडोनेशियाई सर्टिफाइड रुद्राक्ष",
      itemCount: "42+ उत्पाद",
      imageUrl: "https://images.unsplash.com/photo-1609722513470-36a537f52077?w=600&auto=format&fit=crop&q=80",
      gradient: [Color(0xFFE65100), Color(0xFFFF8F00)],
    ),
    ShopCategory(
      id: "cat_gemstones",
      name: "प्राकृतिक रत्न (Gemstones)",
      subtitle: "100% लैब टेस्टेड नीलम, पुखराज, पन्ना, माणिक्य",
      itemCount: "38+ उत्पाद",
      imageUrl: "https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=600&auto=format&fit=crop&q=80",
      gradient: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
    ),
    ShopCategory(
      id: "cat_bracelets",
      name: "ऊर्जावान ब्रेसलेट (Bracelets)",
      subtitle: "7 चक्र, लावा स्टोन, टाइगर आई, स्फटिक व पाइराइट",
      itemCount: "56+ उत्पाद",
      imageUrl: "https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?w=600&auto=format&fit=crop&q=80",
      gradient: [Color(0xFF004D40), Color(0xFF00897B)],
    ),
    ShopCategory(
      id: "cat_yantras",
      name: "सिद्ध श्रीयंत्र व कवच (Yantras)",
      subtitle: "प्राण प्रतिष्ठित महालक्ष्मी श्रीयंत्र, कुबेर व नवग्रह यंत्र",
      itemCount: "29+ उत्पाद",
      imageUrl: "https://images.unsplash.com/photo-1544717305-2782549b5136?w=600&auto=format&fit=crop&q=80",
      gradient: [Color(0xFFB71C1C), Color(0xFFE53935)],
    ),
    ShopCategory(
      id: "cat_malas",
      name: "जाप मालाएं (Japa Malas)",
      subtitle: "तुलसी, कमल गट्टा, वैजयंती व स्फटिक की मालाएं",
      itemCount: "24+ उत्पाद",
      imageUrl: "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&auto=format&fit=crop&q=80",
      gradient: [Color(0xFF880E4F), Color(0xFFD81B60)],
    ),
    ShopCategory(
      id: "cat_dhoop",
      name: "हवन एवं पूजा सामग्री (Puja Samagri)",
      subtitle: "शुद्ध गुग्गल, लोबान, भीमसेनी कपूर व नवग्रह समिधा",
      itemCount: "31+ उत्पाद",
      imageUrl: "https://images.unsplash.com/photo-1532274402911-5a369e4c4bb5?w=600&auto=format&fit=crop&q=80",
      gradient: [Color(0xFFBF360C), Color(0xFFFF5722)],
    ),
  ];

  static const List<Map<String, dynamic>> _allProducts = [
    {
      "id": "p_1",
      "categoryId": "cat_rudraksha",
      "title": "ओरिजिनल नेपाली 5 मुखी रुद्राक्ष माला (108+1 दाने)",
      "name": "ओरिजिनल नेपाली 5 मुखी रुद्राक्ष माला (108+1 दाने)",
      "originalPrice": "₹1,299",
      "discountPrice": "₹551",
      "price": "551",
      "rating": "4.9",
      "reviews": "2.4k",
      "badge": "LAB CERTIFIED 📜",
      "imageUrl": "https://images.unsplash.com/photo-1609722513470-36a537f52077?w=400&auto=format&fit=crop&q=80",
      "description": "भगवान शिव का अत्यंत प्रिय 5 मुखी रुद्राक्ष जो मन को शांति और सकारात्मक ऊर्जा प्रदान करता है।",
    },
    {
      "id": "p_2",
      "categoryId": "cat_rudraksha",
      "title": "प्राकृतिक 7 मुखी महालक्ष्मी रुद्राक्ष (नेपाली)",
      "name": "प्राकृतिक 7 मुखी महालक्ष्मी रुद्राक्ष (नेपाली)",
      "originalPrice": "₹2,499",
      "discountPrice": "₹1,199",
      "price": "1199",
      "rating": "5.0",
      "reviews": "1.1k",
      "badge": "BESTSELLER 🌟",
      "imageUrl": "https://images.unsplash.com/photo-1544717305-2782549b5136?w=400&auto=format&fit=crop&q=80",
      "description": "माता महालक्ष्मी का स्वरूप माना जाने वाला 7 मुखी रुद्राक्ष आर्थिक उन्नति और व्यापार में लाभ देता है।",
    },
    {
      "id": "p_3",
      "categoryId": "cat_rudraksha",
      "title": "सिद्ध 1 मुखी काजू दाना रुद्राक्ष लॉकेट",
      "name": "सिद्ध 1 मुखी काजू दाना रुद्राक्ष लॉकेट",
      "originalPrice": "₹3,999",
      "discountPrice": "₹1,850",
      "price": "1850",
      "rating": "4.8",
      "reviews": "820",
      "badge": "RARE SACRED ✨",
      "imageUrl": "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=400&auto=format&fit=crop&q=80",
      "description": "साक्षात शिव स्वरूप 1 मुखी रुद्राक्ष धारण करने से एकाग्रता और मोक्ष की प्राप्ति होती है।",
    },
    {
      "id": "p_4",
      "categoryId": "cat_gemstones",
      "title": "प्राकृतिक सिलोन पीला पुखराज रत्न (Yellow Sapphire)",
      "name": "प्राकृतिक सिलोन पीला पुखराज रत्न (Yellow Sapphire)",
      "originalPrice": "₹5,999",
      "discountPrice": "₹2,499",
      "price": "2499",
      "rating": "4.9",
      "reviews": "1.9k",
      "badge": "100% ORIGINAL 💎",
      "imageUrl": "https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=400&auto=format&fit=crop&q=80",
      "description": "गुरु बृहस्पति का शक्तिशाली रत्न जो ज्ञान, धन और वैवाहिक सुख प्रदान करता है।",
    },
    {
      "id": "p_5",
      "categoryId": "cat_gemstones",
      "title": "नेचुरल जाम्बियन पन्ना रत्न (Emerald)",
      "name": "नेचुरल जाम्बियन पन्ना रत्न (Emerald)",
      "originalPrice": "₹4,500",
      "discountPrice": "₹2,100",
      "price": "2100",
      "rating": "4.8",
      "reviews": "1.3k",
      "badge": "CERTIFIED 📜",
      "imageUrl": "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=400&auto=format&fit=crop&q=80",
      "description": "बुध ग्रह का कारक रत्न जो बुद्धि, वाणी और व्यापारिक निर्णय क्षमता को मजबूत करता है।",
    },
    {
      "id": "p_6",
      "categoryId": "cat_bracelets",
      "title": "7 चक्र ओरिजिनल हीलिंग क्रिस्टल ब्रेसलेट",
      "name": "7 चक्र ओरिजिनल हीलिंग क्रिस्टल ब्रेसलेट",
      "originalPrice": "₹899",
      "discountPrice": "₹399",
      "price": "399",
      "rating": "4.85",
      "reviews": "3.6k",
      "badge": "TRENDING 🔥",
      "imageUrl": "https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?w=400&auto=format&fit=crop&q=80",
      "description": "शरीर के सातों चक्रों को संतुलित कर सकारात्मक ऊर्जा और सुरक्षा कवच प्रदान करता है।",
    },
    {
      "id": "p_7",
      "categoryId": "cat_bracelets",
      "title": "धन आकर्षण पाइराइट ब्रेसलेट (Fool's Gold)",
      "name": "धन आकर्षण पाइराइट ब्रेसलेट (Fool's Gold)",
      "originalPrice": "₹1,199",
      "discountPrice": "₹499",
      "price": "499",
      "rating": "4.9",
      "reviews": "2.8k",
      "badge": "MONEY MAGNET 🪙",
      "imageUrl": "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400&auto=format&fit=crop&q=80",
      "description": "धन, समृद्धि और नए व्यापारिक अवसरों को आकर्षित करने वाला सिद्ध पाइराइट ब्रेसलेट।",
    },
    {
      "id": "p_8",
      "categoryId": "cat_yantras",
      "title": "24K स्वर्ण परत श्री संपूर्ण महालक्ष्मी यंत्र",
      "name": "24K स्वर्ण परत श्री संपूर्ण महालक्ष्मी यंत्र",
      "originalPrice": "₹1,499",
      "discountPrice": "₹751",
      "price": "751",
      "rating": "5.0",
      "reviews": "1.5k",
      "badge": "PRAN PRATISHTHIT 🪔",
      "imageUrl": "https://images.unsplash.com/photo-1544717305-2782549b5136?w=400&auto=format&fit=crop&q=80",
      "description": "घर व व्यापारिक स्थल पर सुख, शांति और अखंड लक्ष्मी वास के लिए प्राण-प्रतिष्ठित श्रीयंत्र।",
    },
    {
      "id": "p_9",
      "categoryId": "cat_malas",
      "title": "ओरिजिनल वृंदावन तुलसी कंठी व जाप माला",
      "name": "ओरिजिनल वृंदावन तुलसी कंठी व जाप माला",
      "originalPrice": "₹499",
      "discountPrice": "₹251",
      "price": "251",
      "rating": "4.95",
      "reviews": "4.2k",
      "badge": "VRINDAVAN SPECIAL 🌿",
      "imageUrl": "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=400&auto=format&fit=crop&q=80",
      "description": "पवित्र श्यामा तुलसी से निर्मित कंठी माला जो भगवान विष्णु और श्रीकृष्ण की विशेष कृपा दिलाती है।",
    },
    {
      "id": "p_10",
      "categoryId": "cat_dhoop",
      "title": "शुद्ध भीमसेनी कपूर एवं वैदिक गुग्गल धूप बत्ती पैक",
      "name": "शुद्ध भीमसेनी कपूर एवं वैदिक गुग्गल धूप बत्ती पैक",
      "originalPrice": "₹650",
      "discountPrice": "₹349",
      "price": "349",
      "rating": "4.8",
      "reviews": "1.7k",
      "badge": "NATURAL AROMA 🌸",
      "imageUrl": "https://images.unsplash.com/photo-1532274402911-5a369e4c4bb5?w=400&auto=format&fit=crop&q=80",
      "description": "घर की नकारात्मक ऊर्जा को दूर करने और वास्तु दोष शांति के लिए 100% प्राकृतिक धूप।",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openProductDetail(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          product: product,
        ),
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
        leading: _selectedCategoryId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPrimaryBhagwa, size: 20),
                onPressed: () => setState(() => _selectedCategoryId = null),
              )
            : null,
        title: Text(
          _selectedCategoryId == null
              ? "AstroShop - वैदिक स्टोर 🛍️"
              : _categories.firstWhere((c) => c.id == _selectedCategoryId).name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: kPrimaryBhagwa),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("आपका कार्ट सुरक्षित है!"), backgroundColor: kPrimaryBhagwa),
              );
            },
          ),
        ],
      ),
      body: _selectedCategoryId == null ? _buildCategoryHubView() : _buildCategoryProductsView(),
    );
  }

  Widget _buildCategoryHubView() {
    final filteredCategories = _categories.where((c) {
      if (_searchQuery.isEmpty) return true;
      return c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            style: const TextStyle(fontSize: 12, color: kTextColor),
            onChanged: (val) {
              setState(() {
                _searchQuery = val.trim();
              });
            },
            decoration: InputDecoration(
              hintText: "रुद्राक्ष, रत्न, ब्रेसलेट, श्रीयंत्र खोजें...",
              hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
              prefixIcon: const Icon(Icons.search_rounded, color: kPrimaryBhagwa, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = "");
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFFFE0B2))),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0E6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _TrustBadge(icon: Icons.verified_user_rounded, text: "100% ओरिजिनल"),
                _TrustBadge(icon: Icons.science_rounded, text: "लैब टेस्टेड"),
                _TrustBadge(icon: Icons.auto_awesome_rounded, text: "प्राण प्रतिष्ठित"),
                _TrustBadge(icon: Icons.local_shipping_rounded, text: "फ्री डिलीवरी"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text("श्रेणियां चुनें (Select Category) 🔱", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor)),
          const SizedBox(height: 10),
          ...filteredCategories.map((category) {
            return GestureDetector(
              onTap: () => setState(() => _selectedCategoryId = category.id),
              child: Container(
                height: 135,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(colors: category.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  boxShadow: [
                    BoxShadow(color: category.gradient.first.withAlpha(90), blurRadius: 8, offset: const Offset(0, 4)),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: 140,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(22)),
                        child: ShaderMask(
                          shaderCallback: (rect) {
                            return const LinearGradient(
                              colors: [Colors.transparent, Colors.black],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.dstIn,
                          child: Image.network(
                            category.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(color: Colors.white24),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 120, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                            decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(8)),
                            child: Text(category.itemCount, style: const TextStyle(color: kGoldAccent, fontSize: 9.5, fontWeight: FontWeight.bold)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(category.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(category.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.2)),
                            ],
                          ),
                          Row(
                            children: const [
                              Text("उत्पाद देखें", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCategoryProductsView() {
    final products = _allProducts.where((p) => p["categoryId"] == _selectedCategoryId).toList();

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat.id == _selectedCategoryId;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategoryId = cat.id),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? kPrimaryBhagwa : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? kPrimaryBhagwa : Colors.orange.shade200),
                    ),
                    child: Center(
                      child: Text(
                        cat.name.split(" ").first,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : kTextColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () => _openProductDetail(product),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.orange.shade100),
                    boxShadow: kCardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                            child: Image.network(
                              product["imageUrl"],
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 120,
                                color: const Color(0xFFFFF0E6),
                                child: const Icon(Icons.shopping_bag_rounded, color: kPrimaryBhagwa, size: 36),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.black.withAlpha(180), borderRadius: BorderRadius.circular(6)),
                              child: Text(product["badge"], style: const TextStyle(color: kGoldAccent, fontSize: 7.5, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product["name"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: kTextColor, height: 1.2),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: kGoldAccent, size: 13),
                                Text(" ${product["rating"]} (${product["reviews"]})", style: const TextStyle(fontSize: 9.5, color: kSubTextColor, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(product["discountPrice"], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green)),
                                const SizedBox(width: 4),
                                Text(product["originalPrice"], style: const TextStyle(fontSize: 10, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: 30,
                              child: ElevatedButton(
                                onPressed: () => _openProductDetail(product),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryBhagwa,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text("अभी खरीदें", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TrustBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: kPrimaryBhagwa),
        const SizedBox(width: 3),
        Text(text, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: kTextColor)),
      ],
    );
  }
}