import 'package:eventsbox/database/database_helper.dart';
import 'package:eventsbox/models/asistente.dart';
import 'package:sqflite/sqflite.dart';

class AttendeeDao {
  final database = DatabaseHelper.instance.db;

  Future<List<Asistente>> readAll() async {
    final data = await database.query('attendees');
    List<Asistente> attendees = data.map((e) => Asistente.fromJson(e)).toList();
    attendees.sort((a, b) => a.order.compareTo(b.order));
    return attendees;
  }

  Future<int> insert(Asistente attendee) async => await database.insert(
      'attendees',
      {
        'id': attendee.id,
        'item_order': attendee.order,
        'register_validated': attendee.registerValidated,
        'name': attendee.name,
        'last_name': attendee.lastName,
        'img': attendee.image,
        'code': attendee.code,
        'company': attendee.company,
        'position': attendee.position,
        'city': attendee.city,
        'country': attendee.country,
        'web': attendee.web,
        'linkedin': attendee.linkedin,
        'twitter': attendee.twitter,
        'facebook': attendee.facebook,
        'behance': attendee.behance,
        'youtube': attendee.youtube,
        'contactmail': attendee.contactMail
      },
      conflictAlgorithm: ConflictAlgorithm.replace);

  Future<void> update(Asistente attendee) async =>
      await database.update('attendees', attendee.topMap(),
          where: 'id = ?', whereArgs: [attendee.id]);

  Future<void> delete(Asistente attendee) async => await database
      .delete('attendees', where: 'id = ?', whereArgs: [attendee.id]);

  Future<Asistente> select(int id) async => Asistente.fromJson(
      (await database.query('attendees', where: 'id = ?', whereArgs: [id]))[0]);
}
