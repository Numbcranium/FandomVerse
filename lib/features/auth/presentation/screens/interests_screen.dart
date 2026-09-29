import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/fandom_categories.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../profile/data/datasources/user_remote_datasource.dart';
import '../../../profile/data/repositories/user_repository_impl.dart';
import '../../../profile/domain/repositories/user_repository.dart';

/// One-time post-registration step: pick fandom interests (SRS section
/// 1.6 "Role and Category Selection"). `AppRouter` routes every
/// authenticated user with an empty `selectedFandoms` here — see
/// `needsInterestsSelection` — and away again once they've picked at
/// least one, so this screen doesn't navigate on success itself.
///
/// Profile badges (also mentioned in that SRS bullet) aren't implemented
/// here — no badge catalog exists yet to select from.
class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final Set<String> _selected = {};
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _continue() async {
    if (_selected.isEmpty) {
      setState(() => _errorMessage = 'Pick at least one fandom to continue.');
      return;
    }

    final authBloc = context.read<AuthBloc>();
    final currentUser = authBloc.state.user;
    if (currentUser == null) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final UserRepository userRepository = UserRepositoryImpl(
        FirestoreUserRemoteDataSource(),
        StorageService(),
      );
      final updated = currentUser.copyWith(
        selectedFandoms: _selected.toList(),
        updatedAt: DateTime.now(),
      );
      await userRepository.updateUser(updated);
      authBloc.add(AuthUserChanged(updated));
      // No navigation here — AppRouter's redirect sees selectedFandoms is
      // no longer empty and routes to home automatically.
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = AppException.from(e).message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppConstants.spaceXl),
              Text(
                'What are you into?',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: AppConstants.spaceSm),
              Text(
                'Pick your fandoms — this shapes what shows up first.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: AppConstants.spaceLg),
              Wrap(
                spacing: AppConstants.spaceSm,
                runSpacing: AppConstants.spaceSm,
                children: [
                  for (final category in FandomCategories.all)
                    FilterChip(
                      label: Text(category),
                      selected: _selected.contains(category),
                      onSelected: _isSubmitting
                          ? null
                          : (isSelected) {
                              setState(() {
                                _errorMessage = null;
                                if (isSelected) {
                                  _selected.add(category);
                                } else {
                                  _selected.remove(category);
                                }
                              });
                            },
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: _selected.contains(category)
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                ],
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: AppConstants.spaceMd),
                Text(
                  _errorMessage!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                      ),
                ),
              ],
              const Spacer(),
              AppButton(
                text: 'Continue',
                isLoading: _isSubmitting,
                onPressed: _continue,
              ),
              SizedBox(height: AppConstants.spaceMd),
            ],
          ),
        ),
      ),
    );
  }
}
