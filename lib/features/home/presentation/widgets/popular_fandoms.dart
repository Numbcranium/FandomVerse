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

              Text(
                'Popular Fandoms',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              GestureDetector(
                onTap: () {
                  context.push('/fandoms');
                },
                child: Row(
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

        SizedBox(height: 16),


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
                    color: Theme.of(context).cardColor,
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
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
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