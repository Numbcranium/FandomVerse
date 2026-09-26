import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';

class TriviaCard extends StatelessWidget {
  const TriviaCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Safely capture screen width for scaling context if needed
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      // Removed fixed height to let Content + Padding safely determine the size
      margin: const EdgeInsets.symmetric(horizontal: 6),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE21111),
            Color(0xFF192A56),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: [
          // 1. Image safely pinned to the right side
          Positioned(
            right: -5,
            bottom: 0,
            top: 10,
            child: Image.asset(
              'assets/images/homeImages/spider-man-removebg-preview.png',
              width: screenWidth * 0.25, // Dynamically scales to 25% of screen width
              fit: BoxFit.contain,
            ),
          ),

          // 2. Text layout dynamically resizing based on remaining space
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Expanded forces the Column to take only the remaining horizontal space
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min, // Prevents column from expanding vertically infinitely
                    children: [
                      const Text(
                        'Trivia Pop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Test your knowledge\nHow well do you know your fandoms??',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                        softWrap: true, // Allows natural text wrapping
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          context.go(RouteNames.trivia);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB82CFF),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Play Now',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // This transparent spacer reserves exactly 22% of the space on the right
                // so the text column never overlaps or bleeds into the Spiderman asset.
                SizedBox(width: screenWidth * 0.22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
