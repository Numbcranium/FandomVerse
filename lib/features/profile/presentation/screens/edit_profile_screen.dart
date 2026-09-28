import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;
    if (user == null) {
      // Shouldn't happen — this route is only reachable when
      // authenticated — but fail gracefully rather than crash.
      return const Scaffold(body: Center(child: Text('No profile to edit.')));
    }

    return BlocProvider<ProfileBloc>(
      // TODO(Phase 9 wiring): promote `UserRepository` to an app-root
      // RepositoryProvider if more screens end up needing it — kept
      // screen-local for now since only editing needs it.
      create: (context) => ProfileBloc(
        userRepository: UserRepositoryImpl(
          FirestoreUserRemoteDataSource(),
          StorageService(),
        ),
        initialUser: user,
      ),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  Uint8List? _pickedPhotoBytes;
  String? _pickedPhotoExtension;

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileBloc>().state.user!;
    _fullNameController = TextEditingController(text: user.fullName);
    _phoneController = TextEditingController(text: user.phone);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked != null) {
      // Strict Check 1: File size (Max 5MB)
      final sizeInBytes = await picked.length();
      final sizeInMb = sizeInBytes / (1024 * 1024);
      if (sizeInMb > 5) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image is too large. Maximum size is 5MB.')),
          );
        }
        return;
      }

      // Strict Check 2: Extension
      final name = picked.name.toLowerCase();
      if (!name.endsWith('.jpg') && !name.endsWith('.jpeg') && !name.endsWith('.png')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid file format. Only JPG and PNG are allowed.')),
          );
        }
        return;
      }

      final bytes = await picked.readAsBytes();
      final extension = name.split('.').last;
      setState(() {
        _pickedPhotoBytes = bytes;
        _pickedPhotoExtension = extension;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileBloc>().add(
          ProfileUpdateSubmitted(
            fullName: _fullNameController.text.trim(),
            phone: _phoneController.text.trim(),
            photoBytes: _pickedPhotoBytes,
            photoExtension: _pickedPhotoExtension,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit profile')),
      body: SafeArea(
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.success) {
              // Push the freshly-saved profile into AuthBloc immediately
              // rather than waiting for Firestore's snapshot listener to
              // round-trip — see AuthBloc._onUserChanged.
              context.read<AuthBloc>().add(AuthUserChanged(state.user));
              if (context.mounted) context.pop();
            } else if (state.status == ProfileStatus.error && state.errorMessage != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final isSubmitting = state.status == ProfileStatus.submitting;
              final user = state.user!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.spaceLg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            _pickedPhotoBytes != null
                                ? CircleAvatar(
                                    radius: 48,
                                    backgroundImage: MemoryImage(_pickedPhotoBytes!),
                                  )
                                : AppNetworkImage.avatar(
                                    imageUrl: user.photoUrl,
                                    radius: 48,
                                    fallbackText: user.fullName,
                                  ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Material(
                                color: Theme.of(context).colorScheme.primary,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: isSubmitting ? null : _pickPhoto,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(Icons.camera_alt, size: 18, color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppConstants.spaceXl),
                      AppTextField(
                        label: 'Full name',
                        controller: _fullNameController,
                        prefixIcon: Icons.person_outline,
                        validator: Validators.fullName,
                        enabled: !isSubmitting,
                      ),
                      SizedBox(height: AppConstants.spaceMd),
                      AppTextField(
                        label: 'Phone number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                        validator: Validators.phone,
                        enabled: !isSubmitting,
                      ),
                      SizedBox(height: AppConstants.spaceLg),
                      AppButton(
                        text: 'Save changes',
                        isLoading: isSubmitting,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
