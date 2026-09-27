import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'router/app_router.dart';
import 'providers/UserSessionProvider.dart';
import 'providers/ProfileProvider.dart';
import 'providers/QuizStateProvider.dart';
import 'providers/RoadmapProvider.dart';
import 'providers/CourseProvider.dart';
import 'providers/JobProvider.dart';
import 'providers/CertificationProvider.dart';
import 'providers/skill_gap_provider.dart';
import 'services/skill_requirement_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://lrjlggmrkjiljmiiinrp.supabase.co',
  );

  const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxyamxnZ21ya2ppbGptaWlpbnJwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODgwMjAyMjcsImV4cCI6MjEwMzU5NjIyN30.m8xnAejzbkVtDPKD9ywdfx9DYJwkRVISu9Q0QpejgLo',
  );

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserSessionProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => QuizStateProvider()),
        ChangeNotifierProvider(create: (_) => RoadmapProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => CertificationProvider()),
        ProxyProvider3<CertificationProvider, RoadmapProvider, SkillRequirementService, SkillGapProvider>(
          update: (context, cert, road, skillReq, previous) =>
              SkillGapProvider(cert, road, skillReq),
          create: (context) => SkillGapProvider(
            Provider.of<CertificationProvider>(context, listen: false),
            Provider.of<RoadmapProvider>(context, listen: false),
            Provider.of<SkillRequirementService>(context, listen: false),
          ),
        ),
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
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}