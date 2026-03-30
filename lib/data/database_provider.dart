import 'package:flutter_recipebuddy/data/ingredient/ingredient_db_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static const String _dbname = "recipebuddydb.db";
  static const int _dbVersion = 1;

  static final DatabaseProvider instance = DatabaseProvider._init();
  static Database? _database;

  DatabaseProvider._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_dbname);
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await IngredientDbHelper.createTable(db);
    // await RecipeDbHelper.createTable(db); // add future tables
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete(IngredientDbHelper.tableName);
    // await db.delete(RecipeDbHelper.tableName); // add future tables
  }

  Future<void> debugDeleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbname);
    _database = null;
    await databaseFactory.deleteDatabase(path);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Add migration steps here as the schema evolves
    /* if (oldVersion < 2) {
    await db.execute("ALTER TABLE ingredients ADD COLUMN newField TEXT");
    }
    if (oldVersion < 3) {...} */
  }
}
