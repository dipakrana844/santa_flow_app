/// App-wide constants
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'Secret Santa Generator';
  static const String appVersion = '1.0.0';

  // Participant Constraints
  static const int minParticipants = 3;
  static const int maxParticipants = 100;

  // Validation
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxEmailLength = 100;

  // Hive Box Names
  static const String participantsBoxName = 'participants';
  static const String matchesBoxName = 'matches';
  static const String eventsBoxName = 'events';
  static const String settingsBoxName = 'settings';
  static const String revealTokensBoxName = 'reveal_tokens';
  static const String revealHistoryBoxName = 'reveal_history';

  // Routes
  static const String homeRoute = '/';
  static const String splashRoute = '/splash';
  static const String onboardingRoute = '/onboarding';
  static const String participantsRoute = '/participants';
  static const String matchingRoute = '/matching';
  static const String revealRoute = '/reveal';
  static const String revealHistoryRoute = '/reveal/history';
  static const String qrScannerRoute = '/qr-scanner';
  static const String qrDisplayRoute = '/qr-display';
  static const String eventsRoute = '/events';
  static const String eventSettingsRoute = '/events/settings';
  static const String settingsRoute = '/settings';
  static const String helpRoute = '/help';

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNoParticipants = 'No participants added yet.';
  static const String errorInsufficientParticipants =
      'At least 3 participants are required.';

  // Success Messages
  static const String successParticipantAdded =
      'Participant added successfully!';
  static const String successParticipantRemoved =
      'Participant removed successfully!';
  static const String successMatchesGenerated =
      'Matches generated successfully!';

  // Validation Messages
  static const String validationNameRequired = 'Name is required';
  static const String validationNameTooShort =
      'Name must be at least $minNameLength characters';
  static const String validationEmailRequired = 'Email is required';
  static const String validationEmailInvalid = 'Please enter a valid email';
}
