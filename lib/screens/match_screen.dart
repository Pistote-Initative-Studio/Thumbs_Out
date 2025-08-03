import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/countdown_overlay.dart';
import '../widgets/tap_flash_overlay.dart';
import '../services/local_storage_service.dart';
import 'result_screen.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  int blueCount = 0;
  int redCount = 0;
  bool blueFlash = false;
  bool redFlash = false;
  bool matchActive = false;
  String? countdownText = '3';
  Timer? _countdownTimer;
  Timer? _matchTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    int count = 3;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (count > 1) {
        setState(() {
          count--;
          countdownText = '$count';
        });
      } else {
        timer.cancel();
        setState(() {
          countdownText = 'FIGHT';
        });
        Future.delayed(const Duration(milliseconds: 700), () {
          setState(() {
            countdownText = null;
            matchActive = true;
          });
          _startMatch();
        });
      }
    });
  }

  void _startMatch() {
    _matchTimer = Timer(const Duration(seconds: 10), _endMatch);
  }

  void _endMatch() {
    setState(() {
      matchActive = false;
    });
    final best = LocalStorageService().updateBest(blueCount, redCount);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          blueCount: blueCount,
          redCount: redCount,
          best: best,
        ),
      ),
    );
  }

  void _tapBlue() {
    if (!matchActive) return;
    setState(() {
      blueCount++;
      blueFlash = true;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => blueFlash = false);
      }
    });
  }

  void _tapRed() {
    if (!matchActive) return;
    setState(() {
      redCount++;
      redFlash = true;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => redFlash = false);
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _matchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _tapBlue,
                  child: Container(
                    color: Colors.blue[100],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _tapRed,
                  child: Container(
                    color: Colors.red[100],
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Expanded(
                child: TapFlashOverlay(
                  active: blueFlash,
                  color: Colors.blueAccent,
                  alignment: Alignment.topCenter,
                ),
              ),
              Expanded(
                child: TapFlashOverlay(
                  active: redFlash,
                  color: Colors.redAccent,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
          if (countdownText != null)
            CountdownOverlay(text: countdownText!),
        ],
      ),
    );
  }
}
