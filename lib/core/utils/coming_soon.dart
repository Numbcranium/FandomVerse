import 'package:flutter/material.dart';

/// Shows a lightweight "coming soon" snackbar.
///
/// Used by bottom-nav tabs (Explore, Events, Shop) that route to sections
/// other teammates own but haven't built yet — keeps taps from silently
/// doing nothing or crashing on an unregistered route.
void showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$feature is coming soon.')));
}
