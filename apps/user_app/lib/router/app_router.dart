import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../features/auth/presentation/pages/home_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/sign_up_page.dart';
import 'route_names.dart';
import 'route_paths.dart';

class AppRouter {
  const AppRouter._();

  static GoRouter router(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: RoutePaths.splash,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final location = state.matchedLocation;
        final isAuthRoute =
            location == RoutePaths.login || location == RoutePaths.signUp;

        if (!authState.hasResolvedAuthState) {
          return location == RoutePaths.splash ? null : RoutePaths.splash;
        }

        if (authState.status == AuthStatus.unauthenticated) {
          return isAuthRoute ? null : RoutePaths.login;
        }

        if (location == RoutePaths.splash || isAuthRoute) {
          return RoutePaths.home;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: RoutePaths.splash,
          name: RouteNames.splash,
          builder: (context, state) => const _SplashPage(),
        ),
        GoRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: RoutePaths.signUp,
          name: RouteNames.signUp,
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: RoutePaths.home,
          name: RouteNames.home,
          builder: (context, state) => const HomePage(),
        ),
      ],
    );
  }
}

class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
