import 'package:flutter_test/flutter_test.dart';
import 'package:spreeloop_core_authentication/authentication.dart';
import 'package:spreeloop_core_authentication/src/auth_fake_implementation.dart';

void main() {
  final String phoneNumber = '+237696292947';
  final String userId = 'users_1';
  final String validOtpCode = '123456';
  final String invalidOtpCode = '000000';

  test('User is unverified and null by default', () async {
    final Authentication auth = AuthFakeImplementation(
      uid: userId,
      testPhoneNumber: phoneNumber,
      testSmsCode: validOtpCode,
    );
    expect(auth.isUserVerified(), false);
    expect(auth.uid, null);
  });

  test('Failed authentication does not initialize the user', () async {
    final Authentication auth = AuthFakeImplementation(
      uid: userId,
      testPhoneNumber: phoneNumber,
      testSmsCode: validOtpCode,
    );
    final authResult = await auth.authenticateWithOTPCode(
      phoneNumber,
      invalidOtpCode,
      onVerificationCompleted: () => {},
      onVerificationFailed: (_) => {},
    );
    expect(authResult, false);
    expect(auth.isUserVerified(), false);
    expect(auth.uid, null);
  });

  test('Successful authentication verifies and initializes user', () async {
    final Authentication auth = AuthFakeImplementation(
      uid: userId,
      testPhoneNumber: phoneNumber,
      testSmsCode: validOtpCode,
    );
    final authResult = await auth.authenticateWithOTPCode(
      phoneNumber,
      validOtpCode,
      onVerificationCompleted: () => {},
      onVerificationFailed: (_) => {},
    );
    expect(authResult, true);
    expect(auth.isUserVerified(), true);
    expect(auth.uid, userId);
  });
}
