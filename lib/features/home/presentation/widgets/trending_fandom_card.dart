import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:techwiz7_starter/app/router/route_names.dart';

class TrendingFandomCard extends StatelessWidget {
  final String fandomId;
  final String name;
  final String image;
  final String category;

  const TrendingFandomCard({
    super.key,
    required this.fandomId,
    required this.name,
    required this.image,
    required this.category,
  });

  Stream<int> getFollowerCount() {
    return FirebaseFirestore.instance
        .collection('fandoms')
        .doc(fandomId)
        .collection('followers')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          context.push(
            RouteNames.fandomDetails.replaceFirst(
              ':fandomId',
              fandomId,
            ),
          );
        },

        borderRadius: BorderRadius.circular(12),

        child: Container(
          width: double.infinity,

          constraints: const BoxConstraints(
            minHeight: 72,
          ),

          padding: const EdgeInsets.all(8),

          decoration: BoxDecoration(
            // color: const Color(0xFF8FA8F3),
            borderRadius: BorderRadius.circular(12),
          ),

          child: Row(
            children: [

              // ==========================
              // IMAGE
              // ==========================

              ClipRRect(
                borderRadius: BorderRadius.circular(9),

                child: SizedBox(
                  width: 56,
                  height: 56,

                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,

                    errorBuilder:
                        (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF292745),

                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.white38,
                          size: 22,
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(width: 12),

              // ==========================
              // NAME + FOLLOWERS
              // ==========================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  mainAxisSize: MainAxisSize.min,

                  children: [

                    Text(
                      name,

                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,

                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 4),

                    // REAL FOLLOWER COUNT
                    StreamBuilder<int>(
                      stream: getFollowerCount(),

                      builder: (
                          context,
                          snapshot,
                          ) {
                        final count =
                            snapshot.data ?? 0;

                        return Text(
                          '$count followers',

                          style:
                          TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 2),

                    Text(
                      category,

                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,

                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}