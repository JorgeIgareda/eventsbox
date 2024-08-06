import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Session {
  int id;
  String name;
  String location;
  String dateStart;
  String dateEnd;
  String timeStart;
  String timeEnd;
  int noEndTime;
  String dateTimeOrder;
  String speakers;
  String sponsors;
  String moderators;
  String tabText;
  String tracks;

  Session(
      this.id,
      this.name,
      this.location,
      this.dateStart,
      this.dateEnd,
      this.timeStart,
      this.timeEnd,
      this.noEndTime,
      this.dateTimeOrder,
      this.speakers,
      this.sponsors,
      this.moderators,
      this.tabText,
      this.tracks);
  factory Session.fromJson(Map<String, dynamic> json) {
    initializeDateFormatting('es_ES', null);
    Session session = Session(
        json["id"] as int,
        json["name"] as String,
        json["location"] as String,
        json["date"] as String,
        json["date_end"] as String,
        json["time_start"] as String,
        json["time_end"] as String,
        json["no_end_time"] as int,
        json["datetime_order"] as String,
        json["speakers"] as String,
        json["sponsors"] as String,
        json["moderators"] as String,
        '${DateFormat.EEEE('es_ES').format(DateTime.parse(json["date"]))} ${DateFormat.d().format(DateTime.parse(json["date"]))}',
        json["tracks"] as String);

    return session;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'location': location,
        'date': dateStart,
        'date_end': dateEnd,
        'time_start': timeStart,
        'time_end': timeEnd,
        'no_end_time': noEndTime,
        'datetime_order': dateTimeOrder,
        'speakers': speakers,
        'sponsors': sponsors,
        'moderators': moderators,
        'tabText': tabText,
        'tracks': tracks
      };
}
