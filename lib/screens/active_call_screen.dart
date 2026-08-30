import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Color kPrimaryBhagwa = Color(0xFFFF6F00);
const Color kGoldAccent = Color(0xFFFFD700);
const Color kTextColor = Color(0xFF2E1500);

class ActiveCallScreen extends StatefulWidget {
  final String astrologerName;
  final String astrologerRole;
  final String packageName;
  final int totalMinutes;

  const ActiveCallScreen({
    super.key,
    required this.astrologerName,
    required this.astrologerRole,
    required this.packageName,
    required this.totalMinutes,
  });

  @override
  State<ActiveCallScreen> createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends State<ActiveCallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool _isRinging = true;
  String _callStatusText = "डायल हो रहा है...";
  Timer? _ringingTimer;
  Timer? _callTimer;
  int _callSeconds = 0;

  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isVideoOn = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _callStatusText = "घंटी जा रही है (Ringing)... 🔔");
      }
    });

    _ringingTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isRinging = false;
          _callStatusText = "कॉल कनेक्टेड 🟢";
        });
        _pulseController.stop();
        _startCallTimer();
      }
    });
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _callSeconds++);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ringingTimer?.cancel();
    _callTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  Future<void> _endCall() async {
    _ringingTimer?.cancel();
    _callTimer?.cancel();

    // 1. Save Call Session in Supabase call_logs Table (Only if call was active/connected >= 1 second)
    if (_callSeconds > 0) {
      try {
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          // ₹ के ठीक बाद वाली मुख्य कीमत निकालना (जैसे ₹50, ₹155, ₹299, ₹1100 आदि)
          final match = RegExp(r'₹\s*(\d[\d,]*)').firstMatch(widget.packageName);
          final priceString = match != null ? match.group(1)!.replaceAll(',', '') : '50';
          final numericAmount = double.tryParse(priceString) ?? 50.0;

          await Supabase.instance.client.from('call_logs').insert({
            'user_id': user.id,
            'astrologer_name': widget.astrologerName,
            'call_type': _isVideoOn ? 'Video' : 'Audio',
            'duration_seconds': _callSeconds,
            'amount_deducted': numericAmount,
            'status': 'Completed',
          });
        }
      } catch (_) {}
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("परामर्श संपन्न हुआ 🚩", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ज्योतिषी: ${widget.astrologerName}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("सक्रिय पैक: ${widget.packageName}", style: const TextStyle(fontSize: 12, color: kPrimaryBhagwa, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("कुल बातचीत का समय: ${_formatDuration(_callSeconds)}", style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBhagwa, foregroundColor: Colors.white),
            child: const Text("होम पर जाएं"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B0C02),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        const Icon(Icons.workspace_premium_rounded, color: kGoldAccent, size: 16),
                        const SizedBox(width: 6),
                        Text(widget.packageName, style: const TextStyle(color: kGoldAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isRinging ? Colors.amber.shade900.withAlpha(150) : Colors.green.shade900.withAlpha(150),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _isRinging ? "कनेक्टिंग..." : "लाइव सेशन ✅",
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_isRinging)
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 140 * _pulseAnimation.value,
                          height: 140 * _pulseAnimation.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kPrimaryBhagwa.withAlpha((180 / _pulseAnimation.value).toInt()),
                              width: 3,
                            ),
                          ),
                        );
                      },
                    ),
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryBhagwa.withAlpha(40),
                    ),
                  ),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kGoldAccent, width: 2.5),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFF2C1304),
                      child: Icon(Icons.person_rounded, size: 55, color: kGoldAccent),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.astrologerName,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              widget.astrologerRole,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _isRinging ? Colors.amber.shade900.withAlpha(120) : Colors.green.shade900.withAlpha(120),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _isRinging ? kGoldAccent : Colors.greenAccent),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _isRinging ? kGoldAccent : Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isRinging ? _callStatusText : _formatDuration(_callSeconds),
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: const BoxDecoration(
                color: Color(0xFF2A1405),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCallBtn(
                    icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    label: _isMuted ? "अनम्यूट" : "म्यूट",
                    isActive: _isMuted,
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                  _buildCallBtn(
                    icon: _isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                    label: "स्पीकर",
                    isActive: _isSpeakerOn,
                    onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                  ),
                  _buildCallBtn(
                    icon: _isVideoOn ? Icons.videocam_rounded : Icons.videocam_off_rounded,
                    label: "वीडियो",
                    isActive: _isVideoOn,
                    onTap: () => setState(() => _isVideoOn = !_isVideoOn),
                  ),
                  GestureDetector(
                    onTap: _endCall,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 26),
                        ),
                        const SizedBox(height: 6),
                        const Text("समाप्त", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallBtn({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isActive ? kPrimaryBhagwa : Colors.white12,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}