import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:admin_v1/common/utils/utils.dart';
import 'package:admin_v1/views/auth/login_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // GetStorage needs path_provider, which has no implementation in the
    // test environment — route it to a temp dir instead.
    final tempDir = Directory.systemTemp.createTempSync('admin_v1_test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => tempDir.path,
    );
    await GetStorage.init();
  });

  tearDown(Get.reset);

  Widget wrap(Widget child) => GetMaterialApp(
        scaffoldMessengerKey: Utils.scaffoldMessengerKey,
        home: child,
      );

  testWidgets('login screen renders and validates empty form',
      (tester) async {
    await tester.pumpWidget(wrap(const LoginScreen()));

    expect(find.text('Super Admin'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    // Submitting empty form shows validation errors, no crash.
    await tester.tap(find.text('Sign In'));
    await tester.pump();
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('login screen rejects short password', (tester) async {
    await tester.pumpWidget(wrap(const LoginScreen()));

    await tester.enterText(
        find.byType(TextFormField).first, 'admin@fyp.com');
    await tester.enterText(find.byType(TextFormField).last, 'short');
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(
        find.text('Password must be at least 8 characters'), findsOneWidget);
  });
}
