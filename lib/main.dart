import '/bootstrap/env.g.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'bootstrap/boot.dart';
import 'package:flutter/foundation.dart';

/// Nylo - Framework for Flutter Developers
/// Docs: https://nylo.dev/docs/7.x

/// Main entry point for the application.
void main() async {
  if (kIsWeb) {
    NyLogger.useColors = false;
  }
  await Nylo.init(
    env: Env.get,
    setup: Boot.nylo(),
    appLifecycle: {
      // Uncomment the code below to enable app lifecycle events
      // AppLifecycleState.resumed: () {
      //   print("App resumed");
      // },
      // AppLifecycleState.paused: () {
      //   print("App paused");
      // },
    },
  );
}
