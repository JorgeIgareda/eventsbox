import 'package:eventsbox/database/database_helper.dart';
import 'package:eventsbox/models/home_module.dart';
import 'package:sqflite/sqflite.dart';

class HomeModuleDao {
  final database = DatabaseHelper.instance.db;

  Future<List<HomeModule>> readAll() async {
    final data = await database.query('home_modules');
    List<HomeModule> modules =
        data.map((e) => HomeModule.fromDatabase(e)).toList();
    modules.sort((a, b) => a.order.compareTo(b.order));
    return modules;
  }

  Future<int> insert(HomeModule modulo) async => await database.insert(
      'home_modules',
      {
        'id_module': modulo.id,
        'item_order': modulo.order,
        'module': modulo.module,
        'app_visible': modulo.appVisible,
        'hidden_title': modulo.hiddenTitle,
        'title': modulo.title
      },
      conflictAlgorithm: ConflictAlgorithm.replace);

  Future<void> update(HomeModule modulo) async =>
      await database.update('home_modules', modulo.toMap(),
          where: 'id_module = ?', whereArgs: [modulo.id]);

  Future<void> delete(HomeModule modulo) async => await database
      .delete('home_modules', where: 'id_module = ?', whereArgs: [modulo.id]);

  Future<void> deleteAll() async => await database.delete('home_modules');
}
