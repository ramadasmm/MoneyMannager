import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_app/model/category/category_model.dart';

const CATEGORY_DB_NAME = 'category-database';

abstract class CategoryDbFunction {
  Future<List<CatergoryModel>> getCategories();
  Future<void> insertCategory(CatergoryModel value);
  Future<void> deleteCategory(String categoryID);
}

class CategoryDB implements CategoryDbFunction {
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();

  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CatergoryModel>> incomeCategoryList = ValueNotifier([]);
  ValueNotifier<List<CatergoryModel>> expenseCategoryList = ValueNotifier([]);

  @override
  Future<void> insertCategory(CatergoryModel value) async {
    final _categoryDB = await Hive.openBox<CatergoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CatergoryModel>> getCategories() async {
    final _categoryDB = await Hive.openBox<CatergoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final _allCategories = await getCategories();
    incomeCategoryList.value.clear();
    expenseCategoryList.value.clear();
    await Future.forEach(
      _allCategories,
      (CatergoryModel catergory) {
        if (catergory.type == CategoryType.income) {
          incomeCategoryList.value.add(catergory);
        } else {
          expenseCategoryList.value.add(catergory);
        }
      },
    );
    incomeCategoryList.notifyListeners();
    expenseCategoryList.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final _categoryDB = await Hive.openBox<CatergoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.delete(categoryID);
    refreshUI();
  }
}
