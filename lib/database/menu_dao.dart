import 'package:eventsbox/database/database_helper.dart';
import 'package:eventsbox/models/item_menu.dart';
import 'package:sqflite/sqflite.dart';

class MenuDao {
  final database = DatabaseHelper.instance.db;

  Future<List<ItemMenu>> readAll() async {
    final data = await database.query('menu');
    List<ItemMenu> items = data.map((e) => ItemMenu.fromDatabase(e)).toList();
    items.sort((a, b) => a.orden.compareTo(b.orden));
    return items;
  }

  Future<int> insert(ItemMenu item) async => await database.insert(
      'menu',
      {
        'id': item.id,
        'item_order': item.orden,
        'title': item.title,
        'icon': item.icon,
        'content': item.content,
        'social': item.social,
        'location': item.location
      },
      conflictAlgorithm: ConflictAlgorithm.replace);

  Future<void> update(ItemMenu item) async => await database
      .update('menu', item.toMap(), where: 'id = ?', whereArgs: [item.id]);

  Future<void> delete(ItemMenu item) async =>
      await database.delete('menu', where: 'id = ?', whereArgs: [item.id]);

  Future<void> deleteAll() async => await database.delete('menu');
}
