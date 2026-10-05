import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:supabase_practice/ui/common/app_colors.dart';
import 'package:supabase_practice/ui/common/ui_helpers.dart';
import 'package:supabase_practice/ui/widgets/auth_layout.dart';

import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return AuthLayout(
      icon: Icons.lock_open_rounded,
      title: 'Welcome back',
      subtitle: 'Sign in to continue',
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
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => viewModel.login(),
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              onPressed: viewModel.togglePasswordVisibility,
              icon: Icon(
                viewModel.obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
        ),
        verticalSpaceMedium,
        AuthErrorText(viewModel.errorMessage),
        AuthSubmitButton(
          label: 'Login',
          busy: viewModel.isBusy,
          onPressed: viewModel.login,
        ),
        verticalSpaceSmall,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account?",
              style: TextStyle(color: kcMediumGrey),
            ),
            TextButton(
              onPressed: viewModel.signup,
              child: const Text('Register'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();
}
