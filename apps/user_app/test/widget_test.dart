import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/features/auth/domain/failures/auth_failure.dart';

void main() {
  test('AuthFailure exposes its message', () {
    const failure = AuthFailure('Invalid email or password.');

    expect(failure.message, 'Invalid email or password.');
    expect(failure.toString(), 'Invalid email or password.');
  });
}
