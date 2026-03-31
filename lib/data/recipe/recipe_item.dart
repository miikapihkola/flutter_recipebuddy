import '../constants.dart';

//--------------
// Common
//--------------

class RecipeItem {
  int id = 0;
  String name = "";
  String description = "";
  String _mainCategory = categoryUnspecified;
  String _subCategory = categoryUnspecified;
  List<RecipeIngredientGroup> ingredientGroups = [];
  String _recipeType = categoryUnspecified;
  int _servings = 1;
  bool isPinned = false;
  double _rating = 0;
  bool isStarred = false;
  DateTime? timeStamp;

  RecipeItem({
    required this.id,
    required this.name,
    this.description = "",
    required String mainCategory,
    required String subCategory,
    this.ingredientGroups = const [],
    String recipeType = categoryUnspecified,
    int servings = 1,
    this.isPinned = false,
    double rating = 0,
    this.isStarred = false,
    this.timeStamp,
  }) {
    this.mainCategory = mainCategory;
    this.subCategory = subCategory;
    this.recipeType = recipeType;
    this.servings = servings;
    this.rating = rating;
  }

  double get rating => _rating;
  set rating(double value) {
    if (value > 100) {
      _rating = 100;
    } else if (value < -100) {
      _rating = -100;
    } else {
      _rating = double.parse(value.toStringAsFixed(1));
    }
  }

  String get mainCategory => _mainCategory;
  set mainCategory(String value) {
    if (value.isEmpty) {
      _mainCategory = categoryUnspecified;
    } else {
      _mainCategory = value;
    }
  }

  String get subCategory => _subCategory;
  set subCategory(String value) {
    if (value.isEmpty) {
      _subCategory = categoryUnspecified;
    } else {
      _subCategory = value;
    }
  }

  String get recipeType => _recipeType;
  set recipeType(String value) {
    if (value.isEmpty || !recipeTypes.contains(value)) {
      _recipeType = categoryUnspecified;
    } else {
      _recipeType = value;
    }
  }

  int get servings => _servings;
  set servings(int value) {
    if (value < 0) {
      _servings = 0;
    } else {
      _servings = value;
    }
  }
}

class RecipeIngredientGroup {
  int id = 0;
  int recipeId = 0;
  List<RecipeIngredient> recipeIngredients = [];
  bool optional = false;
  String groupName = "";

  RecipeIngredientGroup({
    required this.id,
    required this.recipeId,
    this.recipeIngredients = const [],
    this.optional = false,
    this.groupName = "",
  });
}

class RecipeIngredient {
  int id = 0;
  int recipeGroupId = 0;
  int ingredientId = 0;
  double _amount = 0;
  String _unit = "";

  RecipeIngredient({
    required this.id,
    required this.recipeGroupId,
    required this.ingredientId,
    double amount = 0,
    String unit = "",
  }) {
    this.amount = amount;
    this.unit = unit;
  }

  double get amount => _amount;
  set amount(double value) {
    if (value < 0) {
      _amount = 0;
    } else {
      _amount = value;
    }
  }

  String get unit => _unit;
  set unit(String value) {
    if (unitsList.contains(value)) {
      _unit = value;
    } else {
      _unit = unitsList[0];
    }
  }
}

//--------------
// Additional
//--------------

class CookStep {
  int id = 0;
  int recipeId = 0;
  int order = 0;
  int _durationMinutes = 0;
  String type = "";
  String description = "";

  CookStep({
    required this.id,
    required this.recipeId,
    required this.order,
    int durationMinutes = 0,
    this.type = "",
    this.description = "",
  }) {
    this.durationMinutes = durationMinutes;
  }

  int get durationMinutes => _durationMinutes;
  set durationMinutes(int value) {
    if (value < 0) {
      _durationMinutes = 0;
    } else {
      _durationMinutes = value;
    }
  }
}

//--------------
// Specific Recipes
//--------------

class FoodRecipe extends RecipeItem {
  int _prepTimeMinutes = 0;
  List<CookStep> cookSteps = [];
  bool requiresDeepBowl = false;

  FoodRecipe({
    required super.id,
    required super.name,
    super.description,
    required super.mainCategory,
    required super.subCategory,
    int prepTimeMinutes = 0,
    this.cookSteps = const [],
    this.requiresDeepBowl = false,
  }) : super(recipeType: "Food") {
    this.prepTimeMinutes = prepTimeMinutes;
  }

  int get prepTimeMinutes => _prepTimeMinutes;
  set prepTimeMinutes(int value) {
    if (value < 0) {
      _prepTimeMinutes = 0;
    } else {
      _prepTimeMinutes = value;
    }
  }
}

class CocktailRecipe extends RecipeItem {
  bool isAlcoholic = true;
  double _abv = 0;
  String glassType = "";
  String method = "";

  CocktailRecipe({
    required super.id,
    required super.name,
    super.description,
    required super.mainCategory,
    required super.subCategory,
    this.isAlcoholic = true,
    double abv = 0,
    this.glassType = "",
    this.method = "",
  }) : super(recipeType: "Cocktail") {
    this.abv = abv;
  }

  double get abv => _abv;
  set abv(double value) {
    if (value < 0) {
      _abv = 0;
    } else if (value > 100) {
      _abv = 100;
    } else {
      _abv = double.parse(value.toStringAsFixed(1));
    }
  }
}

class FermentRecipe extends RecipeItem {
  int _fermentTimeDays = 0;
  DateTime? fermentingStarted;
  bool notifyWhenReady = false;
  List<CookStep> cooksteps = [];
  DateTime? get fermentReadyDate =>
      fermentingStarted != null && fermentTimeDays > 0
      ? fermentingStarted!.add(Duration(days: _fermentTimeDays))
      : null;

  FermentRecipe({
    required super.id,
    required super.name,
    super.description,
    required super.mainCategory,
    required super.subCategory,
    int fermentTimeDays = 0,
    this.fermentingStarted,
    this.notifyWhenReady = false,
    this.cooksteps = const [],
  }) : super(recipeType: "Ferment") {
    this.fermentTimeDays = fermentTimeDays;
  }

  int get fermentTimeDays => _fermentTimeDays;
  set fermentTimeDays(int value) {
    if (value < 0) {
      _fermentTimeDays = 0;
    } else {
      _fermentTimeDays = value;
    }
  }
}
