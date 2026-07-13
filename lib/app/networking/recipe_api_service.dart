import 'package:nylo_framework/nylo_framework.dart';
import '/app/models/recipe.dart';
import '/bootstrap/decoders.dart';
import '/app/networking/supabase_client.dart';

class RecipeApiService extends NyApiService {
  RecipeApiService() : super(decoders: modelDecoders);

  static String get endpoint => 'recipe';

  Future<List<Recipe>> fetchAll() async {
    print("ENDPOINT = $endpoint");
    print("FETCHING FROM: $endpoint");
    final data = await supabase
        .from(endpoint)
        .select()
        .order('id', ascending: false);

    return data.map<Recipe>((json) => Recipe.fromJson(json)).toList();
  }

  Future<Recipe> create(Recipe recipe) async {
    final data = await supabase
        .from(endpoint)
        .insert(recipe.toJson())
        .select()
        .single();

    return Recipe.fromJson(data);
  }

  Future<Recipe> update(Recipe recipe) async {
    final data = await supabase
        .from(endpoint)
        .update(recipe.toJson())
        .eq('id', recipe.id!)
        .select()
        .single();

    return Recipe.fromJson(data);
  }

  Future<bool?> destroy(int id) async {
    return await supabase.from(endpoint).delete().eq('id', id);
  }
}
