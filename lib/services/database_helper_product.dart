import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:store_room2/models/product.dart';

class ProductDatabaseHelper {
  static Database? _database;
  static const String _tableName = 'products';
  static const int _version = 1;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'products.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, roomId TEXT, title TEXT, quantity INTEGER, price REAL, category TEXT, code TEXT, space TEXT, location TEXT, imageUrl TEXT)',
        );
      },
      version: _version,
    );
  }

  static Future<void> insertProduct(Product product) async {
    final Database db = await database;
    await db.insert(
      _tableName,
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Product>> getAllProducts() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        roomId: maps[i]['roomId'],
        title: maps[i]['title'],
        quantity: maps[i]['quantity'],
        price: maps[i]['price'],
        category: maps[i]['category'],
        code: maps[i]['code'],
        space: maps[i]['space'],
        location: maps[i]['location'],
        imageUrl: maps[i]['imageUrl'],
      );
    });
  }

  static Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      _tableName,
      product.toJson(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  static Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
