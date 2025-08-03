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
  int _player1Count = 0;
  int _player2Count = 0;
  bool _player1Flash = false;
  bool _player2Flash = false;
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
    final best = LocalStorageService().updateBest(_player1Count, _player2Count);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          blueCount: _player1Count,
          redCount: _player2Count,
          best: best,
        ),
      ),
    );
  }

  void _tapPlayer1() {
    if (!matchActive) return;
    setState(() {
      _player1Count++;
      _player1Flash = true;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _player1Flash = false);
      }
    });
  }

  void _tapPlayer2() {
    if (!matchActive) return;
    setState(() {
      _player2Count++;
      _player2Flash = true;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _player2Flash = false);
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
          Positioned.fill(
            child: Image.asset(
              'assets/images/pvpbackground.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.grey),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _tapPlayer1,
                  child: Container(color: Colors.transparent),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _tapPlayer2,
                  child: Container(color: Colors.transparent),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Expanded(
                child: TapFlashOverlay(
                  active: _player1Flash,
                  color: Colors.blueAccent,
                  alignment: Alignment.topCenter,
                ),
              ),
              Expanded(
                child: TapFlashOverlay(
                  active: _player2Flash,
                  color: Colors.redAccent,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
          if (countdownText != null) CountdownOverlay(text: countdownText!),
        ],
      ),
    );
  }
}