import 'package:flutter/material.dart';

class TriviaCard extends StatelessWidget {
  const TriviaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
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
            right: -5,
            bottom: 0,
            top: 10,
            child: Image.asset(
              'assets/images/homeImages/spider-man-removebg-preview.png',
              width: 95,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),

          // Text and button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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

                const SizedBox(
                  width: 150,
                  child: Text(
                    'Test your knowledge\nHow well do you know your fandoms??',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                ElevatedButton(
                  onPressed: () {
                  //   change
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB82CFF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
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
                      fontSize: 9,
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