import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:store_room/models/product.dart';

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
          'CREATE TABLE $_tableName(id TEXT PRIMARY KEY, roomId TEXT, title TEXT, quantity INTEGER, buyingPrice REAL, sellingPrice REAL, category TEXT, code TEXT, location TEXT, imageUrl TEXT)',
        );
      },
      version: _version,
    );
  }

  static Future<void> insertProduct(Product product) async {
    final Database db = await database;

    // Insert product
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
        title: maps[i]['title'],
        quantity: maps[i]['quantity'],
        buyingPrice: maps[i]['buyingPrice'],
        sellingPrice: maps[i]['sellingPrice'],
        category: maps[i]['category'],
        code: maps[i]['code'],
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

  static Future<List<Product>> getProductsByIds(List<String> productIds) async {
    final Database db = await database;
    List<Product> products = [];

    for (final productId in productIds) {
      final List<Map<String, dynamic>> productMaps = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [productId],
      );
      if (productMaps.isNotEmpty) {
        final productJson = productMaps.first;
        final product = Product(
          id: productJson['id'],
          title: productJson['title'],
          quantity: productJson['quantity'],
          buyingPrice: productJson['buyingPrice'],
          sellingPrice: productJson['sellingPrice'],
          category: productJson['category'],
          code: productJson['code'],
          location: productJson['location'],
          imageUrl: productJson['imageUrl'],
        );
        products.add(product);
      }
    }
    return products;
  }

  static Future<List<Product>> getProductsByCode(String code) async {
    final Database db = await database;
    List<Product> products = [];

    final List<Map<String, dynamic>> productMaps = await db.query(
      'products',
      where: 'code = ?',
      whereArgs: [code],
    );

    for (final productJson in productMaps) {
      final product = Product(
        id: productJson['id'],
        title: productJson['title'],
        quantity: productJson['quantity'],
        buyingPrice: productJson['buyingPrice'],
        sellingPrice: productJson['sellingPrice'],
        category: productJson['category'],
        code: productJson['code'],
        location: productJson['location'],
        imageUrl: productJson['imageUrl'],
      );
      products.add(product);
    }

    return products;
  }
}
