import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';

import '../../../../models/fandom-gallery-service.dart';

class FandomGalleryScreen extends StatelessWidget {
  final String fandomId;

  const FandomGalleryScreen({
    super.key,
    required this.fandomId,
  });

  // Save image to phone gallery
  Future<void> _saveImage(
      BuildContext context,
      String assetPath,
      ) async {
    try {
      // Check if we already have gallery permission
      bool hasAccess = await Gal.hasAccess();

      // Request permission if we don't have it
      if (!hasAccess) {
        hasAccess = await Gal.requestAccess();
      }

      if (!hasAccess) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Gallery permission is required to save images.',
            ),
          ),
        );

        return;
      }

      // Load the image from Flutter assets
      final byteData = await rootBundle.load(assetPath);

      // Convert the asset to bytes
      final bytes = byteData.buffer.asUint8List();

      // Save the image to the phone gallery
      await Gal.putImageBytes(
        bytes,
        name: 'fandom_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved to your gallery'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not save image: $e',
          ),
        ),
      );
    }
  }

  // Open image preview
  void _openImagePreview(
      BuildContext context,
      String assetPath,
      ) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 15),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await _saveImage(
                      context,
                      assetPath,
                    );

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(
                    Icons.download_rounded,
                  ),
                  label: Text(
                    'Save Image',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8FA8F5),
                    foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Close button
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final galleryService = FandomGalleryService();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        title: Text('Gallery'),
      ),

      body: StreamBuilder(
        stream: galleryService.getGallery(fandomId),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            );
          }

          final gallery = snapshot.data ?? [];

          if (gallery.isEmpty) {
            return Center(
              child: Text(
                'No images available',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 16,
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),

            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),

            itemCount: gallery.length,

            itemBuilder: (context, index) {
              final image = gallery[index];

              return GestureDetector(
                onTap: () {
                  _openImagePreview(
                    context,
                    image.image,
                  );
                },

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),

                  child: Image.asset(
                    image.image,
                    fit: BoxFit.cover,

                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return Container(
                        color: Theme.of(context).cardColor,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Theme.of(context).disabledColor,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}