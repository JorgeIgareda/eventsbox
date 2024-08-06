import 'package:eventsbox/database/database_helper.dart';
import 'package:eventsbox/models/categoria_patrocinador.dart';
import 'package:sqflite/sqflite.dart';

class CategorieSponsorDao {
  final database = DatabaseHelper.instance.db;

  Future<List<CategoriaPatrocinador>> readAll() async {
    final data = await database.query('categories_sponsors');
    return data.map((e) => CategoriaPatrocinador.fromJson(e)).toList();
  }

  Future<int> insert(CategoriaPatrocinador categoria) async =>
      await database.insert(
          'categories_sponsors',
          {
            'id': categoria.id,
            'name': categoria.name,
            'color': categoria.color,
            'columns': categoria.columns
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

  Future<void> update(CategoriaPatrocinador categoria) async =>
      await database.update('categories_sponsors', categoria.toMap(),
          where: 'id = ?', whereArgs: [categoria.id]);

  Future<void> delete(CategoriaPatrocinador categoria) async =>
      await database.delete('categories_sponsors',
          where: 'id = ?', whereArgs: [categoria.id]);

  Future<void> deleteAll() async =>
      await database.delete('categories_sponsors');
}
