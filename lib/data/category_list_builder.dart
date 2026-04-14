import 'ingredient/ingredient_list_manager.dart';
import 'constants.dart';
import 'recipe/recipe_list_manager.dart';

class CategoryListBuilder {
  // ---- Internal shared logic ----
  static List<String> _buildFilterCategory(List<String> categories) {
    final unique = categories
        .where((c) => c != categoryUnspecified)
        .toSet()
        .toList();
    return [categoryAll, ...unique, categoryUnspecified];
  }

  static List<String> _buildFilterSubcategory(List<String> subCategories) {
    final unique = subCategories
        .where((c) => c != categoryUnspecified)
        .toSet()
        .toList();
    return [categoryAll, ...unique, categoryUnspecified];
  }

  static List<String> _buildInputCategory(List<String> categories) {
    final unique = categories
        .where((c) => c != categoryUnspecified)
        .toSet()
        .toList();
    return [categoryUnspecified, ...unique];
  }

  static List<String> _buildInputSubcategory(
    List<String> subCategories,
    String selectedCategory,
  ) {
    if (selectedCategory == categoryUnspecified) return [categoryUnspecified];
    final unique = subCategories
        .where((c) => c != categoryUnspecified)
        .toSet()
        .toList();
    return [categoryUnspecified, ...unique];
  }

  // ---- Ingredient ----
  static List<String> buildFilterCategoryListIngredient(
    IngredientListManager listManager,
  ) => _buildFilterCategory(
    listManager.items.map((i) => i.mainCategory).toList(),
  );

  static List<String> buildFilterSubcategoryListIngredient(
    IngredientListManager listManager,
    String selectedCategory,
  ) => _buildFilterSubcategory(
    selectedCategory == categoryAll || selectedCategory == categoryUnspecified
        ? listManager.items.map((i) => i.subCategory).toList()
        : listManager.items
              .where((i) => i.mainCategory == selectedCategory)
              .map((i) => i.subCategory)
              .toList(),
  );

  static List<String> buildInputCategoryListIngredient(
    IngredientListManager listManager,
  ) => _buildInputCategory(
    listManager.items.map((i) => i.mainCategory).toList(),
  );

  static List<String> buildInputSubcategoryListIngredient(
    IngredientListManager listManager,
    String selectedCategory,
  ) => _buildInputSubcategory(
    listManager.items
        .where((i) => i.mainCategory == selectedCategory)
        .map((i) => i.subCategory)
        .toList(),
    selectedCategory,
  );

  // ---- Recipe ----
  static List<String> buildFilterCategoryListRecipe(
    RecipeListManager listManager,
  ) => _buildFilterCategory(
    listManager.items.map((i) => i.mainCategory).toList(),
  );

  static List<String> buildFilterSubcategoryListRecipe(
    RecipeListManager listManager,
    String selectedCategory,
  ) => _buildFilterSubcategory(
    selectedCategory == categoryAll || selectedCategory == categoryUnspecified
        ? listManager.items.map((i) => i.subCategory).toList()
        : listManager.items
              .where((i) => i.mainCategory == selectedCategory)
              .map((i) => i.subCategory)
              .toList(),
  );

  static List<String> buildInputCategoryListRecipe(
    RecipeListManager listManager,
  ) => _buildInputCategory(
    listManager.items.map((i) => i.mainCategory).toList(),
  );

  static List<String> buildInputSubcategoryListRecipe(
    RecipeListManager listManager,
    String selectedCategory,
  ) => _buildInputSubcategory(
    listManager.items
        .where((i) => i.mainCategory == selectedCategory)
        .map((i) => i.subCategory)
        .toList(),
    selectedCategory,
  );
}
