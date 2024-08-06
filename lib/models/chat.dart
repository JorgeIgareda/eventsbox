import 'package:eventsbox/globals/globals.dart';

class Chat {
  int id;
  String sender;
  int chatTo;
  int chatFrom;
  String message;
  int readed;
  String date;

  Chat(this.id, this.sender, this.chatTo, this.chatFrom, this.message, this.readed, this.date);
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      json['id'] as int,
      json['sender'] as String,
      json['chat_to'] as int,
      json['chat_from'] ?? Globals.user,
      json['message'] as String,
      json['readed'] as int,
      json['date'] as String
    );
  }

  Map<String, dynamic> toMap () => {
    'id': id,
    'sender': sender,
    'chat_to': chatTo,
    'chat_from': chatFrom,
    'message': message,
    'readed': readed,
    'date': date
  };
}