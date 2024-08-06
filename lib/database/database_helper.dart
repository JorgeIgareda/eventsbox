import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._internal();
  static DatabaseHelper get instance =>
      _databaseHelper ??= DatabaseHelper._internal();

  Database? _db;
  Database get db => _db!;

  Future<void> init() async {
    _db =
        await openDatabase('database.db', version: 1, onCreate: (db, version) {
      db.execute(
          'CREATE TABLE speakers (id INTEGER PRIMARY KEY, name VARCHAR(255), last_name VARCHAR(255), image VARCHAR(255), company VARCHAR(255), position VARCHAR(255), description VARCHAR(255), city VARCHAR(255))');
      db.execute(
          'CREATE TABLE sessions (id INTEGER PRIMARY KEY, name VARCHAR(255), location VARCHAR(255), date VARCHAR(255), date_end VARCHAR(255), time_start VARCHAR(255), time_end VARCHAR(255), no_end_time INTEGER, datetime_order VARCHAR(255), speakers VARCHAR(255), sponsors VARCHAR(255), moderators VARCHAR(255), tabText VARCHAR(255), tracks VARCHAR(255))');
      db.execute(
          'CREATE TABLE tracks (id INTEGER PRIMARY KEY, name VARCHAR(255), color VARCHAR(255))');
      db.execute(
          'CREATE TABLE sponsors (id INTEGER PRIMARY KEY, name VARCHAR(255), web VARCHAR(255), mail VARCHAR(255), phone VARCHAR(255), linkedin VARCHAR(255), twitter VARCHAR(255), facebook VARCHAR(255), instagram VARCHAR(255), youtube VARCHAR(255), category INTEGER, exhibitor INTEGER, logo VARCHAR(255), banner VARCHAR(255))');
      db.execute(
          'CREATE TABLE calendar (id INTEGER PRIMARY KEY AUTOINCREMENT, dia VARCHAR(255) UNIQUE)');
      db.execute(
          'CREATE TABLE categories_sponsors (id INTEGER PRIMARY KEY, name VARCHAR(255), color VARCHAR(255), columns INTEGER)');
      db.execute(
          'CREATE TABLE menu (id INTEGER PRIMARY KEY, item_order INTEGER, title VARCHAR(255), icon VARCHAR(255), content VARCHAR(255), social INTEGER, location INTEGER)');
      db.execute(
          'CREATE TABLE home_modules (id_module INTEGER PRIMARY KEY, item_order INTEGER, module VARCHAR(255), app_visible INTEGER, hidden_title INTEGER, title VARCHAR(255))');
      db.execute(
          'CREATE TABLE images_galleries (id INTEGER PRIMARY KEY, item_order INTEGER, name VARCHAR(255), image VARCHAR(255), thumb VARCHAR(255), date VARCHAR(255), upload_admin INTEGER, num_photos INTEGER)');
      db.execute(
          'CREATE TABLE images (id INTEGER PRIMARY KEY, item_order INTEGER, user INTEGER, image VARCHAR(255), thumb VARCHAR(255), description VARCHAR(255), likes INTEGER, my_like INTEGER, gallery_id INTEGER, FOREIGN KEY (gallery_id) REFERENCES images_galleries (id))');
      db.execute(
          'CREATE TABLE attendees (id INTEGER PRIMARY KEY, item_order INTEGER, register_validated INTEGER, name VARCHAR(255), last_name VARCHAR(255), img VARCHAR(255), code VARCHAR(255), company VARCHAR(255), position VARCHAR(255), city VARCHAR(255), country VARCHAR(255), web VARCHAR(255), linkedin VARCHAR(255), twitter VARCHAR(255), facebook VARCHAR(255), behance VARCHAR(255), youtube VARCHAR(255), contactmail VARCHAR(255))');
      db.execute(
          'CREATE TABLE chat (id INTEGER PRIMARY KEY, sender VARCHAR(255), chat_to INTEGER, chat_from INTEGER, message VARCHAR(255), readed INTEGER, date VARCHAR(255))');
    });
  }
}
