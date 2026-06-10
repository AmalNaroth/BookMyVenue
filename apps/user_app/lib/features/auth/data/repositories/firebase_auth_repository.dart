import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_data_source.dart';
import '../models/auth_user_mapper.dart';

class FirebaseAuthRepository implements AuthRepository {
  const FirebaseAuthRepository(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<AppUser?> watchAuthState() {
    return _remoteDataSource.watchAuthState().map((user) => user?.toAppUser());
  }

  @override
  AppUser? get currentUser => _remoteDataSource.currentUser?.toAppUser();

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _guardAuthCall(
      () => _remoteDataSource
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) => user.toAppUser()),
    );
  }

  @override
  Future<AppUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    return _guardAuthCall(
      () => _remoteDataSource
          .signUpWithEmailAndPassword(
            email: email,
            password: password,
            name: name,
          )
          .then((user) => user.toAppUser()),
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _guardAuthCall(
      () => _remoteDataSource.sendPasswordResetEmail(email),
    );
  }

  @override
  Future<void> signOut() {
    return _guardAuthCall(_remoteDataSource.signOut);
  }

  Future<T> _guardAuthCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageForCode(error));
    } catch (_) {
      throw const AuthFailure('Something went wrong. Please try again.');
    }
  }

  String _messageForCode(FirebaseAuthException error) {
    return switch (error.code) {
      'invalid-email' => 'Enter a valid email address.',
      'user-disabled' => 'This account has been disabled.',
      'user-not-found' => 'No account found for this email.',
      'wrong-password' || 'invalid-credential' => 'Invalid email or password.',
      'email-already-in-use' => 'An account already exists for this email.',
      'weak-password' => 'Use a stronger password.',
      'network-request-failed' => 'Check your internet connection.',
      'too-many-requests' => 'Too many attempts. Please try again later.',
      'missing-user' => error.message ?? 'Could not load your account.',
      _ => error.message ?? 'Authentication failed. Please try again.',
    };
  }
}
