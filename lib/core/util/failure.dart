import 'package:firebase_auth/firebase_auth.dart';

class Failure {
  const Failure(
    this.message, {
    this.stackTrace,
    this.subMessage,
  });

  final String message;
  final String? subMessage;
  final StackTrace? stackTrace;

  Failure copyWith({
    String? message,
    String? subMessage,
    StackTrace? stackTrace,
  }) {
    return Failure(
      message ?? this.message,
      subMessage: subMessage ?? this.subMessage,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  factory Failure.fromFireAuth(FirebaseAuthException exc) {
    return Failure(
      exc.message ?? 'Something Went Wrong',
      stackTrace: exc.stackTrace,
      subMessage: exc.code,
    );
  }

  @override
  String toString() {
    return 'Failure(message: $message, subMessage: $subMessage, stackTrace: $stackTrace)';
  }
}
