import 'package:equatable/equatable.dart';

import '../../domain/entities/app_user.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

const _unset = Object();

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.user,
    this.isSubmitting = false,
    this.errorMessage,
    this.passwordResetEmailSent = false,
  });

  const AuthState.initial() : this(status: AuthStatus.initial);

  final AuthStatus status;
  final AppUser? user;
  final bool isSubmitting;
  final String? errorMessage;
  final bool passwordResetEmailSent;

  bool get hasResolvedAuthState => status != AuthStatus.initial;

  AuthState copyWith({
    AuthStatus? status,
    Object? user = _unset,
    bool? isSubmitting,
    Object? errorMessage = _unset,
    bool? passwordResetEmailSent,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user == _unset ? this.user : user as AppUser?,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage == _unset
          ? this.errorMessage
          : errorMessage as String?,
      passwordResetEmailSent:
          passwordResetEmailSent ?? this.passwordResetEmailSent,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    isSubmitting,
    errorMessage,
    passwordResetEmailSent,
  ];
}
