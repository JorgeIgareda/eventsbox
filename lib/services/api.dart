import 'dart:convert';
import 'package:eventsbox/database/attendee_dao.dart';
import 'package:eventsbox/database/calendar_dao.dart';
import 'package:eventsbox/database/categorie_sponsor_dao.dart';
import 'package:eventsbox/database/chat_dao.dart';
import 'package:eventsbox/database/home_module_dao.dart';
import 'package:eventsbox/database/image_dao.dart';
import 'package:eventsbox/database/image_gallery_dao.dart';
import 'package:eventsbox/database/menu_dao.dart';
import 'package:eventsbox/database/session_dao.dart';
import 'package:eventsbox/database/speaker_dao.dart';
import 'package:eventsbox/database/sponsor_dao.dart';
import 'package:eventsbox/database/track_dao.dart';
import 'package:eventsbox/models/asistente.dart';
import 'package:eventsbox/models/categoria_patrocinador.dart';
import 'package:eventsbox/models/chat.dart';
import 'package:eventsbox/models/galeria_imagenes.dart';
import 'package:eventsbox/models/home_module.dart';
import 'package:eventsbox/models/imagen.dart';
import 'package:eventsbox/models/item_menu.dart';
import 'package:eventsbox/models/patrocinador.dart';
import 'package:eventsbox/models/track.dart';
import 'package:eventsbox/pages/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:eventsbox/globals/globals.dart';
import 'package:eventsbox/models/ponente.dart';
import 'package:eventsbox/models/session.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static Uri apiUrl = Uri.parse('https://apiv1.meetmaps.com/api/index.php');
  static String apiKey = dotenv.env['API_KEY'] ?? '';

  static String eventID = dotenv.env['EVENT_ID'] ?? '';

  /// Devuelve el token del usuario en caso de que el email y el código sean correctos
  static Future<String> login(String email, String passCode) async {
    final http.Response response = await http.post(
      apiUrl,
      body: {
        "action": "event_login",
        "api_key": apiKey,
        "email": email,
        "passcode": passCode,
      },
    );
    final Map<String, dynamic> data = json.decode(response.body);
    // almacena el id del usuario y el token en shared preferences para que no sea necesario realizar el login de nuevo
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setInt('user', data['id'] as int);
    Globals.user = data['id'] as int;
    sharedPrefs.setString('token', data['token'] as String);
    Globals.token = data['token'] as String;

    return data['token'];
  }

  /// Devuelve una lista con todos los ponentes del evento y sus respectivos datos
  static Future<List<Ponente>> getListadoPonentes() async {
    final http.Response response = await http.post(apiUrl, body: {
      "action": "speaker_get_all_static",
      "event": Globals.event,
      "api_key": apiKey,
      "token": Globals.token
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)["results"];
      List<Ponente> ponentes =
          data.map((json) => Ponente.fromJson(json)).toList();
      for (Ponente ponente in ponentes) {
        SpeakerDao().insert(ponente);
      }
      Globals.listadoPonentesObtenido = true;
      return ponentes;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  /// Devuelve una lista con todas las sesiones del evento
  static Future<List<Session>> getListaSesiones() async {
    final http.Response response = await http.post(apiUrl, body: {
      "action": "session_get_all_static",
      "token": Globals.token,
      "api_key": apiKey,
      "event": Globals.event
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)["results"];
      List<Session> sesiones =
          data.map((json) => Session.fromJson(json)).toList();
      for (Session sesion in sesiones) {
        SessionDao().insert(sesion);
      }
      Globals.listadoSesionesObtenido = true;
      return sesiones;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  /// Devuelve una lista con todos los días en los que hay sesiones
  static Future<List<String>> getListaDias() async {
    final http.Response response = await http.post(apiUrl, body: {
      "action": "session_get_all_static",
      "token": Globals.token,
      "api_key": apiKey,
      "event": Globals.event
    });
    if (response.statusCode == 200) {
      List<String> dias = <String>[];
      final List<dynamic> data = json.decode(response.body)["results"];
      List<Session> sesiones =
          data.map((json) => Session.fromJson(json)).toList();
      for (Session s in sesiones) {
        if (!dias.contains(s.dateStart)) {
          dias.add(s.dateStart);
        }
      }
      for (int i = 0; i < dias.length; i++) {
        DateTime date = DateTime.parse(dias[i]);
        String fecha =
            '${DateFormat.EEEE('es_ES').format(date)} ${DateFormat.d().format(date)}';
        dias[i] = fecha;
        CalendarDao().insert(fecha);
      }
      Globals.listadoDiasObtenido = true;
      return dias;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  /// Devuelve una lista con los tracks de las sesiones del evento
  static Future<List<Track>> getTracks() async {
    final http.Response response = await http.post(apiUrl, body: {
      "action": "session_get_all_static",
      "token": Globals.token,
      "api_key": apiKey,
      "event": Globals.event
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)["tracks"];
      List<Track> tracks = data.map((json) => Track.fromJson(json)).toList();
      for (Track track in tracks) {
        TrackDao().insert(track);
      }
      Globals.listadoTracksObtenido = true;
      return tracks;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  /// Devuelve una lista con los patrocinadores del evento
  static Future<List<Patrocinador>> getSponsors() async {
    final http.Response response = await http.post(apiUrl, body: {
      "action": "sponsor_get_all_static",
      "token": Globals.token,
      "api_key": apiKey,
      "event": Globals.event
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)["results"];
      List<Patrocinador> patrocinadores =
          data.map((json) => Patrocinador.fromJson(json)).toList();
      for (Patrocinador patrocinador in patrocinadores) {
        SponsorDao().insert(patrocinador);
      }
      Globals.listadoSponsorsObtenido = true;
      return patrocinadores;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  /// Devuelve una lista con las categorías de los patrocinadores
  static Future<List<CategoriaPatrocinador>> getCategoriesSponsors() async {
    final http.Response response = await http.post(apiUrl, body: {
      "action": "sponsor_get_all_static",
      "token": Globals.token,
      "api_key": apiKey,
      "event": Globals.event
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['categories'];
      List<CategoriaPatrocinador> categorias =
          data.map((json) => CategoriaPatrocinador.fromJson(json)).toList();
      for (CategoriaPatrocinador categoria in categorias) {
        CategorieSponsorDao().insert(categoria);
      }
      Globals.listadoCategoriasSponsorsObtenido = true;
      return categorias;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  /// Devuelve los items del menú
  static Future<List<ItemMenu>> getMenu() async {
    final http.Response response = await http.post(apiUrl, body: {
      'action': 'menu_get_event',
      'token': Globals.token,
      'api_key': apiKey,
      'lang': 'es',
      'event': Globals.event
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      int order = 0;
      List<ItemMenu> items =
          data.map((json) => ItemMenu.fromJson(json, order++)).toList();
      for (ItemMenu item in items) {
        MenuDao().insert(item);
      }
      return items;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  /// Devuelve los módulos del HomePage
  static Future<List<HomeModule>> getModules() async {
    final http.Response response = await http.post(apiUrl, body: {
      'action': 'event_get_static',
      'api_key': apiKey,
      'event': eventID
    });
    if (response.statusCode == 200) {
      final List<dynamic> data =
          json.decode(response.body)['result']['home_modules'];
      int order = 0;
      List<HomeModule> modules =
          data.map((json) => HomeModule.fromJson(json, order++)).toList();
      for (HomeModule module in modules) {
        HomeModuleDao().insert(module);
      }
      Globals.homeModulesObtenido = true;
      return modules;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  /// Devuelve las galerías de imágenes
  static Future<List<GaleriaImagenes>> getImagesGallery() async {
    final http.Response response = await http.post(apiUrl, body: {
      'action': 'gallery_get_list',
      'api_key': apiKey,
      'token': Globals.token,
      'event': Globals.event
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      int orden = 0;
      List<GaleriaImagenes> galerias =
          data.map((json) => GaleriaImagenes.fromJson(json, orden++)).toList();
      for (GaleriaImagenes galeria in galerias) {
        ImageGalleryDao().insert(galeria);
      }
      Globals.galeriasImagenesObtenido = true;
      return galerias;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  /// Sube una foto del usuario a una galería
  static Future<Imagen> uploadPhoto(
      GaleriaImagenes galeria, String description, String base64) async {
    final http.Response response = await http.post(apiUrl, body: {
      'action': 'gallery_add_photo',
      'event': Globals.event,
      'gallery': galeria.id.toString(),
      'token': Globals.token,
      'lang': Intl.defaultLocale,
      'description': description,
      'picture64': base64
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['result'];
      Imagen imagen = Imagen.fromJson(data, galeria.id, 0);
      ImageDao().insert(imagen);
      return imagen;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  /// Obtiene la lista de asistentes
  static Future<List<Asistente>> getAttendees() async {
    final http.Response response = await http.post(apiUrl, body: {
      'action': 'attendee_get_news',
      'event': Globals.event,
      'token': Globals.token,
      'api_key': apiKey,
      'date': Globals.lastAttendeeUpdate
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      // Actualizo la fecha
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      String dateHost = data['date_host'];
      sharedPrefs.setString('lastAttendeeUpdate', dateHost);
      Globals.lastAttendeeUpdate = dateHost;

      List<Asistente> asistentes = (data['results'] as List<dynamic>)
          .map((json) => Asistente.fromJson(json))
          .toList();
      for (Asistente asistente in asistentes) {
        AttendeeDao().insert(asistente);
      }
      return asistentes;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  /// Obtiene los mensajes del chat
  static Future<List<Chat>> getChat() async {
    final http.Response response = await http
        .post(Uri.parse('https://apiv1.meetmaps.com/api/chat.php'), body: {
      'action': 'chat_get_my_messages',
      'event': Globals.event,
      'token': Globals.token,
      'api_key': apiKey,
      'last': Globals.lastChatReceived.toString()
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Chat> chats = (data.map((json) => Chat.fromJson(json))).toList();

      // Actualizo last si es necesario
      if (chats.isNotEmpty) {
        SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
        sharedPrefs.setInt('lastChatReceived', chats.last.id);
        Globals.lastChatReceived = chats.last.id;
      }

      for (Chat chat in chats) {
        ChatDao().insert(chat);
      }
      return chats;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  /// Envía un mensaje por el chat
  static Future<Chat> sendMessage(String message, int id) async {
    final http.Response response = await http.post(apiUrl, body: {
      'action': 'chat_add',
      'event': Globals.event,
      'token': Globals.token,
      'lang': Intl.defaultLocale,
      'user': id.toString(),
      'message': message,
      'type': '0',
      'file': ''
    });
    // "error": 2, "error_name": "Unauthorized",
    if (response.statusCode == 200) {
      socket.emit(
          "send_message", [json.decode(response.body), id, Globals.event]);
      Logger().i(json.decode(response.body));
      Map<String, dynamic> data = json.decode(response.body)['result'];
      Chat chat = Chat.fromJson(data);
      ChatDao().insert(chat);
      return chat;
    } else {
      throw Exception('Falló la conexión');
    }
  }

  /// Marca los mensajes como leídos
  static Future<void> setReaded(int chatTo, int last) async {
    final http.Response response = await http.post(apiUrl, body: {
      'action': 'chat_set_readed',
      'event': Globals.event,
      'token': Globals.token,
      'lang': Intl.defaultLocale,
      'user': chatTo.toString(),
      'last': last.toString()
    });
    if (response.statusCode == 200) {
      await ChatDao().setReaded(chatTo);
    } else {
      throw Exception('Falló la conexión');
    }
  }
}
