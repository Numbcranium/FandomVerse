import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Standard screen scaffold: consistent app bar, safe area, and body
/// padding so individual screens don't repeat this boilerplate.
///
/// Screens are still responsible for building their own Loading/Success/
/// Empty/Error content inside [body] (see [AppLoading], [AppError],
/// [AppEmptyState]) — this widget only standardizes the chrome around it.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.padBody = true,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.showAppBar = true,
    super.key,
  });

  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool padBody;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: showAppBar
          ? AppBar(
              title: title != null ? Text(title!) : null,
              automaticallyImplyLeading: showBackButton && canPop,
              actions: actions,
            )
          : null,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: padBody
            ? Padding(
                padding: const EdgeInsets.all(AppConstants.spaceMd),
                child: body,
              )
            : body,
      ),
    );
  }
}
