import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:techwiz7_starter/app/router/route_names.dart';

import '../../../../models/fandom-service.dart';
import '../../../../models/fandom_models.dart';

class ChooseFandomScreen extends StatelessWidget {
  const ChooseFandomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fandomService = FandomService();

    return Scaffold(
      backgroundColor: const Color(0xFF05052B),

      appBar: AppBar(
        backgroundColor: const Color(0xFF05052B),
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Your Fandom',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Select the fandoms you want to play trivia about.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 30),

              // FIREBASE FANDOMS
              Expanded(
                child: StreamBuilder<List<FandomModels>>(
                  stream: fandomService.getFandoms(),

                  builder: (context, snapshot) {
                    // Loading
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF7027FF),
                        ),
                      );
                    }

                    // Error
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Unable to load fandoms',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      );
                    }

                    // Firebase data
                    final fandoms = snapshot.data ?? [];

                    // No fandoms
                    if (fandoms.isEmpty) {
                      return const Center(
                        child: Text(
                          'No fandoms available',
                          style: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      itemCount: fandoms.length,

                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.78,
                      ),

                      itemBuilder: (context, index) {
                        final fandom = fandoms[index];

                        // for the next screen ========
                        return GestureDetector(
                          onTap: () {
                            // Send the Firebase fandom ID
                            // to the trivia questions screen. ====
                            context.push(
                              RouteNames.triviaQuestions
                                  .replaceFirst(
                                ':fandomId',
                                fandom.id,
                              ),
                            );
                          },

                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(12),

                              border: Border.all(
                                color:
                                const Color(0xFF7027FF),
                                width: 1,
                              ),

                              color:
                              const Color(0xFF11113A),
                            ),

                            clipBehavior: Clip.antiAlias,

                            child: Stack(
                              children: [
                                // Fandom image from Firebase
                                //
                                // Firebase stores the local
                                // asset path, for example:
                                // assets/images/homeSearch/
                                // luffy-the-one-piece.jpg
                                Positioned.fill(
                                  child: Image.asset(
                                    fandom.image,
                                    fit: BoxFit.cover,

                                    errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                        ) {
                                      return Container(
                                        color: const Color(
                                          0xFF181747,
                                        ),
                                        child: const Icon(
                                          Icons
                                              .image_outlined,
                                          color:
                                          Colors.white38,
                                          size: 40,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // Dark overlay
                                Positioned.fill(
                                  child: Container(
                                    decoration:
                                    BoxDecoration(
                                      gradient:
                                      LinearGradient(
                                        begin:
                                        Alignment.topCenter,
                                        end:
                                        Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black
                                              .withOpacity(
                                            0.8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Fandom name
                                Positioned(
                                  left: 4,
                                  right: 4,
                                  bottom: 10,

                                  child: Text(
                                    fandom.name,
                                    textAlign:
                                    TextAlign.center,
                                    maxLines: 2,
                                    overflow:
                                    TextOverflow.ellipsis,

                                    style:
                                    const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),

              // Continue button
              // SizedBox(
              //   width: double.infinity,
              //   height: 52,
              //
              //   child: ElevatedButton(
              //     onPressed: () {
              //       context.push(RouteNames.triviaQuestions);
              //     },
              //
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor:
              //       const Color(0xFF7027FF),
              //
              //       shape: RoundedRectangleBorder(
              //         borderRadius:
              //         BorderRadius.circular(30),
              //       ),
              //     ),
              //
              //     child: const Text(
              //       'Continue',
              //
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 15,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}