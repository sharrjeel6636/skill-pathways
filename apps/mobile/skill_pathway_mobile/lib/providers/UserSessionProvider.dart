import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserSessionProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  Session? _session;
  Session? get session => _session;

  UserSessionProvider() {
    _session = _supabase.auth.currentSession;
    _supabase.auth.onAuthStateChange.listen((data) {
      _session = data.session;
      notifyListeners();
    });
  }
}
