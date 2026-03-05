import 'package:autoleadadmin/models/lead_model.dart';
import 'package:autoleadadmin/providers/auth_provider.dart';
import 'package:autoleadadmin/screens/dashboard_screen.dart';
import 'package:autoleadadmin/screens/lead_detail_screen.dart';
import 'package:autoleadadmin/screens/leads_screen.dart';
import 'package:autoleadadmin/screens/login_screen.dart';
import 'package:autoleadadmin/screens/profile_screen.dart';
import 'package:autoleadadmin/screens/splash_screen.dart';
import 'package:autoleadadmin/widgets/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.read(authNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoggedIn = authNotifier.isLoggedIn;
      final loc = state.matchedLocation;
      final publicRoutes = ['/splash', '/login'];
      if (!isLoggedIn && !publicRoutes.contains(loc)) return '/login';
      if (isLoggedIn && loc == '/login') return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) =>
            MainShell(child: child, location: state.matchedLocation),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (_, _) => const DashboardScreen(),
          ),
          GoRoute(path: '/leads', builder: (_, _) => const LeadsScreen()),
          GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
        ],
      ),
      GoRoute(
        path: '/lead-detail',
        builder: (_, state) => LeadDetailScreen(lead: state.extra as LeadModel),
      ),
    ],
  );
});
