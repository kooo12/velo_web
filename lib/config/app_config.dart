abstract class AppConfig {
  static const String formspreeId = String.fromEnvironment(
    'FORMSPREE_ID',
    defaultValue: '',
  );

  static const String formspreeApiEndpoint = String.fromEnvironment(
    'FORMSPREE_API_ENDPOINT',
    defaultValue: 'https://formspree.io/f/',
  );
}
