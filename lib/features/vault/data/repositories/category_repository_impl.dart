import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/category.dart' as entity;
import '../../domain/repositories/category_repository.dart';
import '../database/app_database.dart' as db;
import '../database/daos/category_dao.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDao _categoryDao;
  static const _uuid = Uuid();

  CategoryRepositoryImpl({required CategoryDao categoryDao})
      : _categoryDao = categoryDao;

  entity.Category _fromDb(db.Category row) {
    return entity.Category(
      id: row.id,
      name: row.name,
      iconName: row.iconName,
      colorValue: row.colorValue,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  @override
  Stream<List<entity.Category>> watchAllCategories() {
    return _categoryDao.watchAll().map(
          (rows) => rows.map(_fromDb).toList(),
        );
  }

  @override
  Future<entity.Category?> getCategoryById(String id) async {
    final row = await _categoryDao.getById(id);
    return row != null ? _fromDb(row) : null;
  }

  @override
  Future<entity.Category> createCategory(entity.Category category) async {
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();

    await _categoryDao.insertCategory(db.CategoriesCompanion.insert(
      id: id,
      name: category.name,
      iconName: Value(category.iconName),
      colorValue: category.colorValue,
      sortOrder: Value(category.sortOrder),
      createdAt: now,
      updatedAt: now,
    ));

    return category.copyWith(id: id, createdAt: now, updatedAt: now);
  }

  @override
  Future<void> updateCategory(entity.Category category) async {
    final now = DateTime.now().toUtc();
    await _categoryDao.updateCategory(db.CategoriesCompanion(
      id: Value(category.id),
      name: Value(category.name),
      iconName: Value(category.iconName),
      colorValue: Value(category.colorValue),
      sortOrder: Value(category.sortOrder),
      updatedAt: Value(now),
    ));
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _categoryDao.deleteCategory(id);
  }

  @override
  Future<void> reorderCategories(List<String> orderedIds) async {
    await _categoryDao.reorder(orderedIds);
  }
}
