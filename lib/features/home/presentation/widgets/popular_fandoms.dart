import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PopularFandoms extends StatelessWidget {
  const PopularFandoms({super.key});

  // the images and the text for the popular fandoms

  final List<Map<String, String>> fandoms = const [
    {
      'name': 'Anime',
      'image': 'assets/images/homeImages/anime.png',
    },
    {
      'name': 'Marvel',
      'image': 'assets/images/homeImages/marvel.png',
    },
    {
      'name': 'Gaming',
      'image': 'assets/images/homeImages/gaming.png',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        //   title and see all
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
                  // onTap: () {
                  //   context.push('/fandoms');
                  // },
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
        ]
    );
  }
}
