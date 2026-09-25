import 'package:flutter/material.dart';

class TriviaResultCard extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onDone;

  const TriviaResultCard({
    super.key,
    required this.score,
    required this.total,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF17163D),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events,
              color: Color(0xFFFFC107),
              size: 60,
            ),

            const SizedBox(height: 16),

            const Text(
              'Trivia Complete!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              '$score / $total',
              style: const TextStyle(
                color: Color(0xFF8FA8F5),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _getMessage(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onDone,
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMessage() {
    if (score == total) {
      return 'Perfect score! You know your fandom!';
    }

    if (score >= 4) {
      return 'Great job! Almost perfect!';
    }

    if (score >= 3) {
      return 'Nice work! Keep exploring your fandom.';
    }

    if (score >= 1) {
      return 'Good try! Learn more and try again.';
    }

    return 'Keep exploring and try again!';
  }
}