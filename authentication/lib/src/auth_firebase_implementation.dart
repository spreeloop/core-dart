import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import '../authentication.dart';

/// Firebase implementation of the authentication interface.
class AuthFirebaseImplementation implements Authentication {
  final _log = Logger('AuthInterfaceFirebaseImplementation');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Completer<void> _initialized = Completer();

  final Map<String, String> _otpVerificationIds = {};
  final Map<String, int?> _resendTokens = {};

  @override
  String? get uid => _firebaseAuth.currentUser?.uid;

  /// Constructs a [AuthFirebaseImplementation].
  AuthFirebaseImplementation() {
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
        'Exception while signing anonymously: ${e.toString()}',
        e,
        e.stackTrace,
      );

      return false;
    }

    return true;
  }

  Future<bool> _authenticateWithPhoneNumberInternal(
    PhoneNumberAuthenticationParameter param, {
    int? forceResendingToken,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: param.phoneNumber,

        // If the SIM (with phoneNumber) is in the current device this
        // function is called. This function gives `AuthCredential`.
        // Moreover `login` function can be called from this callback.
        verificationCompleted: (credentials) => _verificationCompleted(
          credentials,
          param.onVerificationCompleted,
          param.onVerificationFailed,
        ),

        // Called when the verification fails.
        verificationFailed: (exception) => _verificationFailed(
          param.phoneNumber,
          exception,
          param.onVerificationFailed,
        ),

        // This is called after the OTP is sent.
        // Gives a `verificationId` and `resendToken`.
        codeSent: (verificationId, resendToken) => _codeSent(
          verificationId,
          resendToken,
          param.phoneNumber,
          param.onVerificationCodeSent,
        ),

        // After automatic code retrieval `timeout` this function is called.
        codeAutoRetrievalTimeout: (verificationId) => _codeAutoRetrievalTimeout(
          verificationId,
          param.onVerificationAutoRetrievalTimeout,
        ),

        // The forceResendingToken obtained from codeSent callback to force
        // re-sending another verification SMS before the auto-retrieval
        // timeout.
        forceResendingToken: forceResendingToken,
      );
    } on FirebaseAuthException catch (e) {
      _log.severe(
        'Exception while verifying phone number: ${e.toString()}',
        e,
        e.stackTrace,
      );

      return false;
    }

    return true;
  }

  @override
  Future<bool> authenticateWithPhoneNumber(
    PhoneNumberAuthenticationParameter param, {
    int? forceResendingToken,
  }) async {
    return _authenticateWithPhoneNumberInternal(
      param,
      forceResendingToken: forceResendingToken,
    );
  }

  void _verificationCompleted(
    AuthCredential credential,
    VoidCallback onVerificationCompleted,
    void Function(String) onVerificationFailed,
  ) async {
    _log.fine('Automatic phone verification.');

    try {
      final credentialResult =
          await _firebaseAuth.signInWithCredential(credential);
      _log.fine('signInWithCredential done with result $credentialResult');
    } on FirebaseAuthException catch (e) {
      _log.severe(
        'Exception during automatic code handling: ${e.toString()}',
        e,
        e.stackTrace,
      );
      onVerificationFailed(e.code);

      return;
    }

    onVerificationCompleted();
  }

  void _verificationFailed(
    String phoneNumber,
    FirebaseAuthException exception,
    void Function(String) onVerificationFailed,
  ) {
    _log.severe(
      'Phone($phoneNumber) verification failed with \n'
      'exception.credential:${exception.credential?.asMap()}\n'
      'exception.phoneNumber:${exception.phoneNumber}\n'
      'exception.email:${exception.email}\n'
      'error details: ${exception.toString()}',
      null,
      StackTrace.current,
    );

    onVerificationFailed(exception.code);
  }

  void _codeSent(
    String verificationId,
    int? resendToken,
    String phoneNumber,
    VoidCallback onVerificationCodeSent,
  ) {
    _log.info('codeSent. verificationId: $verificationId, '
        'resendToken: $resendToken');
    _otpVerificationIds[phoneNumber] = verificationId;
    _resendTokens[phoneNumber] = resendToken;

    onVerificationCodeSent();
  }

  void _codeAutoRetrievalTimeout(
    String verificationId,
    VoidCallback onVerificationAutoRetrievalTimeout,
  ) {
    _log.warning('codeAutoRetrievalTimeout: $verificationId');

    onVerificationAutoRetrievalTimeout();
  }

  @override
  Future<bool> authenticateWithOTPCode(
    String phoneNumber,
    String otpCode, {
    required VoidCallback onVerificationCompleted,
    required void Function(String) onVerificationFailed,
  }) async {
    final verificationId = _otpVerificationIds[phoneNumber];
    if (verificationId == null) {
      _log.severe(
        'Attempt to confirm an OTP code before doing an'
        ' authentication with phone number.',
        null,
        StackTrace.current,
      );

      return false;
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );
      final credentialResult =
          await _firebaseAuth.signInWithCredential(credential);
      _log.fine('signInWithCredential done with result $credentialResult');
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
