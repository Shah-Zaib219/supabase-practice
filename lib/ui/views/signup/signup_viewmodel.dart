import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_practice/app/app.locator.dart';
import 'package:supabase_practice/app/app.router.dart';

class SignupViewModel extends BaseViewModel {
  final supabase = Supabase.instance.client;
  final _navigationService = locator<NavigationService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  String? errorMessage;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    rebuildUi();
  }

  /// Goes back to the login screen this view was opened from.
  void login() {
    _navigationService.back();
  }

  Future<void> signup() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      errorMessage = 'Please fill in all fields.';
    } else if (password.length < 6) {
      errorMessage = 'Password must be at least 6 characters.';
    } else if (password != confirmPasswordController.text) {
      errorMessage = 'Passwords do not match.';
    } else {
      errorMessage = null;
    }
    if (errorMessage != null) {
      rebuildUi();
      return;
    }

    try {
      // Email confirmation is disabled, so signUp also signs the user in.
      await runBusyFuture(
        supabase.auth.signUp(email: email, password: password),
        throwException: true,
      );
      _navigationService.clearStackAndShow(Routes.homeView);
    } on AuthException catch (e) {
      errorMessage = e.message;
      rebuildUi();
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      rebuildUi();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
