import 'package:eventsbox/database/database_helper.dart';
import 'package:eventsbox/models/patrocinador.dart';
import 'package:sqflite/sqflite.dart';

class SponsorDao {
  final database = DatabaseHelper.instance.db;

  Future<List<Patrocinador>> readAll() async {
    final data = await database.query('sponsors');
    List<Patrocinador> sponsors =
        data.map((e) => Patrocinador.fromJson(e)).toList();
    sponsors.sort((a, b) => a.name.compareTo(b.name));
    return sponsors;
  }

  Future<int> insert(Patrocinador patrocinador) async => await database.insert(
      'sponsors',
      {
        'id': patrocinador.id,
        'name': patrocinador.name,
        'web': patrocinador.web,
        'mail': patrocinador.mail,
        'phone': patrocinador.phone,
        'linkedin': patrocinador.linkedin,
        'twitter': patrocinador.twitter,
        'facebook': patrocinador.facebook,
        'instagram': patrocinador.instagram,
        'youtube': patrocinador.youtube,
        'category': patrocinador.category,
        'exhibitor': patrocinador.exhibitor,
        'logo': patrocinador.logo,
        'banner': patrocinador.banner
      },
      conflictAlgorithm: ConflictAlgorithm.replace);

  Future<void> update(Patrocinador patrocinador) async =>
      await database.update('sponsors', patrocinador.toMap(),
          where: 'id = ?', whereArgs: [patrocinador.id]);

  Future<void> delete(Patrocinador patrocinador) async => await database
      .delete('sponsors', where: 'id = ?', whereArgs: [patrocinador.id]);

  Future<void> deleteAll() async => await database.delete('sponsors');
}
