
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/transaction_model.dart';

class ExpenseDatabase {
  ExpenseDatabase._();

  static final ExpenseDatabase instance =
  ExpenseDatabase._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();

    final path = join(
      dbPath,
      'expense_manager.db',
    );

    return openDatabase(
      path,
      version: 2,

      // Tạo database mới
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
      },

      // Nâng cấp database cũ
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE transactions "
                "ADD COLUMN category TEXT NOT NULL "
                "DEFAULT 'Khác'",
          );

          await db.execute(
            "ALTER TABLE transactions "
                "ADD COLUMN note TEXT NOT NULL "
                "DEFAULT ''",
          );
        }
      },
    );
  }

  // Thêm giao dịch
  Future<int> insertTransaction(
      TransactionModel transaction,
      ) async {
    final db = await database;

    return db.insert(
      'transactions',
      transaction.toMap(),
    );
  }

  // Lấy danh sách giao dịch
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

  // Sửa giao dịch
  Future<int> updateTransaction(
      TransactionModel transaction,
      ) async {
    final db = await database;

    return db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // Xóa giao dịch
  Future<int> deleteTransaction(int id) async {
    final db = await database;

    return db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
