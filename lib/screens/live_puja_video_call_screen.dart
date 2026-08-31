import 'package:flutter/material.dart';

class LivePujaVideoCallScreen extends StatelessWidget {
  final String pujaTitle;
  final String panditName;
  final String slotTime;

  const LivePujaVideoCallScreen({
    super.key,
    required this.pujaTitle,
    required this.panditName,
    required this.slotTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pujaTitle, style: const TextStyle(fontSize: 13, color: Colors.white)),
            Text("आचार्य: $panditName • स्लॉट: $slotTime", style: const TextStyle(fontSize: 10, color: Colors.orangeAccent)),
          ],
        ),
      ),
      body: Stack(
        children: [
          // यहाँ वीडियो स्ट्रीमिंग या Agora/Jitsi/Zoom का वीडियो व्यू आएगा
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.live_tv_rounded, size: 64, color: Colors.orangeAccent),
                const SizedBox(height: 16),
                const Text(
                  "पंडित जी के साथ लाइव पूजा कनेक्ट हो रही है...\nकृपया अपने कैमरे और माइक की अनुमति दें।",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 30),
                // यदि आप Agora या WebRTC पैकेज इस्तेमाल कर रहे हैं, तो उसका वीडियो विजेट यहाँ रेंडर होगा
              ],
            ),
          ),

          // नीचे कंट्रोल बटन (म्यूट, वीडियो ऑन/ऑफ, कॉल काटें)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: "mic",
                  backgroundColor: Colors.white24,
                  onPressed: () {},
                  child: const Icon(Icons.mic_rounded, color: Colors.white),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: "end_call",
                  backgroundColor: Colors.red,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(Icons.call_end_rounded, color: Colors.white),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: "camera",
                  backgroundColor: Colors.white24,
                  onPressed: () {},
                  child: const Icon(Icons.videocam_rounded, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}