import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/models/recipe.dart';
import '/app/networking/recipe_api_service.dart';
import 'package:image_picker/image_picker.dart';
import '/app/networking/storage_service.dart';
import 'dart:io';

class RecipeFormController extends NyController {
  final ImagePicker _picker = ImagePicker();

  XFile? selectedImage;
  // Form Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController cookTimeController = TextEditingController();
  final TextEditingController servingsController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();

  Recipe? existingRecipe;

  @override
  Future<void> construct(BuildContext context) async {
    super.construct(context);

    final passed = data() ?? ModalRoute.of(context)?.settings.arguments;

    if (passed is Recipe) {
      existingRecipe = passed;

      titleController.text = passed.title;
      categoryController.text = passed.category;
      cookTimeController.text = passed.cookTime.toString();
      servingsController.text = passed.servings.toString();
      ingredientsController.text = passed.ingredients;
      stepsController.text = passed.steps;
    }
  }

  bool get isEditMode => existingRecipe != null;

  Future<String?> submit() async {
    if (titleController.text.trim().isEmpty ||
        categoryController.text.trim().isEmpty ||
        cookTimeController.text.trim().isEmpty ||
        servingsController.text.trim().isEmpty ||
        ingredientsController.text.trim().isEmpty ||
        stepsController.text.trim().isEmpty) {
      return null;
    }

    try {
      if (isEditMode) {
        await _update();
        return "updated";
      } else {
        await _create();
        return "created";
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    selectedImage = image;
  }

  Future<void> _create() async {
    String? imageUrl;

    if (selectedImage != null) {
      imageUrl = await StorageService().uploadImage(File(selectedImage!.path));
    }

    final recipe = Recipe(
      title: titleController.text.trim(),
      category: categoryController.text.trim(),
      cookTime: int.parse(cookTimeController.text),
      servings: int.parse(servingsController.text),
      ingredients: ingredientsController.text.trim(),
      steps: stepsController.text.trim(),
      imageUrl: imageUrl,
    );

    await api<RecipeApiService>((service) => service.create(recipe));
  }

  Future<void> _update() async {
    String? imageUrl = existingRecipe?.imageUrl;

    if (selectedImage != null) {
      imageUrl = await StorageService().uploadImage(File(selectedImage!.path));
    }

    final recipe = Recipe(
      id: existingRecipe!.id,
      title: titleController.text.trim(),
      category: categoryController.text.trim(),
      cookTime: int.parse(cookTimeController.text),
      servings: int.parse(servingsController.text),
      ingredients: ingredientsController.text.trim(),
      steps: stepsController.text.trim(),
      imageUrl: imageUrl,
    );

    await api<RecipeApiService>((service) => service.update(recipe));
  }

  Future<void> deleteRecipe() async {
    if (existingRecipe?.id == null) return;

    await api<RecipeApiService>(
      (service) => service.destroy(existingRecipe!.id!),
    );
  }
}
