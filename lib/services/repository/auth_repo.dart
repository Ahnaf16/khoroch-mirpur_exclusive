import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khoroch/core/util/util.dart';
import 'package:khoroch/services/repository/repository.dart';

final authRepoProvider = Provider<AuthRepo>((ref) {
  return AuthRepo(ref);
});

class AuthRepo {
  AuthRepo(this._ref);

  final Ref _ref;
  final _auth = FirebaseAuth.instance;
  final _googleAuth = GoogleSignIn();

  FutureEither<UserCredential> googleLogin() async {
    if (kIsWeb) {
      final authProvider = GoogleAuthProvider();
      final userCred = await _auth.signInWithPopup(authProvider);
      final user = userCred.user;

      if (user == null) {
        return left(const Failure('Unexpected Error'));
      }

      await _userDocCreate(user);
      return right(userCred);
    } else {
      final gUser = await _googleAuth.signIn();

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
        final user = userCred.user;

        if (user == null) {
          return left(const Failure('Unexpected Error'));
        }

        await _userDocCreate(user);

        return right(userCred);
      } on FirebaseAuthException catch (exc) {
        log(exc.message ?? 'Something went wrong');
        return left(Failure.fromFireAuth(exc));
      }
    }
  }

  logOut() async {
    if (!kIsWeb) {
      await _googleAuth.signOut();
    }
    await _auth.signOut();
  }

  Future<void> _userDocCreate(User user) async {
    await _ref.watch(userRepoProvider).createUserDoc(user);
  }
}
