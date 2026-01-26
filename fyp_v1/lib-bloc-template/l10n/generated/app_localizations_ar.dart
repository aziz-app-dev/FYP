// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get aCompleteValidEmailExamplejoegmailcom =>
      'بريد إلكتروني صالح مثل joe@gmail.com';

  @override
  String get passwordShouldbeatleast_characterswithatleastoneletterandnumber =>
      'يجب أن تكون كلمة المرور 6 أحرف على الأقل مع حرف ورقم واحد على الأقل';

  @override
  String get popularShows => 'العروض الشائعة';

  @override
  String get noDataFound => 'لم يتم العثور على بيانات';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get splashScreen => 'مرحباً';
}
