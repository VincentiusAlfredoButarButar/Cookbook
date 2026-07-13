import 'package:supabase_flutter/supabase_flutter.dart';

/// Global Supabase client.
/// Usage: import this file, then call `supabase.from('recipe').select()`.
final supabase = Supabase.instance.client;
