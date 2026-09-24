import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthLoginSubmitted(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const SizedBox(height: AppConstants.spaceXxl),
                    Text(
                      'Welcome back',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppConstants.spaceSm),
                    Text(
                      'Log in to continue.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppConstants.spaceXl),
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
                    AppTextField.password(
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                      validator: Validators.password,
                      enabled: !isLoading,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () => context.push(RouteNames.forgotPassword),
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spaceMd),
                    AppButton(
                      text: 'Log in',
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: AppConstants.spaceLg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () => context.push(RouteNames.register),
                          child: const Text('Register'),
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
