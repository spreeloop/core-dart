import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

import '../authentication.dart';

/// Web specific implementation of Auth with Firebase.
///
/// A web specific implementation is currently necessary
/// because Auth on web uses the 'signInWithPhoneNumber' API
/// instead of the 'verifyPhoneNumber' API.
class AuthFirebaseWebImplementation implements Authentication {
  final _log = Logger('AuthFirebaseWebImplementation');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Completer<void> _initialized = Completer();

  final Map<String, ConfirmationResult> _confirmationResults = {};

  @override
  String? get uid => _firebaseAuth.currentUser?.uid.toString();

  /// Constructs a [AuthFirebaseWebImplementation].
  AuthFirebaseWebImplementation() {
    _log.info('Current user (startup): '
        '${_firebaseAuth.currentUser.toString()}');

    /// As soon as we receive an event, assume that FirebaseAuth initialization
    /// is complete.
    final subscribeOnce = _firebaseAuth.authStateChanges().listen(null);
    subscribeOnce.onData((data) {
      subscribeOnce.cancel();
      _initialized.complete();
    });
  }

  @override
  bool isUserVerified() {
    return _firebaseAuth.currentUser?.phoneNumber != null;
  }

  @override
  Future<bool> authenticateAnonymously() async {
    try {
      final signResult = await _firebaseAuth.signInAnonymously();
      _log.fine('Anonymous sign done with response: $signResult');
    } on FirebaseAuthException catch (e) {
      _log.severe(
        'Exception while authenticating anonymously:'
        ' ${e.toString()}',
        e,
        e.stackTrace,
      );

      return false;
    }

    return true;
  }

  @override
  Future<bool> authenticateWithPhoneNumber(
    PhoneNumberAuthenticationParameter param,
  ) async {
    try {
      _confirmationResults[param.phoneNumber] =
          await _firebaseAuth.signInWithPhoneNumber(param.phoneNumber);

      // On the web, there is no automatic SMS verification.
      // So we immediately assume that an OTP code will be sent.
      param.onVerificationCodeSent();
    } on FirebaseAuthException catch (e) {
      _log.severe(
        'Exception while authenticating with phone number:'
        ' ${e.toString()}',
        e,
        e.stackTrace,
      );

      return false;
    }

    return true;
  }

  @override
  Future<bool> authenticateWithOTPCode(
    String phoneNumber,
    String otpCode, {
    required VoidCallback onVerificationCompleted,
    required void Function(String) onVerificationFailed,
  }) async {
    if (!_confirmationResults.containsKey(phoneNumber)) {
      _log.severe('Attempt to confirm an OTP code before doing an'
          ' authentication with phone number.');

      return false;
    }

    try {
      final credential =
          await _confirmationResults[phoneNumber]?.confirm(otpCode);
      _log.fine('otp code confirmation done with result $credential');
      onVerificationCompleted();
    } on FirebaseAuthException catch (e) {
      _log.severe(
        'Exception while verifying otp code: ${e.toString()}',
        e,
        e.stackTrace,
      );
      onVerificationFailed(e.code);
    }

    return true;
  }

  @override
  Stream<UserType> authStateChanges() async* {
    final Stream<User?> users = _firebaseAuth.authStateChanges();

    await for (User? user in users) {
      if (user == null) {
        yield UserType.unknown;
      } else {
        if (user.isAnonymous) {
          yield UserType.anonymous;
        } else {
          yield UserType.verified;
        }
      }
    }
  }

  @override
  Future<void> initialized() {
    return _initialized.future;
  }
}
