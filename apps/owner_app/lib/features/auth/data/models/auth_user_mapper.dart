import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/app_user.dart';

extension AuthUserMapper on User {
  AppUser toAppUser() {
    return AppUser(
      uid: uid,
      email: email,
      displayName: displayName,
      emailVerified: emailVerified,
    );
  }
}
