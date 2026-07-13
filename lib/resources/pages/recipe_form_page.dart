import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'dart:io';
import '../../app/controllers/recipe_form_controller.dart';

class RecipeFormPage extends NyStatefulWidget<RecipeFormController> {
  static RouteView path = ("/recipe-form", (_) => RecipeFormPage());

  RecipeFormPage() : super(child: () => _RecipeFormPageState());
}

class _RecipeFormPageState extends NyPage<RecipeFormPage> {
  Future<void> _submitAndClose() async {
    print("STEP 1");

    final result = await widget.controller.submit();

    print("STEP 2: $result");

    if (!mounted || result == null) return;

    print("STEP 3");
    print("POP START");

    Navigator.pop(context, result);

    print("POP END");
    print("STEP 4");
  }

  Future<void> _deleteRecipe() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Recipe"),

        content: const Text("Are you sure you want to delete this recipe?"),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel"),
          ),

          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    await widget.controller.deleteRecipe();

    if (mounted) {
      Navigator.pop(context, "deleted");
    }
  }

  Widget _buildImagePreview(RecipeFormController ctrl) {
    // User baru memilih gambar
    if (ctrl.selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(ctrl.selectedImage!.path),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    // Edit recipe yang sudah punya gambar
    if (ctrl.existingRecipe?.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          ctrl.existingRecipe!.imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    // Belum ada gambar
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_outlined, size: 55, color: Colors.grey),
        SizedBox(height: 12),
        Text("Tap to select image", style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  @override
  Widget view(BuildContext context) {
    final ctrl = widget.controller;

    final isEdit = ctrl.isEditMode;

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        centerTitle: true,

        title: Text(isEdit ? "Edit Recipe" : "New Recipe"),

        actions: [
          if (isEdit)
            IconButton(
              onPressed: _deleteRecipe,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),

          TextButton(
            onPressed: _submitAndClose,
            child: Text(
              isEdit ? "Update" : "Save",
              style: const TextStyle(
                color: Color(0xff5C6BC0),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            GestureDetector(
              onTap: () async {
                await widget.controller.pickImage();

                if (mounted) {
                  setState(() {});
                }
              },

              child: Container(
                height: 180,
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade400),
                ),

                child: _buildImagePreview(ctrl),
              ),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: ctrl.titleController,
              style: const TextStyle(color: Colors.black),

              decoration: const InputDecoration(
                labelStyle: const TextStyle(color: Colors.black87),
                labelText: "Recipe Name",

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: ctrl.categoryController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelStyle: const TextStyle(color: Colors.black87),
                labelText: "Category",

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ctrl.cookTimeController,
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,

                    decoration: const InputDecoration(
                      labelStyle: const TextStyle(color: Colors.black87),
                      labelText: "Cook Time",

                      suffixText: "min",

                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: TextField(
                    controller: ctrl.servingsController,
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,

                    decoration: const InputDecoration(
                      labelStyle: const TextStyle(color: Colors.black87),
                      labelText: "Servings",

                      suffixText: "people",

                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              controller: ctrl.ingredientsController,

              maxLines: 6,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelStyle: const TextStyle(color: Colors.black87),
                alignLabelWithHint: true,

                labelText: "Ingredients",

                hintText: "Example:\n• 2 Eggs\n• 1 Cup Flour\n• 200 ml Milk",

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: ctrl.stepsController,

              maxLines: 8,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelStyle: const TextStyle(color: Colors.black87),
                alignLabelWithHint: true,

                labelText: "Cooking Steps",

                hintText:
                    "Example:\n1. Heat the pan.\n2. Add oil.\n3. Fry the eggs.",

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              height: 55,

              child: ElevatedButton(
                onPressed: _submitAndClose,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff5C6BC0),

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                child: Text(
                  isEdit ? "Update Recipe" : "Save Recipe",

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,

                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
