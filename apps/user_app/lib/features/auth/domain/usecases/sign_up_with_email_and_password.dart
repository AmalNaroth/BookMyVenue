import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailAndPassword {
  const SignUpWithEmailAndPassword(this._repository);

  final AuthRepository _repository;

  Future<AppUser> call({
    required String email,
    required String password,
    required String name,
  }) {
    return _repository.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
  }
}
