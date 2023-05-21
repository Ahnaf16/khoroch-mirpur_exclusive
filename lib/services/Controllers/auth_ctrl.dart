import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/services/repository/auth_repo.dart';
import 'package:khoroch/widgets/loader.dart';

enum AuthState { unauthenticated, authenticated, loading, error }

final authCtrlProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(this._ref) : super(AuthState.unauthenticated);

  final Ref _ref;

  OverlayLoader _loader(BuildContext context) => OverlayLoader(context);

  AuthRepo get _repo => _ref.watch(authRepoProvider);

  login(context) async {
    state = AuthState.loading;
    final userCred = await _repo.googleLogin();

    userCred.fold((l) {
      state = AuthState.error;
      _loader(context).showError(l.message);
    }, (r) {
      state = AuthState.authenticated;
      _loader(context).showSuccess('Login Success');
    });
  }

  logOut() async {
    await _repo.logOut();
  }
}
