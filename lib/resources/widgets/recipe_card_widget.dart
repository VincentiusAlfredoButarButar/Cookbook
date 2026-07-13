import 'package:flutter/material.dart';
import '/app/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _confirmDelete(context),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            Expanded(
              flex: 6,
              child: recipe.imageUrl == null
                  ? Container(
                      width: double.infinity,
                      color: const Color(0xFFF0F0F0),
                      child: const Icon(
                        Icons.restaurant_menu,
                        size: 50,
                        color: Colors.grey,
                      ),
                    )
                  : Image.network(
                      recipe.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),

            /// INFO
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      recipe.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        const Icon(Icons.timer, size: 16),

                        const SizedBox(width: 4),

                        Expanded(
                          child: Text(
                            "${recipe.cookTime} min",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const Icon(Icons.people, size: 16),

                        const SizedBox(width: 4),

                        Text("${recipe.servings}"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Recipe?"),
        content: Text("\"${recipe.title}\" will be permanently deleted."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
