// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get email => 'ای میل';

  @override
  String get password => 'پاس ورڈ';

  @override
  String get login => 'لاگ ان';

  @override
  String get logout => 'لاگ آؤٹ';

  @override
  String get aCompleteValidEmailExamplejoegmailcom =>
      'ایک مکمل، درست ای میل جیسے joe@gmail.com';

  @override
  String get passwordShouldbeatleast_characterswithatleastoneletterandnumber =>
      'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے جس میں کم از کم ایک حرف اور نمبر ہو';

  @override
  String get popularShows => 'مقبول شوز';

  @override
  String get noDataFound => 'کوئی ڈیٹا نہیں ملا';

  @override
  String get noInternetConnection => 'انٹرنیٹ کنکشن نہیں ہے';

  @override
  String get splashScreen => 'خوش آمدید';
}
