import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProvider extends NyProvider {
  @override
  Future<Nylo> boot(Nylo nylo) async {
    // Load .env
    await dotenv.load(fileName: ".env");

    // Debug
    print("SUPABASE URL = ${dotenv.env["SUPABASE_URL"]}");

    // Initialize Supabase
    await Supabase.initialize(
      url: dotenv.env["SUPABASE_URL"]!,
      publishableKey: dotenv.env["SUPABASE_ANON_KEY"]!,
    );

    print("✅ Supabase Connected!");

    return nylo;
  }
}
