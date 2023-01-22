import 'package:omw/widget/validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Regex should be true', () {
    String testPassword = "Testing1!";
    String? regexValidation = isValidpassword(testPassword);
    expect(regexValidation == null, true);
  });
}
