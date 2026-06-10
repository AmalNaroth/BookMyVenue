import 'package:core/di/injection.dart' as core_di;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/owner_app.dart';
import 'di/owner_app_injection.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await core_di.setupDI();
  configureOwnerAppDependencies();
  runApp(const OwnerApp());
}
