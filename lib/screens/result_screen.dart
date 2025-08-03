import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int blueCount;
  final int redCount;
  final int best;

  const ResultScreen({
    super.key,
    required this.blueCount,
    required this.redCount,
    required this.best,
  });

  @override
  Widget build(BuildContext context) {
    final winner = blueCount == redCount
        ? 'DRAW'
        : blueCount > redCount
            ? 'BLUE WINS!'
            : 'RED WINS!';
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              winner,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text('Blue: $blueCount'),
            Text('Red: $redCount'),
            const SizedBox(height: 20),
            Text('Best: $best'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}
