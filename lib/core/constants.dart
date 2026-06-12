class AppConstants {
  AppConstants._();

  static const String contentAssetPath = 'assets/content/current_affairs.json';

  static const String bookmarksKey = 'bookmarked_ids';
  static const String readKey = 'read_entry_ids';
  static const String languageKey = 'preferred_language';
  static const String fontSizeKey = 'font_size';
  static const String themeKey = 'app_theme';

  static const double maxContentWidth = 680.0;
  static const double defaultPadding = 16.0;

  static const List<String> categoriesNp = [
    'राजनीति',
    'अर्थतन्त्र',
    'विज्ञान/प्रविधि',
    'खेलकुद',
    'अन्तर्राष्ट्रिय',
    'नेपाल',
  ];

  static const List<String> categoriesEn = [
    'Politics',
    'Economy',
    'Science/Tech',
    'Sports',
    'International',
    'Nepal',
  ];
}
