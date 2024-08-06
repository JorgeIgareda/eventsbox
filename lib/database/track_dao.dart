import 'package:eventsbox/database/database_helper.dart';
import 'package:eventsbox/models/track.dart';
import 'package:sqflite/sqflite.dart';

class TrackDao {
  final database = DatabaseHelper.instance.db;

  Future<List<Track>> readAll() async {
    final data = await database.query('tracks');
    return data.map((e) => Track.fromJson(e)).toList();
  }

  Future<int> insert(Track track) async => await database.insert(
      'tracks', {'id': track.id, 'name': track.name, 'color': track.color},
      conflictAlgorithm: ConflictAlgorithm.replace);

  Future<void> update(Track track) async => await database
      .update('tracks', track.toMap(), where: 'id = ?', whereArgs: [track.id]);

  Future<void> delete(Track track) async =>
      await database.delete('tracks', where: 'id = ?', whereArgs: [track.id]);

  Future<void> deleteAll() async => await database.delete('tracks');
}
