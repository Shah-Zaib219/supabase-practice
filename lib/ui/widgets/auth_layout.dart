import 'package:flutter/material.dart';
import 'package:supabase_practice/ui/common/app_colors.dart';
import 'package:supabase_practice/ui/common/ui_helpers.dart';

/// Shared layout for the login and signup screens: a gradient header with an
/// icon and title, and a white card holding the form.
class AuthLayout extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> children;

  const AuthLayout({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight(context) * 0.38,
            decoration: const BoxDecoration(
              gradient: kgPrimaryGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  verticalSpaceLarge,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0x33FFFFFF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 40, color: Colors.white),
                  ),
                  verticalSpaceSmall,
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  verticalSpaceTiny,
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Colors.white70),
                  ),
                  verticalSpaceMedium,
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A300151),
                          blurRadius: 30,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children,
                    ),
                  ),
                  verticalSpaceMedium,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Inline error message shown above the submit button.
class AuthErrorText extends StatelessWidget {
  final String? message;

  const AuthErrorText(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: kcErrorColor, size: 18),
          horizontalSpaceTiny,
          Expanded(
            child: Text(
              message!,
              style: const TextStyle(color: kcErrorColor, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// Primary submit button that swaps its label for a spinner while busy.
class AuthSubmitButton extends StatelessWidget {
  final String label;
  final bool busy;
  final VoidCallback onPressed;

  const AuthSubmitButton({
    Key? key,
    required this.label,
    required this.busy,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: busy ? null : onPressed,
      child: busy
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : Text(label),
    );
  }
}
