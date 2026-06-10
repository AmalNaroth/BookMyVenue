import '../entities/app_user.dart';

abstract interface class AuthRepository {
  Stream<AppUser?> watchAuthState();

  AppUser? get currentUser;

  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AppUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();
}
