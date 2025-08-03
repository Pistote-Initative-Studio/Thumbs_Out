import 'package:flutter/material.dart';

import 'match_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: ElevatedButton(
          child: const Text('Start'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MatchScreen()),
            );
          },
        ),
      ),
    );
  }
}
