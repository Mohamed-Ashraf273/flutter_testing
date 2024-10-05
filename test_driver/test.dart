import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart'; //flutter driver API
import 'package:test/test.dart'; //framework

void main() {
  FlutterDriver? driver; // taking an instance of flutter driver
  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    driver?.close(); //if driver != NULL close it
  });

  test('Login testing', () async {
    // Input valid credentials
    await driver?.tap(find.byValueKey('usernameField'));
    await driver?.enterText('Michael'); // Use the first name
    await driver?.tap(find.byValueKey('passwordField'));
    await driver?.enterText('7'); // Use the user ID
    await driver?.takeScreenshot("info enetred");
    // Tap the login button
    await driver?.tap(find.byValueKey('loginButton'));

    // Wait for the success message to appear
    await driver?.waitFor(find.text('Login successful!'));
  });
}

extension on FlutterDriver {
  Future<void> takeScreenshot(String name) async {
    final filepath = File('screenshots/$name.png');
    if (await filepath.exists()) {
      await filepath.delete();
    }
    final file = await filepath.create(recursive: true);
    final png = await screenshot();
    file.writeAsBytes(png);
  }
}
