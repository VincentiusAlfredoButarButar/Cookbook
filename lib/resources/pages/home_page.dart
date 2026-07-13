import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/app/controllers/home_controller.dart';
import '/app/models/recipe.dart';

import '/resources/widgets/recipe_card_widget.dart';
import 'recipe_form_page.dart';

class HomePage extends NyStatefulWidget<HomeController> {
  static RouteView path = ("/home", (_) => HomePage());

  HomePage() : super(child: () => _HomePageState());
}

class _HomePageState extends NyPage<HomePage> {
  bool isSearching = false;

  final TextEditingController searchController = TextEditingController();
  Future<void> _reloadRecipes() async {
    await widget.controller.fetchRecipes();

    if (mounted) {
      setState(() {});
    }
  }

  /// Runs once when the page first loads
  @override
  get init => () async {
    await _reloadRecipes();
  };

  @override
  Widget view(BuildContext context) {
    final List<Recipe> recipes = widget.controller.recipes;
    final List<Recipe> filteredRecipes = searchController.text.isEmpty
        ? recipes
        : recipes.where((recipe) {
            return recipe.title.toLowerCase().contains(
              searchController.text.toLowerCase(),
            );
          }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,

        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: "Search recipe...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (_) {
                  setState(() {});
                },
              )
            : const Text(
                "Cookbook",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),

        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchController.clear();
                }

                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
      body: afterLoad(
        child: () {
          return RefreshIndicator(
            onRefresh: _reloadRecipes,
            child: filteredRecipes.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: const [
                      SizedBox(height: 140),
                      Center(
                        child: Text(
                          'No recipes yet.\nPull to refresh or tap + to create one!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ],
                  )
                : GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.70,
                        ),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      return RecipeCard(
                        recipe: filteredRecipes[index],
                        onTap: () async {
                          await routeTo(
                            RecipeFormPage.path,
                            data: filteredRecipes[index],
                          );
                          debugPrint("BACK FROM NOTE FORM");

                          await _reloadRecipes();
                        },
                        onDelete: () => widget.controller.deleteRecipe(
                          filteredRecipes[index].id!,
                        ),
                      );
                    },
                  ),
          );
        },
      ),
      // FAB — CREATE mode (no data passed)
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await routeTo(RecipeFormPage.path);

          await _reloadRecipes();
        },
        backgroundColor: const Color(0xFF5C6BC0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
