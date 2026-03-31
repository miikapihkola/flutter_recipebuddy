import '../constants.dart';

class IngredientItem {
  int id = 0;
  String name = "";
  String description = "";
  String _mainCategory = categoryUnspecified;
  String _subCategory = categoryUnspecified;
  DateTime? expire;
  int _status = 3; // [0, 1, 2] = [R, Y, G] , 3 = unknown
  bool inShoppinglist = false;
  bool isStarred = false;
  double _amountToBuy = 0;
  String _buyUnit = "";
  double _currentAmount = 0;
  String _unit = "";

  IngredientItem({
    required this.id,
    required this.name,
    this.description = "",
    required String mainCategory,
    required String subCategory,
    this.expire,
    int status = 3,
    this.inShoppinglist = false,
    this.isStarred = false,
    double amountToBuy = 0,
    String buyUnit = "",
    double currentAmount = 0,
    String unit = "",
  }) {
    this.status = status;
    this.amountToBuy = amountToBuy;
    this.currentAmount = currentAmount;
    this.mainCategory = mainCategory;
    this.subCategory = subCategory;
    this.buyUnit = buyUnit;
    this.unit = unit;
  }

  String get unit => _unit;
  set unit(String value) {
    if (unitsList.contains(value)) {
      _unit = value;
    } else {
      _unit = unitsList[0];
    }
  }

  String get buyUnit => _buyUnit;
  set buyUnit(String value) {
    if (unitsList.contains(value)) {
      _buyUnit = value;
    } else {
      _buyUnit = unitsList[0];
    }
  }

  int get status => _status;
  set status(int value) {
    if (value >= 0 && value <= 2) {
      _status = value;
    } else {
      _status = 3;
    }
  }

  double get amountToBuy => _amountToBuy;
  set amountToBuy(double value) {
    if (value >= 0) {
      _amountToBuy = value;
    } else {
      _amountToBuy = 0;
    }
  }

  double get currentAmount => _currentAmount;
  set currentAmount(double value) {
    if (value >= 0) {
      _currentAmount = value;
    } else {
      _currentAmount = 0;
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
}
