import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/usecases/send_password_reset_email.dart';
import '../../domain/usecases/sign_in_with_email_and_password.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up_with_email_and_password.dart';
import '../../domain/usecases/watch_auth_state.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._watchAuthState,
    this._signInWithEmailAndPassword,
    this._signUpWithEmailAndPassword,
    this._sendPasswordResetEmail,
    this._signOut,
  ) : super(const AuthState.initial()) {
    on<AuthSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  final WatchAuthState _watchAuthState;
  final SignInWithEmailAndPassword _signInWithEmailAndPassword;
  final SignUpWithEmailAndPassword _signUpWithEmailAndPassword;
  final SendPasswordResetEmail _sendPasswordResetEmail;
  final SignOut _signOut;

  Future<void> _onSubscriptionRequested(
    AuthSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) {
    return emit.onEach<AppUser?>(
      _watchAuthState(),
      onData: (user) {
        if (user == null) {
          emit(
            state.copyWith(
              status: AuthStatus.unauthenticated,
              user: null,
              isSubmitting: false,
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            isSubmitting: false,
            errorMessage: null,
          ),
        );
      },
      onError: (_, _) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            user: null,
            isSubmitting: false,
            errorMessage: 'Could not load your session.',
          ),
        );
      },
    );
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) {
    return _runAuthAction(
      emit,
      () => _signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      ),
    );
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) {
    return _runAuthAction(
      emit,
      () => _signUpWithEmailAndPassword(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );
  }

  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) {
    return _runAuthAction(
      emit,
      () => _sendPasswordResetEmail(event.email),
      passwordResetEmailSent: true,
    );
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) {
    return _runAuthAction(emit, () => _signOut.call());
  }

  Future<void> _runAuthAction(
    Emitter<AuthState> emit,
    Future<dynamic> Function() action, {
    bool passwordResetEmailSent = false,
  }) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        passwordResetEmailSent: false,
      ),
    );

    try {
      await action();
      emit(
        state.copyWith(
          isSubmitting: false,
          passwordResetEmailSent: passwordResetEmailSent,
        ),
      );
    } on AuthFailure catch (failure) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
          passwordResetEmailSent: false,
        ),
      );
    }
  }
}
