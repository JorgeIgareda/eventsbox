import 'package:eventsbox/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class CalendarDao {
  final database = DatabaseHelper.instance.db;

  Future<List<String>> readAll() async {
    final data = await database.query('calendar');
    return data.map((e) => e['dia'].toString()).toList();
  }

  Future<int> insert(String dia) async =>
      await database.insert('calendar', {'dia': dia},
          conflictAlgorithm: ConflictAlgorithm.replace);

  Future<void> deleteAll() async => await database.delete('calendar');
}
