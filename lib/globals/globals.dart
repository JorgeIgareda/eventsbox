import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Globals{
  static int user = 0;
  static String token = '';
  static String event = dotenv.env['EVENT'] ?? '';
  static String lastAttendeeUpdate = '';
  static int lastChatReceived = 0;
  static bool listadoPonentesObtenido = false;
  static bool listadoSesionesObtenido = false;
  static bool listadoDiasObtenido = false;
  static bool listadoTracksObtenido = false;
  static bool listadoSponsorsObtenido = false;
  static bool listadoCategoriasSponsorsObtenido = false;
  static bool homeModulesObtenido = false;
  static bool galeriasImagenesObtenido = false;


  static Map<String, IconData> iconMap = {
  'account_circle': Icons.account_circle,
  'apps': Icons.apps,
  'badge': Icons.badge, // No es el mismo que se ve en la app
  'board': Icons.help, // No tengo icono board
  'bubble': Icons.help, // No tengo icono bubble
  'feedback': Icons.feedback,
  'file': Icons.help, // No tengo icono file
  'flag': Icons.flag,
  'folder_user': Icons.help, // No tengo icono folder_user
  'form': Icons.help, // No tengo icono form
  'gamification': Icons.help, // No tengo icono gamification
  'group': Icons.group,
  'image': Icons.image,
  'info': Icons.info,
  'map': Icons.map,
  'meeting': Icons.help, // No tengo icono meeting
  'message': Icons.message,
  'news': Icons.help, // No tengo icono news,
  'note': Icons.note,
  'notification': Icons.help, // No tengo icono notification
  'play': Icons.help, // No tengo icono play
  'person': Icons.person,
  'poll': Icons.poll,
  'public': Icons.public,
  'qa': Icons.question_answer,
  'star': Icons.star,
  'store': Icons.store,
  'today': Icons.today,
  'voice': Icons.help, // No tengo icono voice
  'video': Icons.help // No tengo icono video
};
}