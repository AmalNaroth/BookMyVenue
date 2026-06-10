import 'package:core/di/injection.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../features/auth/data/datasources/firebase_auth_data_source.dart';
import '../features/auth/data/repositories/firebase_auth_repository.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/send_password_reset_email.dart';
import '../features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import '../features/auth/domain/usecases/sign_out.dart';
import '../features/auth/domain/usecases/sign_up_with_email_and_password.dart';
import '../features/auth/domain/usecases/watch_auth_state.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

void configureOwnerAppDependencies() {
  if (!getIt.isRegistered<FirebaseAuth>()) {
    getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  }

  if (!getIt.isRegistered<AuthRemoteDataSource>()) {
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => FirebaseAuthRemoteDataSource(getIt<FirebaseAuth>()),
    );
  }

  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(getIt<AuthRemoteDataSource>()),
    );
  }

  if (!getIt.isRegistered<WatchAuthState>()) {
    getIt.registerLazySingleton(() => WatchAuthState(getIt<AuthRepository>()));
  }

  if (!getIt.isRegistered<SignInWithEmailAndPassword>()) {
    getIt.registerLazySingleton(
      () => SignInWithEmailAndPassword(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<SignUpWithEmailAndPassword>()) {
    getIt.registerLazySingleton(
      () => SignUpWithEmailAndPassword(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<SendPasswordResetEmail>()) {
    getIt.registerLazySingleton(
      () => SendPasswordResetEmail(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<SignOut>()) {
    getIt.registerLazySingleton(() => SignOut(getIt<AuthRepository>()));
  }

  if (!getIt.isRegistered<AuthBloc>()) {
    getIt.registerLazySingleton(
      () => AuthBloc(
        getIt<WatchAuthState>(),
        getIt<SignInWithEmailAndPassword>(),
        getIt<SignUpWithEmailAndPassword>(),
        getIt<SendPasswordResetEmail>(),
        getIt<SignOut>(),
      ),
    );
  }
}
