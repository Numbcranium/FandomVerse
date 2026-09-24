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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthRegisterSubmitted(
            fullName: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              context.read<AuthBloc>().add(const AuthErrorCleared());
            }
          },
          builder: (context, state) {
            final isLoading = state.status == AuthStatus.authenticating;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spaceLg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'Full name',
                      controller: _fullNameController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.person_outline,
                      validator: Validators.fullName,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppConstants.spaceMd),
                    AppTextField(
                      label: 'Email',
                      hint: 'you@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.email,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppConstants.spaceMd),
                    AppTextField(
                      label: 'Phone number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.phone_outlined,
                      validator: Validators.phone,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppConstants.spaceMd),
                    AppTextField.password(
                      controller: _passwordController,
                      textInputAction: TextInputAction.next,
                      validator: Validators.password,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppConstants.spaceMd),
                    AppTextField.password(
                      label: 'Confirm password',
                      controller: _confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      validator: (value) => Validators.confirmPassword(
                        value,
                        _passwordController.text,
                      ),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppConstants.spaceLg),
                    AppButton(
                      text: 'Create account',
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: AppConstants.spaceMd),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: isLoading ? null : () => context.pop(),
                          child: const Text('Log in'),
                        ),
                      ],
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
