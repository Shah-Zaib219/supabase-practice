import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:supabase_practice/ui/common/app_colors.dart';
import 'package:supabase_practice/ui/common/ui_helpers.dart';
import 'package:supabase_practice/ui/widgets/auth_layout.dart';

import 'signup_viewmodel.dart';

class SignupView extends StackedView<SignupViewModel> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SignupViewModel viewModel,
    Widget? child,
  ) {
    final visibilityToggle = IconButton(
      onPressed: viewModel.togglePasswordVisibility,
      icon: Icon(
        viewModel.obscurePassword
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
      ),
    );

    return AuthLayout(
      icon: Icons.person_add_alt_1_rounded,
      title: 'Create account',
      subtitle: 'Sign up to get started',
      children: [
        TextField(
          controller: viewModel.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        verticalSpaceSmall,
        TextField(
          controller: viewModel.passwordController,
          obscureText: viewModel.obscurePassword,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: visibilityToggle,
          ),
        ),
        verticalSpaceSmall,
        TextField(
          controller: viewModel.confirmPasswordController,
          obscureText: viewModel.obscurePassword,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => viewModel.signup(),
          decoration: const InputDecoration(
            labelText: 'Confirm password',
            prefixIcon: Icon(Icons.lock_reset_outlined),
          ),
        ),
        verticalSpaceMedium,
        AuthErrorText(viewModel.errorMessage),
        AuthSubmitButton(
          label: 'Sign up',
          busy: viewModel.isBusy,
          onPressed: viewModel.signup,
        ),
        verticalSpaceSmall,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have an account?',
              style: TextStyle(color: kcMediumGrey),
            ),
            TextButton(
              onPressed: viewModel.login,
              child: const Text('Login'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  SignupViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SignupViewModel();
}
