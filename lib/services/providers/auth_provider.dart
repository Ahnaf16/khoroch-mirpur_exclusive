import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/services/controllers/controllers.dart';

User? get getUser => FirebaseAuth.instance.currentUser;

final authStateChangeProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final authStateProvider = Provider<AuthState>((ref) {
  final stateChanges = ref.watch(authStateChangeProvider);

  final state = stateChanges.when(
    data: (user) =>
        user == null ? AuthState.unauthenticated : AuthState.authenticated,
    error: (err, st) => AuthState.error,
    loading: () => AuthState.loading,
  );
  return state;
});
