import 'dart:io';

import 'package:path/path.dart' as path;

import '/app/networking/supabase_client.dart';

class StorageService {
  static const String bucket = "recipe-images";

  Future<String?> uploadImage(File file) async {
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}";

    await supabase.storage.from(bucket).upload(fileName, file);

    final imageUrl = supabase.storage.from(bucket).getPublicUrl(fileName);

    return imageUrl;
  }
}
