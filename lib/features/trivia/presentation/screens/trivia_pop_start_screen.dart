import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';

class TriviaPopStartScreen extends StatelessWidget {
  const TriviaPopStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 18,
                  top: 10,
                ),
                child: IconButton(
                  onPressed: () {
                    context.go(RouteNames.home);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).iconTheme.color,
                    size: 28,
                  ),
                ),
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),

                    // Trivia Pop image/logo
                    SizedBox(
                      height: 370,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/icons/trivia_pop_icon.png',
                        fit: BoxFit.contain,
                        errorBuilder: (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return Center(
                            child: Icon(
                              Icons.quiz,
                              color: Color(0xFF7C2CFF),
                              size: 120,
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 10),

                    // Heading
                    Text(
                      'Think. Guess. Be a Fandom Pro!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 32),

                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      child: Text(
                        'Test your knowledge with fun\n'
                            'multiple choice questions from\n'
                            'your favorite fandoms.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),

                    SizedBox(height: 38),

                    // Start Playing button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF6A00FF),
                              Color(0xFF8A2BE2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        // the start playing button
                        child: ElevatedButton(
                          onPressed: () {
                            context.push(RouteNames.chooseFandom);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Start Playing',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}