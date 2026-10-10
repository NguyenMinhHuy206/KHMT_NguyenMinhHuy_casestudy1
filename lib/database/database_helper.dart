
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/student.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
  DatabaseHelper._init();

  DatabaseHelper._init();

  static Database? _database;

  // Mở database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  // Tạo database SQLite
  Future<Database> _initDB() async {
    String path = join(
      await getDatabasesPath(),
      'student.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE students (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            student_code TEXT NOT NULL,
            major TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Thêm sinh viên
  Future<int> insertStudent(Student student) async {
    final db = await database;
    return await db.insert(
      'students',
      student.toMap(),
    );
  }

  // Lấy danh sách sinh viên
  Future<List<Student>> getStudents() async {
    final db = await database;
    final result = await db.query('students');

    return result
        .map((e) => Student.fromMap(e))
        .toList();
  }

  // Cập nhật sinh viên
  Future<int> updateStudent(Student student) async {
    final db = await database;

    return await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  // Xóa sinh viên
  Future<int> deleteStudent(int id) async {
    final db = await database;

    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
