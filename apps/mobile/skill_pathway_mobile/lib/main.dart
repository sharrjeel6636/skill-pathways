import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'router/app_router.dart';
import 'providers/UserSessionProvider.dart';
import 'providers/QuizStateProvider.dart';
import 'providers/RoadmapProvider.dart';
import 'providers/CourseProvider.dart';
import 'providers/JobProvider.dart';
import 'providers/CertificationProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase (add your actual URL and Anon Key here)
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL', defaultValue: ''),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: ''),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserSessionProvider()),
        ChangeNotifierProvider(create: (_) => QuizStateProvider()),
        ChangeNotifierProvider(create: (_) => RoadmapProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => CertificationProvider()),
      ],
      child: const SkillPathwayApp(),
    ),
  );
}

class SkillPathwayApp extends StatelessWidget {
  const SkillPathwayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Skill Pathway',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1E2022),
      ),
      routerConfig: appRouter,
    );
  }
}
