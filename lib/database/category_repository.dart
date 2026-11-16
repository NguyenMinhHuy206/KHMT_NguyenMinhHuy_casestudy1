import 'dart:convert';

import 'expense_database.dart';

class CategoryRepository {
  CategoryRepository._();

  static final CategoryRepository instance = CategoryRepository._();

  static const List<String> defaultExpenses = [
    'Ăn uống',
    'Mua sắm',
    'Đi lại',
    'Học tập',
    'Giải trí',
    'Hóa đơn',
    'Khác',
  ];

  static const List<String> defaultIncomes = [
    'Lương',
    'Thưởng',
    'Kinh doanh',
    'Thu nhập khác',
    'Khác',
  ];

  String _key(String type) {
    if (type != 'income' && type != 'expense') {
      throw ArgumentError('Loại danh mục không hợp lệ');
    }
    return 'categories_$type';
  }

  Future<List<String>> getCategories(String type) async {
    final raw = await ExpenseDatabase.instance.getSetting(_key(type));

    if (raw == null) {
      return List<String>.from(
        type == 'income' ? defaultIncomes : defaultExpenses,
      );
    }

    final decoded = jsonDecode(raw);

    if (decoded is! List) {
      throw const FormatException('Dữ liệu danh mục không hợp lệ');
    }

    return decoded.cast<String>().toList();
  }

  Future<void> _save(String type, List<String> categories) async {
    await ExpenseDatabase.instance.setSetting(
      _key(type),
      jsonEncode(categories),
    );
  }

  Future<void> addCategory(String type, String name) async {
    final value = name.trim();

    if (value.isEmpty) {
      throw ArgumentError('Tên danh mục không được để trống');
    }

    final categories = await getCategories(type);

    if (categories.any((c) => c.toLowerCase() == value.toLowerCase())) {
      throw StateError('Danh mục đã tồn tại');
    }

    categories.add(value);
    await _save(type, categories);
  }

  Future<void> renameCategory(
    String type,
    String oldName,
    String newName,
  ) async {
    final value = newName.trim();

    if (value.isEmpty) {
      throw ArgumentError('Tên danh mục không được để trống');
    }

    if (oldName == 'Khác') {
      throw StateError('Không thể đổi tên danh mục Khác');
    }

    final categories = await getCategories(type);
    final index = categories.indexOf(oldName);

    if (index == -1) {
      throw StateError('Không tìm thấy danh mục');
    }

    if (oldName == value) return;

    if (categories.any((c) => c.toLowerCase() == value.toLowerCase())) {
      throw StateError('Tên danh mục đã tồn tại');
    }

    await _ensureUnused(type, oldName);

    categories[index] = value;
    await _save(type, categories);
  }

  Future<void> deleteCategory(String type, String name) async {
    if (name == 'Khác') {
      throw StateError('Không thể xóa danh mục Khác');
    }

    final categories = await getCategories(type);

    if (!categories.contains(name)) {
      throw StateError('Không tìm thấy danh mục');
    }

    await _ensureUnused(type, name);

    categories.remove(name);
    await _save(type, categories);
  }

  Future<void> _ensureUnused(String type, String name) async {
    final transactions = await ExpenseDatabase.instance.getTransactions();

    final used = transactions.any(
      (item) => item.type == type && item.category == name,
    );

    if (used) {
      throw StateError(
        'Danh mục đang được sử dụng bởi giao dịch. '
        'Không thể sửa hoặc xóa.',
      );
    }
  }
}
