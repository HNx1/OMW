import 'package:omw/widget/validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Regex should be true', () {
    String test_password = "Testing1!";
    String? regex_validation = isValidpassword(test_password);
    expect(regex_validation == null, true);
  });
}
