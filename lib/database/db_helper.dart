//*->Tao_lớp_trừu_tượng_database
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite_app/models/model.dart';

abstract class DBHelper {
  static Database? _db;

  static int get _version => 1;

  //*->Lớp
  static Future<void> init() async {
    if (_db != null) {
      return;
    }
    try {
      var databsePath = await getDatabasesPath();
      String _path = p.join(databsePath, 'sqlite_app.db');
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: onCreate,
        onUpgrade: onUpgrade,
      );
    } catch (ex) {
      //*->Xử_lý_ngoại_lệ
      print(ex);
    }
  }

  //*->Khởi_tạo_db
  static void onCreate(Database db, int version) async {
    String sqlQuery =
        'CREATE TABLE products (id INTEGER PRIMARY KEY AUTOINCREMENT, productName STRING, categoryId INTEGER, productDesc STRING, price REAL, productPic STRING)';
    await db.execute(sqlQuery);
  }

  //*->Cập_nhật
  static void onUpgrade(Database db, int oldVersion, int version) async {
    if (oldVersion > version) {
      //
    }
  }

  //*->truy_van
  static Future<List<Map<String, dynamic>>> query(String table) async {
    return _db!.query(table);
  }

  //*->
  static Future<int> insert(String table, Model model) async {
    return await _db!.insert(table, model.toJson());
  }

  //*->
  static Future<int> update(String table, Model model) async {
    return await _db!.update(
      table,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  //*->delete
  static Future<int> delete(String table, Model model) async {
    return await _db!.delete(
      table,
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }
}
