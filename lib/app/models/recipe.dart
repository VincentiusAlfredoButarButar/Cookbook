class Recipe {
  final int? id;
  final String title;
  final String category;
  final int cookTime;
  final int servings;
  final String ingredients;
  final String steps;
  final String? imageUrl;

  Recipe({
    this.id,
    required this.title,
    required this.category,
    required this.cookTime,
    required this.servings,
    required this.ingredients,
    required this.steps,
    this.imageUrl,
  });

  Recipe.fromJson(dynamic data)
    : id = data['id'],
      title = data['title'],
      category = data['category'],
      cookTime = data['cook_time'],
      servings = data['servings'],
      ingredients = data['ingredients'],
      steps = data['steps'],
      imageUrl = data['image_url'];

  Map<String, dynamic> toJson() => {
    'title': title,
    'category': category,
    'cook_time': cookTime,
    'servings': servings,
    'ingredients': ingredients,
    'steps': steps,
    'image_url': imageUrl,
  };
}
