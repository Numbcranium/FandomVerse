import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/router/app_router.dart';
import 'core/constants/app_constants.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'firebase/firebase_service.dart';
import 'firebase_options.dart';
import 'models/fandom_news_seed.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();

  final prefs = await SharedPreferences.getInstance();

  final authRepository = AuthRepositoryImpl(FirebaseAuthRemoteDataSource());
  final authBloc = AuthBloc(authRepository)..add(const AuthSubscriptionRequested());

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Seed gallery data into Firestore
  // await FandomGallerySeed().seedGallery();

  final appRouter = AppRouter(
    authStatus: () => authBloc.state.status,
    // Read fresh each time rather than capturing a single bool at startup,
    // so a value the onboarding screen writes mid-session is respected.
    isFirstLaunch: () => !(prefs.getBool(AppConstants.prefsFirstLaunchKey) ?? false),
    needsInterestsSelection: () => authBloc.state.user?.selectedFandoms.isEmpty ?? true,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
  );

  runApp(
    BlocProvider.value(
      value: authBloc,
      child: App(router: appRouter.router),
    ),
  );
}
