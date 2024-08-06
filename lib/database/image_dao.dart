import 'package:eventsbox/database/database_helper.dart';
import 'package:eventsbox/models/imagen.dart';
import 'package:sqflite/sqflite.dart';

class ImageDao {
  final database = DatabaseHelper.instance.db;

  Future<List<Imagen>> readAll() async {
    final data = await database.query('images');
    List<Imagen> imagenes = data.map((e) => Imagen.fromDatabase(e)).toList();
    imagenes.sort((a, b) => a.orden.compareTo(b.orden));
    return imagenes;
  }

  /// Lee todas las imagenes de la galería con el ID pasado como parámetro
  Future<List<Imagen>> readAllFromGallery(int id) async {
    final data = await database
        .query('images', where: 'gallery_id = ?', whereArgs: [id]);
    List<Imagen> imagenes = data.map((e) => Imagen.fromDatabase(e)).toList();
    imagenes.sort((a, b) => a.orden.compareTo(b.orden));
    return imagenes;
  }

  Future<int> insert(Imagen image) async => await database.insert(
      'images',
      {
        'id': image.id,
        'item_order': image.orden,
        'user': image.user,
        'image': image.image,
        'thumb': image.thumb,
        'description': image.description,
        'likes': image.likes,
        'my_like': image.myLike,
        'gallery_id': image.galleryId
      },
      conflictAlgorithm: ConflictAlgorithm.replace);

  Future<void> update(Imagen image) async => await database
      .update('images', image.toMap(), where: 'id = ?', whereArgs: [image.id]);

  Future<void> delete(Imagen image) async =>
      await database.delete('images', where: 'id = ?', whereArgs: [image.id]);

  Future<void> deleteAll() async => await database.delete('images');
}
