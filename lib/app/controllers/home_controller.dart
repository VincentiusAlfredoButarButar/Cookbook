import 'package:nylo_framework/nylo_framework.dart';

import '/app/models/recipe.dart';
import '/app/networking/recipe_api_service.dart';

class HomeController extends NyController {
  List<Recipe> recipes = [];

  /// Fetch all recipes from Supabase
  Future<void> fetchRecipes() async {
    recipes = await api<RecipeApiService>((service) => service.fetchAll());

    setState(setState: () {});
  }

  /// Delete a recipe then refresh the list
  Future<void> deleteRecipe(int id) async {
    await api<RecipeApiService>((service) => service.destroy(id));

    await fetchRecipes();
  }
}
