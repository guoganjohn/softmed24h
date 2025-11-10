import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softmed24h/src/screens/auth/login_screen.dart';
import 'package:softmed24h/src/screens/auth/register_screen.dart';
import 'package:softmed24h/src/screens/forget_password/email_sent_screen.dart';
import 'package:softmed24h/src/screens/forget_password/forget_password_screen.dart';
import 'package:softmed24h/src/screens/forget_password/reset_password_screen.dart';
import 'package:softmed24h/src/screens/forget_password/token_error_screen.dart';
import 'package:softmed24h/src/screens/home/home_screen.dart';
import 'package:softmed24h/src/screens/payment/payment_screen.dart';
import 'package:softmed24h/src/screens/minha_conta/minha_conta_screen.dart';
import 'package:softmed24h/src/screens/agendar_especialista/agendar_especialista_screen.dart';
import 'package:softmed24h/src/screens/iniciar_consulta/iniciar_consulta_screen.dart';
import 'package:softmed24h/src/screens/convidar_amigos/convidar_amigos_screen.dart';
import 'package:softmed24h/src/screens/minha_senha/minha_senha_screen.dart';
import 'package:softmed24h/src/utils/session_manager.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
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
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return HomePage(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          redirect: (context, state) => '/home/minha-conta',
        ),
        GoRoute(
          path: '/home/minha-conta',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(child: MinhaContaScreen());
          },
        ),
        GoRoute(
          path: '/home/agendar-especialista',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(child: AgendarEspecialistaScreen());
          },
        ),
        GoRoute(
          path: '/home/iniciar-consulta',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(child: IniciarConsultaScreen());
          },
        ),
        GoRoute(
          path: '/home/convidar-amigos',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(child: ConvidarAmigosScreen());
          },
        ),
        GoRoute(
          path: '/home/minha-senha',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(child: MinhaSenhaScreen());
          },
        ),
      ],
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
