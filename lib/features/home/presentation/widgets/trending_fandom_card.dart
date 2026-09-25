import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrendingFandomCard extends StatelessWidget {
  final String fandomId;
  final String name;
  final String image;
  final String category;
  final String members;

  const TrendingFandomCard({
    super.key,
    required this.fandomId,
    required this.name,
    required this.image,
    required this.category,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          context.push(
            '/fandom/$fandomId',
          );
        },

        borderRadius:
        BorderRadius.circular(12),

        child: Container(
          width: double.infinity,

          constraints: const BoxConstraints(
            minHeight: 72,
          ),

          padding:
          const EdgeInsets.all(8),

          decoration: BoxDecoration(
            color: const Color(0xFF8B2CFF),

            borderRadius:
            BorderRadius.circular(12),
          ),

          child: Row(
            children: [

              // ==============================
              // IMAGE
              // ==============================

              ClipRRect(
                borderRadius:
                BorderRadius.circular(9),

                child: SizedBox(
                  width: 56,
                  height: 56,

                  child: Image.asset(
                    image,

                    fit: BoxFit.cover,

                    errorBuilder:
                        (context, error, stackTrace) {
                      return Container(
                        color:
                        const Color(0xFF292745),

                        child: const Icon(
                          Icons
                              .image_not_supported_outlined,
                          color:
                          Colors.white38,
                          size: 22,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ==============================
              // INFORMATION
              // ==============================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  mainAxisSize:
                  MainAxisSize.min,

                  children: [

                    Text(
                      name,

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style:
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      members,

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style:
                      const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(
                      height: 2,
                    ),

                    Text(
                      category,

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style:
                      const TextStyle(
                        color: Colors.white54,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),

              // ==============================
              // ARROW
              // ==============================

              const Icon(
                Icons.chevron_right,
                color: Colors.white70,
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}