import 'package:flutter/material.dart';

class TriviaCard extends StatelessWidget {
  const TriviaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
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
          // Character image on the right
          Positioned(
            right: -10,
            bottom: 0,
            top: 10,
            child: Image.asset(
              'assets/images/homeImages/spider-man-removebg-preview.png',
              width: 160,
              fit: BoxFit.cover,
            ),
          ),

          // Text and button
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Trivia",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const SizedBox(
                  width: 230,
                  child: Text(
                    'Which anime is the most\npopular of all time?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),

                const Spacer(),

                ElevatedButton(
                  onPressed: () {
                  //   change
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB82CFF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Play Now',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}