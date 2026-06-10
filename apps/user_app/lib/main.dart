import 'package:core/di/injection.dart' as core_di;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/user_app.dart';
import 'di/user_app_injection.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await core_di.setupDI();
  configureUserAppDependencies();
  runApp(const UserApp());
}
