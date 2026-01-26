// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get aCompleteValidEmailExamplejoegmailcom =>
      'A complete, valid email e.g. joe@gmail.com';

  @override
  String get passwordShouldbeatleast_characterswithatleastoneletterandnumber =>
      'Password should be at least 6 characters with at least one letter and number';

  @override
  String get popularShows => 'Popular Shows';

  @override
  String get noDataFound => 'No data found';

  @override
  String get noInternetConnection => 'No Internet Connection';

  @override
  String get splashScreen => 'Welcome';
}
