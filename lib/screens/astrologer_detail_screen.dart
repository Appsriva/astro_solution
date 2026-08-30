import 'package:flutter/material.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);

class ReviewItem {
  final String userName;
  final String rating;
  final String date;
  final String comment;

  const ReviewItem({
    required this.userName,
    required this.rating,
    required this.date,
    required this.comment,
  });
}

class AstrologerDetailScreen extends StatefulWidget {
  final String name;
  final String? imageUrl;
  final List<String>? profileImages;
  final String experience;
  final String skills;
  final String? tagline;
  final String? bio;
  final String rating;
  final String? followers;
  final String? status;
  final String? ratePerMin;

  const AstrologerDetailScreen({
    super.key,
    required this.name,
    this.imageUrl,
    this.profileImages,
    required this.experience,
    required this.skills,
    this.tagline,
    this.bio,
    required this.rating,
    this.followers,
    this.status,
    this.ratePerMin,
  });

  @override
  State<AstrologerDetailScreen> createState() => _AstrologerDetailScreenState();
}

class _AstrologerDetailScreenState extends State<AstrologerDetailScreen> {
  bool _isFollowing = false;

  final List<ReviewItem> _reviews = const [
    ReviewItem(
      userName: "अंकित शर्मा",
      rating: "5.0",
      date: "27 अगस्त 2026",
      comment: "गुरु जी ने विवाह और करियर को लेकर बहुत ही सटीक भविष्यवाणी की।",
    ),
    ReviewItem(
      userName: "पूजा वर्मा",
      rating: "4.9",
      date: "25 अगस्त 2026",
      comment: "बेहतरीन परामर्श! बिना समय बर्बाद किए सीधे सटीक उपाय बताए गए।",
    ),
  ];

  void _sendGiftModal(String giftName, int amount) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("$giftName भेजा गया! 🙏", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kTextColor)),
        content: Text("आपने ${widget.name} जी को ₹$amount का $giftName सफलतापूर्वक अर्पित किया है।", style: const TextStyle(fontSize: 12, height: 1.4)),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBhagwa, foregroundColor: Colors.white),
            child: const Text("धन्वावाद"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagesList = widget.profileImages ?? [
      widget.imageUrl ?? "https://images.unsplash.com/photo-1544717305-2782549b5136?w=400&auto=format&fit=crop&q=80",
      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&auto=format&fit=crop&q=80",
      "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80",
      "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&auto=format&fit=crop&q=80",
    ];

    final currentStatus = widget.status ?? "Online";
    final skillsArray = widget.skills.split(",");

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPrimaryBhagwa, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. MAIN PROFILE CARD (Moved to Top)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFCC80)),
                boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Profile Avatar
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(imagesList.first),
                        backgroundColor: const Color(0xFFFFF0E6),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(widget.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor)),
                                const SizedBox(width: 4),
                                const Icon(Icons.verified_rounded, color: Colors.blue, size: 14),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text("अनुभव: ${widget.experience} • ${widget.followers ?? '12.4k'} Followers", style: const TextStyle(fontSize: 10.5, color: kSubTextColor)),
                          ],
                        ),
                      ),
                      // Highlighted Follow Button
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isFollowing = !_isFollowing;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(_isFollowing ? "आपने ${widget.name} को फॉलो कर लिया है! 🌟" : "अनफॉलो किया गया")),
                          );
                        },
                        icon: Icon(_isFollowing ? Icons.check_rounded : Icons.person_add_rounded, size: 14, color: Colors.white),
                        label: Text(_isFollowing ? "Following" : "+ Follow", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryBhagwa,
                          elevation: 3,
                          shadowColor: Colors.orange.withAlpha(120),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Astrologer Skills & Expertise Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: skillsArray.map((skill) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFCC80)),
                      ),
                      child: Text(skill.trim(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
                    )).toList(),
                  ),

                  const SizedBox(height: 10),
                  const Divider(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                          const SizedBox(width: 3),
                          Text(widget.rating, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                        ],
                      ),
                      Text("📌 ${widget.tagline ?? 'विशेषज्ञ वैदिक एवं ज्योतिष मार्गदर्शक'}", style: const TextStyle(fontSize: 10.5, fontStyle: FontStyle.italic, color: kSubTextColor)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. 5 PHOTOS GALLERY (Moved below container)
            const Text("ज्योतिषी गैलरी (Photos)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor)),
            const SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: imagesList.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 110,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFFCC80), width: 1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        imagesList[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFFFF0E6),
                          child: const Icon(Icons.person_rounded, size: 30, color: kPrimaryBhagwa),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // 3. Status Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: currentStatus == 'Online' ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: currentStatus == 'Online' ? Colors.green.shade300 : Colors.red.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 12, color: currentStatus == 'Online' ? Colors.green : Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    currentStatus == 'Online' ? "वर्तमान स्थिति: ऑनलाइन (परामर्श के लिए उपलब्ध)" : "वर्तमान स्थिति: व्यस्त / ऑफलाइन",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: currentStatus == 'Online' ? Colors.green.shade800 : Colors.red.shade800),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. SEND PRASAD / FLOWERS / DAKSHINA SECTION
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFFFB74D)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("प्रसाद, फूल-माला या दक्षिणा भेजें 🪔💐", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor)),
                  const SizedBox(height: 4),
                  const Text("गुरु जी को आशीर्वाद व सम्मान के रूप में डिजिटल फूल-माला या दक्षिणा अर्पित करें:", style: TextStyle(fontSize: 10.5, color: kSubTextColor)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildGiftButton("फूल-माला 🌸", 21),
                      _buildGiftButton("विशेष प्रसाद 🥥", 51),
                      _buildGiftButton("दक्षिणा 💰", 101),
                      _buildGiftButton("महा भोग 🍯", 501),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 5. Bio Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFFFCC80)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("ज्योतिषी का विस्तृत बायो (Bio)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor)),
                  const SizedBox(height: 8),
                  Text(
                    widget.bio ?? "मैं पिछले कई वर्षों से वैदिक ज्योतिष, कुंडली विश्लेषण और सनातन उपायों के माध्यम से लोगों के जीवन की कठिनाइयों को दूर करने में सहायता कर रहा हूँ।",
                    style: const TextStyle(fontSize: 11.5, color: kSubTextColor, height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 6. Reviews
            const Text("ग्राहक समीक्षाएं (Public Reviews)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor)),
            const SizedBox(height: 10),
            Column(
              children: _reviews.map((rev) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.orange.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(rev.userName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 13),
                            const SizedBox(width: 2),
                            Text(rev.rating, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kTextColor)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(rev.comment, style: const TextStyle(fontSize: 11, color: kSubTextColor, height: 1.3)),
                  ],
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGiftButton(String label, int amount) {
    return InkWell(
      onTap: () => _sendGiftModal(label, amount),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kPrimaryBhagwa),
          boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 3, offset: Offset(0, 2))],
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kTextColor)),
            const SizedBox(height: 2),
            Text("₹$amount", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
          ],
        ),
      ),
    );
  }
}