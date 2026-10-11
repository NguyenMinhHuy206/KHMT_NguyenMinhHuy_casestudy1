
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/transaction_model.dart';

class ExpenseDatabase {
  ExpenseDatabase._();

  static final ExpenseDatabase instance =
  ExpenseDatabase._();

  Database? _db;

  // Kết nối SQLite
  Future<Database> get database async {
    if (_db != null && _db!.isOpen) {
      return _db!;
    }

    _db = await _openDatabase();
    return _db!;
  }

  // Khởi tạo database
  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      'expense_manager.db',
    );

    return openDatabase(
      path,
      version: 3,

      // Tạo mới database
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            type TEXT NOT NULL,
            date TEXT NOT NULL,
            category TEXT NOT NULL DEFAULT 'Khác',
            note TEXT NOT NULL DEFAULT ''
          )
        ''');

        await _createSettings(db);
      },

      // Nâng cấp database cũ
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            ALTER TABLE transactions
            ADD COLUMN category
            TEXT NOT NULL DEFAULT 'Khác'
          ''');

          await db.execute('''
            ALTER TABLE transactions
            ADD COLUMN note
            TEXT NOT NULL DEFAULT ''
          ''');
        }

        if (oldVersion < 3) {
          await _createSettings(db);
        }
      },

      onOpen: (db) async {
        // Đảm bảo bảng cài đặt tồn tại
        await _createSettings(db);
      },
    );
  }

  // Tạo bảng lưu cài đặt
  Future<void> _createSettings(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS app_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  // =========================
  // CREATE - Thêm giao dịch
  // =========================

  Future<int> insertTransaction(
      TransactionModel transaction,
      ) async {
    final db = await database;

    return db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // =========================
  // READ - Lấy danh sách
  // =========================

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;

    final result = await db.query(
      'transactions',
      orderBy: 'date DESC, id DESC',
    );

    return result
        .map((item) => TransactionModel.fromMap(item))
        .toList();
  }

  // =========================
  // UPDATE - Sửa giao dịch
  // =========================

  Future<int> updateTransaction(
      TransactionModel transaction,
      ) async {
    if (transaction.id == null) {
      throw ArgumentError(
        'Không thể cập nhật giao dịch chưa có ID',
      );
    }

    final db = await database;

    return db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // =========================
  // DELETE - Xóa giao dịch
  // =========================

  Future<int> deleteTransaction(int id) async {
    final db = await database;

    return db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // =========================
  // SETTINGS - Đọc cài đặt
  // =========================

  Future<String?> getSetting(String key) async {
    final db = await database;

    final result = await db.query(
      'app_settings',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first['value'] as String?;
  }

  // =========================
  // SETTINGS - Lưu cài đặt
  // =========================

  Future<void> setSetting(
      String key,
      String value,
      ) async {
    final db = await database;

    await db.insert(
      'app_settings',
      {
        'key': key,
        'value': value,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // =========================
  // Đếm số lượng giao dịch
  // =========================

  Future<int> countTransactions() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM transactions',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // =========================
  // Đóng kết nối SQLite
  // =========================

  Future<void> close() async {
    final db = _db;

    if (db != null && db.isOpen) {
      await db.close();
    }

    _db = null;
  }
}
