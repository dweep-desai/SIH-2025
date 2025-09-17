import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sih_project/pages/faculty_student_search_page.dart';

void main() {
  group('FacultyStudentSearchPage Responsive Layout Tests', () {
    testWidgets('Layout uses Wrap to prevent overflow at all screen widths', (WidgetTester tester) async {
      // Test at 360px width (mobile portrait) - should wrap filters
      await tester.binding.setSurfaceSize(const Size(360, 640));
      await tester.pumpWidget(
        MaterialApp(
          home: FacultyStudentSearchPage(),
        ),
      );
      
      // Verify search field is present
      expect(find.byType(TextField), findsOneWidget);
      
      // Verify filters are present and wrapped properly
      expect(find.text('Branch'), findsOneWidget);
      expect(find.text('Domain'), findsOneWidget);
      expect(find.text('Sort By'), findsOneWidget);
      
      // Verify Wrap widget is used for responsive layout
      expect(find.byType(Wrap), findsOneWidget);
      
      // Test at 412px width (mobile landscape)
      await tester.binding.setSurfaceSize(const Size(412, 640));
      await tester.pumpWidget(
        MaterialApp(
          home: FacultyStudentSearchPage(),
        ),
      );
      
      // Verify layout still works
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Branch'), findsOneWidget);
      expect(find.text('Domain'), findsOneWidget);
      expect(find.text('Sort By'), findsOneWidget);
      
      // Test at 768px width (tablet)
      await tester.binding.setSurfaceSize(const Size(768, 1024));
      await tester.pumpWidget(
        MaterialApp(
          home: FacultyStudentSearchPage(),
        ),
      );
      
      // Verify layout still works
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Branch'), findsOneWidget);
      expect(find.text('Domain'), findsOneWidget);
      expect(find.text('Sort By'), findsOneWidget);
    });

    testWidgets('No overflow errors at very narrow widths', (WidgetTester tester) async {
      // Test at very narrow width (320px) - should still work with Wrap
      await tester.binding.setSurfaceSize(const Size(320, 640));
      
      await tester.pumpWidget(
        MaterialApp(
          home: FacultyStudentSearchPage(),
        ),
      );
      
      // Pump and verify no overflow errors
      await tester.pump();
      
      // Verify all elements are still visible and accessible
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Branch'), findsOneWidget);
      expect(find.text('Domain'), findsOneWidget);
      expect(find.text('Sort By'), findsOneWidget);
      
      // Verify ConstrainedBox and Flexible widgets are used for proper sizing
      expect(find.byType(ConstrainedBox), findsNWidgets(3));
      expect(find.byType(Flexible), findsNWidgets(3));
    });
  });
}
