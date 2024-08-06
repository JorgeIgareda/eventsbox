import 'package:eventsbox/database/database_helper.dart';
import 'package:eventsbox/database/image_dao.dart';
import 'package:eventsbox/models/galeria_imagenes.dart';
import 'package:eventsbox/models/imagen.dart';
import 'package:sqflite/sqflite.dart';

class ImageGalleryDao {
  final database = DatabaseHelper.instance.db;

  Future<List<GaleriaImagenes>> readAll() async {
    final data = await database.query('images_galleries');
    List<GaleriaImagenes> galerias = <GaleriaImagenes>[];
    for (Map<String, dynamic> map in data) {
      List<Imagen> photos = await ImageDao().readAllFromGallery(map['id']);
      galerias.add(GaleriaImagenes.fromDatabase(map, photos));
    }
    galerias.sort((a, b) => a.orden.compareTo(b.orden));
    return galerias;
  }

  Future<int> insert(GaleriaImagenes galeria) async {
    for (Imagen imagen in galeria.galleryPhotos) {
      await ImageDao().insert(imagen);
    }
    return await database.insert(
        'images_galleries',
        {
          'id': galeria.id,
          'item_order': galeria.orden,
          'name': galeria.name,
          'image': galeria.image,
          'thumb': galeria.thumb,
          'date': galeria.date,
          'upload_admin': galeria.uploadAdmin,
          'num_photos': galeria.numPhotos
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> update(GaleriaImagenes galeria) async {
    for (Imagen imagen in galeria.galleryPhotos) {
      await ImageDao().insert(imagen);
    }
    await database.update('images_galleries', galeria.toMap(),
        where: 'id = ?', whereArgs: [galeria.id]);
  }

  Future<void> delete(GaleriaImagenes galeria) async => await database
      .delete('images_galleries', where: 'id = ?', whereArgs: [galeria.id]);

  Future<void> deleteAll() async => await database.delete('images_galleries');
}
