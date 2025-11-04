import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softmed24h/src/screens/auth/login_screen.dart';
import 'package:softmed24h/src/screens/auth/register_screen.dart';
import 'package:softmed24h/src/screens/forget_password/email_sent_screen.dart';
import 'package:softmed24h/src/screens/forget_password/forget_password_screen.dart';
import 'package:softmed24h/src/screens/forget_password/reset_password_screen.dart';
import 'package:softmed24h/src/screens/forget_password/token_error_screen.dart';
import 'package:softmed24h/src/screens/home/home_page.dart';
import 'package:softmed24h/src/screens/landing/landing_screen.dart';
import 'package:softmed24h/src/screens/payment/payment_screen.dart';
import 'package:softmed24h/src/utils/session_manager.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LandingPage();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/cadastro',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/payment',
      builder: (BuildContext context, GoRouterState state) {
        return const PaymentScreen();
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (BuildContext context, GoRouterState state) {
        return const ForgetPasswordScreen();
      },
    ),
    GoRoute(
      path: '/email-sent',
      builder: (BuildContext context, GoRouterState state) {
        return const EmailSentScreen();
      },
    ),
    GoRoute(
      path: '/reset-password',
      builder: (BuildContext context, GoRouterState state) {
        final token = state.uri.queryParameters['token'];
        if (token == null || token.isEmpty) {
          return const TokenErrorScreen();
        }
        return ResetPasswordScreen(token: token);
      },
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) async {
    final sessionManager = SessionManager();
    final token = await sessionManager.getToken();
    final bool loggedIn =
        token != null && !await sessionManager.isTokenExpired();
    final bool loggingIn =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/cadastro' ||
        state.matchedLocation == '/forgot-password' ||
        state.matchedLocation == '/email-sent' ||
        state.matchedLocation == '/reset-password';

    // If the user is not logged in, and not on the login/register page, redirect to login
    if (!loggedIn && !loggingIn) {
      return '/';
    }
    // If the user is logged in, and on the login/register page, redirect to home
    if (loggedIn && loggingIn) {
      return '/home';
    }

    // No redirect
    return null;
  },
);
