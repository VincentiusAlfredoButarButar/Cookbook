import '/resources/pages/not_found_page.dart';
import '/resources/pages/home_page.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../resources/pages/recipe_form_page.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Terminal: "metro make:page profile_page"

| Learn more https://nylo.dev/docs/7.x/router
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
  router.add(HomePage.path).initialRoute();

  router.add(RecipeFormPage.path);

  router.add(NotFoundPage.path).unknownRoute();
});
