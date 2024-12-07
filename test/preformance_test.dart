import 'package:emdad_cpit499/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Performance Test: Home Page Load', (WidgetTester tester) async {
    final stopwatch = Stopwatch()..start();

    // Build the Home Page
    await tester.pumpWidget(MyApp());

    // Wait for all animations to complete
    await tester.pumpAndSettle();

    stopwatch.stop();

    // Check if the page loads within an acceptable time (e.g., 2 seconds)
    expect(stopwatch.elapsedMilliseconds < 2000, true,
        reason: 'Home Page load time exceeded 2 seconds');
  });
}
