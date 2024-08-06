import 'package:eventsbox/database/database_helper.dart';
import 'package:eventsbox/models/chat.dart';
import 'package:sqflite/sqflite.dart';

class ChatDao {
  final database = DatabaseHelper.instance.db;

  Future<List<Chat>> readAll() async {
    final data = await database.query('chat');
    return data.map((e) => Chat.fromJson(e)).toList();
  }

  Future<int> insert(Chat chat) async =>
      await database.insert('chat', chat.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

  Future<void> update(Chat chat) async => await database
      .update('chat', chat.toMap(), where: 'id = ?', whereArgs: [chat.id]);

  Future<void> delete(Chat chat) async =>
      await database.delete('chat', where: 'id = ?', whereArgs: [chat.id]);

  Future<void> setReaded(int userId) async => await database
      .update('chat', {'readed': 1}, where: 'chat_to = ?', whereArgs: [userId]);
}
