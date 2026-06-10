import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.uid,
    required this.email,
    required this.emailVerified,
    this.displayName,
  });

  final String uid;
  final String? email;
  final bool emailVerified;
  final String? displayName;

  @override
  List<Object?> get props => [uid, email, emailVerified, displayName];
}
