import 'package:eventsbox/database/database_helper.dart';
import 'package:eventsbox/models/ponente.dart';
import 'package:sqflite/sqflite.dart';

class SpeakerDao {
  final database = DatabaseHelper.instance.db;

  Future<List<Ponente>> readAll() async {
    final data = await database.query('speakers');
    List<Ponente> speakers = data.map((e) => Ponente.fromJson(e)).toList();
    speakers.sort(((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())));
    return speakers;
  }

  Future<int> insert(Ponente ponente) async => await database.insert(
      'speakers',
      {
        'id': ponente.id,
        'name': ponente.name,
        'last_name': ponente.lastName,
        'image': ponente.image,
        'company': ponente.company,
        'position': ponente.position,
        'description': ponente.description,
        'city': ponente.city
      },
      conflictAlgorithm: ConflictAlgorithm.replace);

  Future<void> update(Ponente ponente) async =>
      await database.update('speakers', ponente.toMap(),
          where: 'id = ?', whereArgs: [ponente.id]);

  Future<void> delete(Ponente ponente) async => await database
      .delete('speakers', where: 'id = ?', whereArgs: [ponente.id]);

  Future<void> deleteAll() async => await database.delete('speakers');
}
