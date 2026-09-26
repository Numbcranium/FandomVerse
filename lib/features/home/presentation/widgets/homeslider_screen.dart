// This package gives us the CarouselSlider widget
import 'package:carousel_slider/carousel_slider.dart';

// Material gives us Flutter UI widgets like
// Scaffold, Container, Column, Row, Colors, etc.
import 'package:flutter/material.dart';

class HomesliderScreen extends StatefulWidget {
  const HomesliderScreen({super.key});

  @override
  State<HomesliderScreen> createState() => _HomesliderScreenState();
}

class _HomesliderScreenState extends State<HomesliderScreen> {

  // IMAGES THAT WILL BE DISPLAYED IN THE CAROUSEL

  final List<String> images = [
    'assets/images/homeImages/MonkeyDLuffyOne.jpg',
    'assets/images/homeImages/naru.jpg',
    'assets/images/homeImages/Naruto.jpg',
    'assets/images/homeImages/batman.jpg',
    'assets/images/homeImages/DoctorStrange.jpg',
    'assets/images/homeImages/thor.jpg',
    'assets/images/homeImages/tsundere.jpg',
  ];


  // CURRENT SLIDE INDEX

  // This keeps track of which image is currently showing.
  // start from 0
  // 0 = first image
  // 1 = second image
  // 2 = third image
  //
  int currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,

       children: [

          // CAROUSEL SLIDEr
          // This is responsible for sliding the images.
          CarouselSlider(

            // We take every image from our images list
            // and turn it into a Container.

            items: images.map((item) {

              return Container(

                // Space around each image
                margin: const EdgeInsets.symmetric(horizontal: 5),

                // Design of the image container
                decoration: BoxDecoration(

                  // Rounded corners
                  borderRadius: BorderRadius.circular(10),

                  // Put the local image inside the container
                  image: DecorationImage(

                    // IMPORTANT PLEASE:
                    // Because these are LOCAL assets,
                    // we use AssetImage, NOT NetworkImage.
                    image: AssetImage(item),

                    // Make the image fill the container
                    fit: BoxFit.cover,
                  ),
                ),
              );

            }).toList(),

            // CAROUSEL OPTIONS

            options: CarouselOptions(

              // Height of the carousel
              height: 250,

              // Makes the center image slightly larger
              enlargeCenterPage: true,

              // Automatically move to the next image
              autoPlay: true,

              // Wait 3 seconds before moving
              autoPlayInterval: const Duration(seconds: 5),

              // Animation speed when changing images
              autoPlayAnimationDuration:
              const Duration(milliseconds: 900),

              // The animation style
              autoPlayCurve: Curves.easeInOut,

              // Allows the user to swipe manually
              enableInfiniteScroll: true,

              // How much of the screen each slide takes

              // 1.0 = full width
              // 0.8 = 80% width
              //
              viewportFraction: 1.0,

              // Aspect ratio of the carousel
              aspectRatio: 16 / 9,


              // WHEN THE IMAGE CHANGES

              // This runs every time the carousel moves
              // to another image.
              onPageChanged: (index, reason) {

                setState(() {
                  // Update the current image index
                  currentIndex = index;

                });
              },
            ),
          ),


          // ====================================================
          // SPACE BETWEEN CAROUSEL AND DOTS
          // ====================================================

          const SizedBox(
            height: 16,
          ),


          // SLIDE INDICATOR DOTS
          // These dots tell the user which image is currently
          // being displayed.

          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: images.asMap().entries.map((item) {

              // item.key = index of the image
              //
              // Example:
              // first image  -> 0
              // second image -> 1
              // third image  -> 2

              return Container(

                // Height of the dot
                height: 8,

                // Width of the dot
                width: 8,

                // Space around each dot
                margin: const EdgeInsets.all(4),

                // Design of the dot
                decoration: BoxDecoration(

                  // Make the container circular
                  shape: BoxShape.circle,

                  // If this is the current slide,
                  // make the dot blue.
                  //
                  // Otherwise make it grey.
                  color: currentIndex == item.key
                      ? Colors.blue
                      : Colors.grey,
                ),
              );

            }).toList(),
          ),
        ],

    );
  }
}