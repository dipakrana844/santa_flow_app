import 'package:go_router/go_router.dart';

import '../../features/events/presentation/screens/event_settings_screen.dart';
import '../../features/events/presentation/screens/events_screen.dart';
import '../../features/help/presentation/screens/help_screen.dart';
import '../../features/matching/presentation/screens/matching_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/participants/presentation/screens/participants_screen.dart';
import '../../features/reveal/presentation/screens/qr_display_screen.dart';
import '../../features/reveal/presentation/screens/qr_scanner_screen.dart';
import '../../features/reveal/presentation/screens/reveal_history_screen.dart';
import '../../features/reveal/presentation/screens/reveal_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../constants/app_constants.dart';
import '../navigation/main_navigation.dart';
import '../splash/splash_screen.dart';
import '../utils/shared_preferences_helper.dart';

/// App router configuration using go_router
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppConstants.splashRoute,
    redirect: (context, state) async {
      // Don't redirect from splash screen
      if (state.uri.path == AppConstants.splashRoute) {
        return null;
      }

      final isOnboardingCompleted =
          await SharedPreferencesHelper.isOnboardingCompleted();
      final isOnboarding = state.uri.path == AppConstants.onboardingRoute;

      if (!isOnboardingCompleted && !isOnboarding) {
        return AppConstants.onboardingRoute;
      }
      if (isOnboardingCompleted && isOnboarding) {
        return AppConstants.homeRoute;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppConstants.splashRoute,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppConstants.onboardingRoute,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppConstants.homeRoute,
        builder: (context, state) => const MainNavigation(),
      ),
      GoRoute(
        path: AppConstants.participantsRoute,
        builder: (context, state) => const ParticipantsScreen(),
      ),
      GoRoute(
        path: AppConstants.matchingRoute,
        builder: (context, state) => const MatchingScreen(),
      ),
      GoRoute(
        path: AppConstants.revealRoute,
        builder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return RevealScreen(token: token);
        },
      ),
      GoRoute(
        path: AppConstants.revealHistoryRoute,
        builder: (context, state) => const RevealHistoryScreen(),
      ),
      GoRoute(
        path: AppConstants.qrScannerRoute,
        builder: (context, state) => const QrScannerScreen(),
      ),
      GoRoute(
        path: AppConstants.qrDisplayRoute,
        builder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          final participantName =
              state.uri.queryParameters['name'] ?? 'Participant';
          return QrDisplayScreen(
            token: token,
            participantName: participantName,
          );
        },
      ),
      GoRoute(
        path: AppConstants.eventsRoute,
        builder: (context, state) => const EventsScreen(),
      ),
      GoRoute(
        path: '${AppConstants.eventSettingsRoute}/:eventId',
        builder: (context, state) {
          final eventId = state.pathParameters['eventId'] ?? '';
          if (eventId.isEmpty) {
            // If no eventId, navigate back to events
            return const EventsScreen();
          }
          return EventSettingsScreen.fromEventId(eventId: eventId);
        },
      ),
      GoRoute(
        path: AppConstants.settingsRoute,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppConstants.helpRoute,
        builder: (context, state) => const HelpScreen(),
      ),
    ],
  );
}
