
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:techwiz7_starter/app/app.dart';

void main() {
testWidgets('FandomVerse app loads successfully', (
WidgetTester tester,
) async {
final router = GoRouter(
initialLocation: '/',
routes: [
GoRoute(
path: '/',
builder: (context, state) => const Scaffold(
body: Text('FandomVerse'),
),
),
],
);

await tester.pumpWidget(
App(router: router),
);

await tester.pumpAndSettle();

expect(find.text('FandomVerse'), findsOneWidget);
});
}

