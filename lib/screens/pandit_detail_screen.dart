import 'package:flutter/material.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kDeepSaffron = Color(0xFFFF5722);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kBgColor = Color(0xFFFFF9F4);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF2E1500);
const Color kSubTextColor = Color(0xFF795548);

class PanditReviewItem {
  final String userName;
  final String rating;
  final String date;
  final String comment;

  const PanditReviewItem({
    required this.userName,
    required this.rating,
    required this.date,
    required this.comment,
  });
}

class PanditDetailScreen extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String tradition;
  final String experience; // 👈 Correct parameter name
  final String city;
  final String dakshina;
  final double rating;
  final String completedPujas;
  final String followers;

  const PanditDetailScreen({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.tradition,
    required this.experience,
    required this.city,
    required this.dakshina,
    required this.rating,
    required this.completedPujas,
    required this.followers,
  });

  @override
  State<PanditDetailScreen> createState() => _PanditDetailScreenState();
}

class _PanditDetailScreenState extends State<PanditDetailScreen> {
  bool _isFollowing = false;

  final List<PanditReviewItem> _reviews = const [
    PanditReviewItem(
      userName: "संदीप शर्मा",
      rating: "5.0",
      date: "24 अगस्त 2026",
      comment: "पं. जी ने घर पर सत्यनारायण भगवान की कथा और हवन बहुत ही विधि-विधान से संपन्न कराया। मंत्रोच्चार अत्यंत स्पष्ट था।",
    ),
    PanditReviewItem(
      userName: "विकास खंडेलवाल",
      rating: "4.9",
      date: "18 अगस्त 2026",
      comment: "गृह प्रवेश के समय वास्तु शांति और रुद्राभिषेक बहुत अच्छे से हुआ। सभी यजमान संतुष्ट रहे।",
    ),
    PanditReviewItem(
      userName: "अमित कुमार",
      rating: "5.0",
      date: "10 अगस्त 2026",
      comment: "उत्कृष्ट वैदिक ब्राह्मण! समय के पाबंद और सनातन परंपरा के ज्ञाता।",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> profileImages = [
      widget.imageUrl,
      "https://images.unsplash.com/photo-1544717305-2782549b5136?w=400&auto=format&fit=crop&q=80",
      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&auto=format&fit=crop&q=80",
      "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&auto=format&fit=crop&q=80",
      "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&auto=format&fit=crop&q=80",
    ];

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
            // 1. MAIN PROFILE CARD
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
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(widget.imageUrl),
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
                            Text("📍 ${widget.city} • ${widget.experience}", style: const TextStyle(fontSize: 11, color: kSubTextColor)),
                            const SizedBox(height: 2),
                            Text("संपूर्ण पूजा अनुभव: ${widget.completedPujas} सम्पन्न", style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        ),
                      ),
                      // Follow Button
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isFollowing = !_isFollowing;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(_isFollowing ? "आपने ${widget.name} को फॉलो कर लिया है! 🪔" : "अनफॉलो किया गया")),
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

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFFCC80)),
                    ),
                    child: Text("📜 ${widget.tradition}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kPrimaryBhagwa)),
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
                          Text(widget.rating.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kTextColor)),
                        ],
                      ),
                      Text("प्रारंभिक दक्षिणा: ${widget.dakshina}", style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.green)),
                      Row(
                        children: [
                          const Icon(Icons.people_alt_rounded, color: Colors.blue, size: 15),
                          const SizedBox(width: 4),
                          Text("${widget.followers} Followers", style: const TextStyle(fontSize: 11, color: kSubTextColor, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. PHOTOS GALLERY
            const Text("आचार्य जी की गैलरी (Photos)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor)),
            const SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: profileImages.length,
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
                        profileImages[index],
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

            // 3. DETAILED BIO
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
                  const Text("आचार्य जी का परिचय एवं बायो (Bio)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor)),
                  const SizedBox(height: 8),
                  Text(
                    "मैं काशी एवं सनातन वैदिक परंपरा के अंतर्गत पिछले कई वर्षों से गृह प्रवेश, सत्यनारायण व्रत कथा, रुद्राभिषेक, विवाह संस्कार एवं महामृत्युंजय अनुष्ठान पूरे विधि-विधान से संपन्न करवा रहा हूँ। मेरा उद्देश्य हर यजमान के घर में सकारात्मक ऊर्जा और धार्मिक अनुष्ठान की दिव्यता बनाए रखना है।",
                    style: const TextStyle(fontSize: 11.5, color: kSubTextColor, height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 4. CLIENT REVIEWS
            const Text("यजमान समीक्षाएं (Client Reviews)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextColor)),
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
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(rev.date, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                    ),
                  ],
                ),
              )).toList(),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}