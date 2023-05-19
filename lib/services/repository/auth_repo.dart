import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khoroch/core/util/util.dart';

final authRepoProvider = Provider<AuthRepo>((ref) {
  return AuthRepo();
});

class AuthRepo {
  final _auth = FirebaseAuth.instance;

  FutureEither<UserCredential> googleLogin() async {
    final gUser = await GoogleSignIn().signIn();
    if (gUser == null) {
      return left(const Failure('Login Failed'));
    }

    try {
      final gAuth = await gUser.authentication;

      final gCred = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(gCred);

      return right(userCred);
    } on FirebaseAuthException catch (exc) {
      log(exc.message ?? 'Something went wrong');
      return left(Failure.fromFireAuth(exc));
    }
  }
}
