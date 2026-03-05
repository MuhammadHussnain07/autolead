import 'package:autolead_ai/screens/lead_form_screen.dart';
import 'package:autolead_ai/screens/splash_screen.dart';
import 'package:autolead_ai/screens/success_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/form', builder: (_, _) => const LeadFormScreen()),
      GoRoute(path: '/success', builder: (_, _) => const SuccessScreen()),
    ],
  );
});
