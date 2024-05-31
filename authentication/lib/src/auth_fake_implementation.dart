import 'dart:async';
import 'dart:ui';

import '../authentication.dart';

/// The purpose of this implementation is to fake an auth authentication, and
/// should only be used for testing purposes.
class AuthFakeImplementation implements Authentication {
  final String _authenticatedUserId;
  final String _testPhoneNumber;
  final String _testSmsCode;
  final String _anonymousUserId = 'anon_uid';

  String? _uid;

  bool _isVerified = false;
  final StreamController<UserType> _authStatesStream =
      StreamController.broadcast();

  @override
  String? get uid => _uid;

  /// Constructs an AuthFakeImplementation.
  AuthFakeImplementation({
    String? uid,
    String? testPhoneNumber,
    String? testSmsCode,
  })  : _authenticatedUserId = uid ?? 'users_1',
        _testPhoneNumber = testPhoneNumber ?? '+237696292947',
        _testSmsCode = testSmsCode ?? '123456';

  @override
  bool isUserVerified() {
    return _isVerified;
  }

  @override
  Future<bool> authenticateAnonymously() async {
    _isVerified = false;
    _uid = _anonymousUserId;
    _authStatesStream.add(UserType.anonymous);

    return true;
  }

  @override
  Future<bool> authenticateWithPhoneNumber(
    PhoneNumberAuthenticationParameter param, {
    int? forceResendingToken,
  }) async {
    if (param.phoneNumber == _testPhoneNumber) {
      param.onVerificationCodeSent();

      return true;
    }

    return false;
  }

  @override
  Future<bool> authenticateWithOTPCode(
    String phoneNumber,
    String otpCode, {
    required VoidCallback onVerificationCompleted,
    required void Function(String) onVerificationFailed,
  }) async {
    if (otpCode == _testSmsCode) {
      _isVerified = true;
      _uid = _authenticatedUserId;
      _authStatesStream.add(UserType.verified);
      onVerificationCompleted();

      return true;
    }

    onVerificationFailed('otp-code-does-not-match');

    return false;
  }

  @override
  Stream<UserType> authStateChanges() {
    return _authStatesStream.stream;
  }

  @override
  Future<void> initialized() async {
    return;
  }
}
