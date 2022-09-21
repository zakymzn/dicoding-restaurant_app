import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tableFavorite = 'favorite';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/favorite_restaurant.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tableFavorite (
          id TEXT PRIMARY KEY,
          name TEXT,
          description TEXT,
          city TEXT,
          address TEXT,
          pictureId TEXT,
          categories TEXT,
          menus TEXT,
          rating NUMERIC,
          customerReviews TEXT
        )''');
      },
      version: 1,
    );
    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> addFavorite(RestaurantDetail restaurantDetail) async {
    final db = await database;
    await db!.insert(_tableFavorite, restaurantDetail.toJson());
  }

  Future<List<RestaurantDetail>> getFavorite() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tableFavorite);

    return results.map((e) => RestaurantDetail.fromJson(e)).toList();
  }

  Future<Map> getFavoriteById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tableFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.map((e) => e).toList().first;
    } else {
      return {};
    }
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;

    await db!.delete(
      _tableFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
