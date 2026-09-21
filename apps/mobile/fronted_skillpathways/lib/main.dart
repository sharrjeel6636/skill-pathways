import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase (add your actual URL and Anon Key here)
  await Supabase.initialize(
    url: 'https://your-project.supabase.co',
    anonKey: 'your-anon-key',
  );

  runApp(const SkillPathwayApp());
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
