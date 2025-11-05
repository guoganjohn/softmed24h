import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softmed24h/src/utils/session_manager.dart';

class RedirectIfAuthenticated extends StatelessWidget {
  final Widget child;

  const RedirectIfAuthenticated({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SessionManager().getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          // If session exists, redirect to home using GoRouter
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/home');
          });
          return const SizedBox.shrink(); // Return an empty widget while redirecting
        }
        // If no session, show the child widget (e.g., LoginScreen)
        return child;
      },
    );
  }
}
