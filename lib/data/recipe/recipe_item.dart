class RecipeItem {
  int id = 0;
  String name = "";
  String description = "";
  String _mainCategory = "";
  String _subCategory = "";

  RecipeItem({
    required this.id,
    required this.name,
    this.description = "",
    required String mainCategory,
    required String subCategory,
  });

  String get mainCategory => _mainCategory;
  set mainCategory(String value) {
    if (value.isEmpty) {
      // later add check if it is not existing category
      _mainCategory = "Unspecified";
    } else {
      _mainCategory = value;
    }
  }

  String get subCategory => _subCategory;
  set subCategory(String value) {
    if (value.isEmpty) {
      // later add check if it is not existing category
      _subCategory = "Unspecified";
    } else {
      _subCategory = value;
    }
  }
}
