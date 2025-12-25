import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Helper function to create a ProviderContainer for testing
ProviderContainer createContainer({List<Override>? overrides}) {
  return ProviderContainer(overrides: overrides ?? []);
}

/// Helper function to create a WidgetTester with ProviderScope
Future<void> pumpWidgetWithProviders(
  WidgetTester tester,
  Widget widget, {
  List<Override>? overrides,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(home: widget),
    ),
  );
}
