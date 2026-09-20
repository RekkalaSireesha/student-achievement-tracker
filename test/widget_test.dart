import 'package:flutter_test/flutter_test.dart';

import 'package:student_achievement_tracker/main.dart';

void main() {
  testWidgets(
    'Student Achievement Tracker loads',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const StudentAchievementTracker(),
      );

      expect(
        find.text('My Achievements'),
        findsOneWidget,
      );
    },
  );
}