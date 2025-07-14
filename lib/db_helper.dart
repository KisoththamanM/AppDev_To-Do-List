import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, date TEXT, isDone INTEGER)',
        );
      },
    );
  }

  Future<int> insertTask(String title, String date) async {
    final db = await database;
    return await db.insert('tasks', {
      'title': title,
      'date': date,
      'isDone': 0,
    });
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query('tasks');
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTask(int id, int isDone) async {
    final db = await database;
    return await db.update(
      'tasks',
      {'isDone': isDone},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
