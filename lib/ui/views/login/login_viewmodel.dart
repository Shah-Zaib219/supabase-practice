import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_practice/app/app.locator.dart';
import 'package:supabase_practice/app/app.router.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final supabase = Supabase.instance.client;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  String? errorMessage;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    rebuildUi();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      errorMessage = 'Please enter your email and password.';
      rebuildUi();
      return;
    }
    errorMessage = null;

    try {
      await runBusyFuture(
        supabase.auth.signInWithPassword(password: password, email: email),
        throwException: true,
      );
      _navigationService.replaceWithHomeView();
    } on AuthException catch (e) {
      errorMessage = e.message;
      rebuildUi();
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      rebuildUi();
    }
  }

  void signup() {
    _navigationService.navigateToSignupView();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
