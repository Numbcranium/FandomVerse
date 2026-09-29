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
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events,
              color: Color(0xFFFFC107),
              size: 60,
            ),

            SizedBox(height: 16),

            Text(
              'Trivia Complete!',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 12),

            Text(
              '$score / $total',
              style: TextStyle(
                color: Color(0xFF8FA8F5),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              _getMessage(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 14,
              ),
            ),

            SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onDone,
                child: Text('Done'),
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