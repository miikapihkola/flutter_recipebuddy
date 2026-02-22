import 'ingredient_list_manager.dart';
import 'constants.dart';

class CategoryListBuilder {
  static List<String> buildFilterCategoryList(
    IngredientListManager listManager,
  ) {
    final unique = listManager.items
        .map((i) => i.mainCategory)
        .where((c) => c != categoryUnspecified)
        .toSet()
        .toList();
    return [categoryAll, ...unique, categoryUnspecified];
  }

  static List<String> buildFilterSubcategoryList(
    IngredientListManager listManager,
    String selectedCategory,
  ) {
    if (selectedCategory == categoryAll ||
        selectedCategory == categoryUnspecified) {
      final unique = listManager.items
          .map((i) => i.subCategory)
          .where((c) => c != categoryUnspecified)
          .toSet()
          .toList();
      return [categoryAll, ...unique, categoryUnspecified];
    } else {
      final unique = listManager.items
          .where((i) => i.mainCategory == selectedCategory)
          .map((i) => i.subCategory)
          .where((c) => c != categoryUnspecified)
          .toSet()
          .toList();
      return [categoryAll, ...unique, categoryUnspecified];
    }
  }

  static List<String> buildInputCategoryList(
    IngredientListManager listManager,
  ) {
    final unique = listManager.items
        .map((i) => i.mainCategory)
        .where((c) => c != categoryUnspecified)
        .toSet()
        .toList();
    return [categoryUnspecified, ...unique];
  }

  static List<String> buildInputSubcategoryList(
    IngredientListManager listManager,
    String selectedCategory,
  ) {
    if (selectedCategory == categoryUnspecified) {
      return [categoryUnspecified];
    }
    final unique = listManager.items
        .where((i) => i.mainCategory == selectedCategory)
        .map((i) => i.subCategory)
        .where((c) => c != categoryUnspecified)
        .toSet()
        .toList();
    return [categoryUnspecified, ...unique];
  }
}
