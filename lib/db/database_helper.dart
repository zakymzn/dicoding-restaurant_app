// import 'package:dicoding_restaurant_app/api/restaurant_api.dart';
import 'package:dicoding_restaurant_app/data/restaurant_detail.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tableRestaurant = 'restaurant';
  final String _columnId = 'id';
  final String _columnName = 'name';
  final String _columnDescription = 'description';
  final String _columnCity = 'city';
  final String _columnAddress = 'address';
  final String _columnPictureId = 'pictureId';
  final String _columnCategories = 'categories';
  final String _columnFoodMenus = 'food_menus';
  final String _columnDrinkMenus = 'drink_menus';
  final String _columnRating = 'rating';
  final String _columnCustomerReviews = 'customerReviews';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/favorite_restaurant.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tableRestaurant (
          $_columnId TEXT PRIMARY KEY,
          $_columnName TEXT,
          $_columnDescription TEXT,
          $_columnCity TEXT,
          $_columnAddress TEXT,
          $_columnPictureId TEXT,
          $_columnCategories TEXT,
          $_columnFoodMenus TEXT,
          $_columnDrinkMenus TEXT,
          $_columnRating NUMERIC,
          $_columnCustomerReviews TEXT
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

  Future<void> addFavorite(Restaurant restaurantDetail) async {
    final db = await database;
    await db!.rawInsert('''INSERT INTO $_tableRestaurant(
          $_columnId,
          $_columnName,
          $_columnDescription,
          $_columnCity,
          $_columnAddress,
          $_columnPictureId,
          $_columnCategories,
          $_columnFoodMenus,
          $_columnDrinkMenus,
          $_columnRating,
          $_columnCustomerReviews
          ) VALUES(
            ${restaurantDetail.id!},
            ${restaurantDetail.name!},
            ${restaurantDetail.description!},
            ${restaurantDetail.city!},
            ${restaurantDetail.address!},
            ${restaurantDetail.pictureId!},
            ${restaurantDetail.categories!.map((e) => e.name).toList()},
            ${restaurantDetail.menus!.foods.map((e) => e.name).toList()},
            ${restaurantDetail.menus!.drinks.map((e) => e.name).toList()},
            ${restaurantDetail.rating!},
            ${restaurantDetail.customerReviews!}
            )''');
  }

  Future<List<Restaurant>> getFavorite() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tableRestaurant);

    return results.map((e) => Restaurant.fromJson(e)).toList();
  }

  Future<Map> getFavoriteById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tableRestaurant,
      where: '$_columnId = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;

    await db!.delete(
      _tableRestaurant,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }
}
