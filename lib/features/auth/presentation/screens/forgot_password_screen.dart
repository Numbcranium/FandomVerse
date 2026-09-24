import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthPasswordResetSubmitted(_emailController.text.trim()),
        );
    setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset password')),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              setState(() => _sent = false);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              context.read<AuthBloc>().add(const AuthErrorCleared());
            }
          },
          builder: (context, state) {
            final isLoading = state.status == AuthStatus.authenticating;

            if (_sent && state.errorMessage == null && !isLoading) {
              return Padding(
                padding: const EdgeInsets.all(AppConstants.spaceLg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.mark_email_read_outlined, size: 64),
                    const SizedBox(height: AppConstants.spaceMd),
                    Text(
                      'Check your inbox',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppConstants.spaceSm),
                    Text(
                      "We've sent a password reset link to "
                      '${_emailController.text.trim()}.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppConstants.spaceLg),
                    AppButton(
                      text: 'Back to login',
                      fullWidth: false,
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spaceLg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Enter the email associated with your account and "
                      "we'll send a link to reset your password.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppConstants.spaceLg),
                    AppTextField(
                      label: 'Email',
                      hint: 'you@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.email,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppConstants.spaceLg),
                    AppButton(
                      text: 'Send reset link',
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
