import 'dart:ui';

import 'src/auth_fake_implementation.dart';
import 'src/auth_firebase_implementation.dart';
import 'src/auth_firebase_web_implementation.dart';

/// The parameter to provide for phone number authentication.
class PhoneNumberAuthenticationParameter {
  /// The phone number for authentication.
  final String phoneNumber;

  /// The method to call on verification completed.
  final VoidCallback onVerificationCompleted;

  /// The method to call on verification failed.
  final Function(String) onVerificationFailed;

  /// The method to call on verification code sent.
  final VoidCallback onVerificationCodeSent;

  /// The method to call on verification auto retrieval timeout.
  final VoidCallback onVerificationAutoRetrievalTimeout;

  /// Constructs a new [PhoneNumberAuthenticationParameter].
  PhoneNumberAuthenticationParameter({
    required this.phoneNumber,
    required this.onVerificationCompleted,
    required this.onVerificationFailed,
    required this.onVerificationCodeSent,
    required this.onVerificationAutoRetrievalTimeout,
  });
}

/// Supported authentication backends.
enum AuthType {
  /// Firebase implementation for Auth.
  firebase,

  /// Firebase implementation for Auth specific to Web.
  firebaseWeb,

  /// Fake auth implementation for testing.
  fake,
}

/// Types of user that can be logged in.
enum UserType {
  /// A user authenticated and verified.
  verified,

  /// A user authenticated and NOT verified (anonymous).
  anonymous,

  /// Unauthenticated user (no uid).
  unknown,
}

/// Service that provides Database implementations to apps.
abstract class Authentication {
  /// Completes when the Auth system has been initialized.
  Future<void> initialized();

  /// Returns true if the user is authenticated and verified.
  ///
  /// An anonymous user is authenticated, but NOT verified.
  /// A user that authenticates using a phone number is authenticated AND
  /// verified.
  bool isUserVerified();

  /// Authenticates the user as an anonymous user.
  /// If there is already an anonymous user signed in, that user will be
  /// returned instead.
  /// If there is any other existing user signed in, that user will be
  /// signed out.
  Future<bool> authenticateAnonymously();

  /// Returns the user unique identifier.
  String? get uid;

  /// Constructs the Authentication using an Auth type.
  factory Authentication(AuthType authType) {
    switch (authType) {
      case AuthType.firebase:
        return AuthFirebaseImplementation();
      case AuthType.firebaseWeb:
        return AuthFirebaseWebImplementation();
      default:
        return AuthFakeImplementation();
    }
  }

  /// Constructs the Authentication service using a fake implementation with
  /// a custom configuration.
  factory Authentication.fake({
    String? uid,
    String? testPhoneNumber,
    String? testSmsCode,
  }) {
    return AuthFakeImplementation(
      uid: uid,
      testPhoneNumber: testPhoneNumber,
      testSmsCode: testSmsCode,
    );
  }

  /// Attempts to authenticate and verify a user using their phone number.
  ///
  /// [verificationCompleted] Triggered when an SMS is auto-retrieved or the
  /// phone number has been instantly verified.
  ///
  /// [verificationFailed] Triggered when an error occurred during phone number
  /// verification, with the error code as a parameter.
  ///
  /// [codeSent] Triggered when an SMS has been sent to the users phone.
  ///
  /// [codeAutoRetrievalTimeout] Triggered when SMS auto-retrieval times out.
  Future<bool> authenticateWithPhoneNumber(
    PhoneNumberAuthenticationParameter param,
  );

  /// Attempts to authenticate and verify a user using their phone number and
  /// an OTP code.
  ///
  /// [verificationCompleted] Triggered when the OTP code was verified
  /// successfully.
  ///
  /// [verificationFailed] Triggered when an error occurred during OTP
  /// verification, with the error code as a parameter.
  Future<bool> authenticateWithOTPCode(
    String phoneNumber,
    String otpCode, {
    required VoidCallback onVerificationCompleted,
    required Function(String) onVerificationFailed,
  });

  /// Stream to track auth state.
  Stream<UserType> authStateChanges();
}
