import 'package:eventsbox/database/database_helper.dart';
import 'package:eventsbox/models/session.dart';
import 'package:sqflite/sqflite.dart';

class SessionDao {
  final database = DatabaseHelper.instance.db;

  Future<List<Session>> readAll() async {
    final data = await database.query('sessions');
    return data.map((e) => Session.fromJson(e)).toList();
  }

  Future<int> insert(Session session) async => await database.insert(
      'sessions',
      {
        'id': session.id,
        'name': session.name,
        'location': session.location,
        'date': session.dateStart,
        'date_end': session.dateEnd,
        'time_start': session.timeStart,
        'time_end': session.timeEnd,
        'no_end_time': session.noEndTime,
        'datetime_order': session.dateTimeOrder,
        'speakers': session.speakers,
        'sponsors': session.sponsors,
        'moderators': session.moderators,
        'tabText': session.tabText,
        'tracks': session.tracks
      },
      conflictAlgorithm: ConflictAlgorithm.replace);

  Future<void> update(Session session) async =>
      await database.update('sessions', session.toMap(),
          where: 'id = ?', whereArgs: [session.id]);

  Future<void> delete(Session session) async => await database
      .delete('sessions', where: 'id = ?', whereArgs: [session.id]);

  Future<void> deleteAll() async => await database.delete('sessions');
}
