import '../entities/category.dart' as entity;

abstract class CategoryRepository {
  Stream<List<entity.Category>> watchAllCategories();
  Future<entity.Category?> getCategoryById(String id);
  Future<entity.Category> createCategory(entity.Category category);
  Future<void> updateCategory(entity.Category category);
  Future<void> deleteCategory(String id);
  Future<void> reorderCategories(List<String> orderedIds);
}
