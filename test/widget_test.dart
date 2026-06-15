import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:my_expenses/hive_setup/hive_initializer.dart';
import 'package:my_expenses/main.dart';

void main() {
  late Directory hiveDirectory;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    hiveDirectory = await Directory.systemTemp.createTemp('my_expenses_test_');
    Hive.init(hiveDirectory.path);
    initHive();
  });

  tearDown(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
    Get.reset();
  });

  testWidgets('renders the expenses home screen', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Hi'), findsOneWidget);
    expect(find.text('Safe to Spend'), findsOneWidget);
    expect(find.text('My Items'), findsOneWidget);
  });
}
