import 'package:flutter/material.dart';
import 'package:softmed24h/src/screens/home/home_page.dart';
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
          // If session exists, redirect to home
          return const HomePage();
        }
        // If no session, show the child widget (e.g., LoginScreen)
        return child;
      },
    );
  }
}
