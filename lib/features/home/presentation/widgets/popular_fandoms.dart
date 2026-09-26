import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PopularFandoms extends StatelessWidget {
  const PopularFandoms({super.key});

  // Images and text for the popular fandoms
  final List<Map<String, String>> fandoms = const [
    { 'name': 'Anime', 'image': 'assets/images/homeImages/roronoazoro.jpg', },
    { 'name': 'Marvel', 'image': 'assets/images/homeImages/spider-man.png', },
    { 'name': 'Gaming', 'image': 'assets/images/homeImages/gaming.webp', },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        // TITLE + SEE ALL

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              const Text(
                'Popular Fandoms',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              GestureDetector(
                onTap: () {
                  context.push('/fandoms');
                },
                child: const Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        color: Color(0xFFB82CFF),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(width: 4),

                    Icon(
                      Icons.chevron_right,
                      color: Color(0xFFB82CFF),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),


        // FANDOM CARDS

        SizedBox(
          height: 205,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: fandoms.length,

            // Each card
            itemBuilder: (context, index) {
              final fandom = fandoms[index];

              return GestureDetector(
                onTap: () {
                  context.push('/fandoms');
                },

                // CARD
                child: Container(
                  width: 135,
                  margin: const EdgeInsets.only(right: 14),

                  decoration: BoxDecoration(
                    color: const Color(0xFF17163D),
                    borderRadius: BorderRadius.circular(14),
                  ),

                  clipBehavior: Clip.antiAlias,

                  child: Column(
                    children: [

                      // IMAGE
                      Expanded(
                        child: Image.asset(
                          fandom['image']!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // NAME
                      Container(
                        height: 48,
                        alignment: Alignment.center,
                        child: Text(
                          fandom['name']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}