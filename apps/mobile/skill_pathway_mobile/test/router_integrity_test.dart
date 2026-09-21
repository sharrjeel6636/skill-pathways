import 'package:flutter_test/flutter_test.dart';
import 'package:skill_pathway/router/app_router.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('appRouter builds without throwing', () {
    expect(() => appRouter, returnsNormally);
  });

  test('All context.go paths exist in GoRouter', () {
    // This is a simplified check. A more robust check would involve
    // scanning lib/**/*.dart files for context.go calls.
    final registeredPaths = <String>[];
    
    // Helper to extract paths from GoRouter
    void _extractPaths(List<RouteBase> routes) {
      for (var route in routes) {
        if (route is GoRoute) {
          registeredPaths.add(route.path);
        }
        if (route.routes.isNotEmpty) {
          _extractPaths(route.routes);
        }
      }
    }
    
    _extractPaths(appRouter.configuration.routes);
    
    // Known paths based on Phase 0 audit
    final knownPaths = [
      '/splash', '/home', '/auth', '/role-selection', 
      '/discovery', '/counselor-onboarding', '/counselor-dashboard',
      '/chatbot', '/profile', '/parent-dashboard', 
      '/quiz', '/quiz/result', '/roadmap'
    ];
    
    for (var path in knownPaths) {
      expect(registeredPaths.contains(path), isTrue, reason: 'Path $path not registered in appRouter');
    }
  });
}
