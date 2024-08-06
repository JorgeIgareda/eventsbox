import 'dart:typed_data';

import 'package:eventsbox/database/calendar_dao.dart';
import 'package:eventsbox/database/categorie_sponsor_dao.dart';
import 'package:eventsbox/database/home_module_dao.dart';
import 'package:eventsbox/database/image_dao.dart';
import 'package:eventsbox/database/image_gallery_dao.dart';
import 'package:eventsbox/database/menu_dao.dart';
import 'package:eventsbox/database/session_dao.dart';
import 'package:eventsbox/database/speaker_dao.dart';
import 'package:eventsbox/database/sponsor_dao.dart';
import 'package:eventsbox/database/track_dao.dart';
import 'package:eventsbox/globals/globals.dart';
import 'package:eventsbox/models/galeria_imagenes.dart';
import 'package:eventsbox/pages/loading_page2.dart';
import 'package:eventsbox/services/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Logger logger = Logger();

// Navega a la ruta que se le pasa como parámetro mostrando una pantalla de carga durante 3 segundos
void loadPage(context, String route) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const LoadingPage2()));
  await Future.delayed(const Duration(seconds: 3));
  Navigator.pushReplacementNamed(context, route);
}

// Elimina el token de usuario y regresa a la página de inicio de sesión mostrando una pantalla de carga durante 3 segundos
void logOut(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', '');
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const LoadingPage2()));
  await Future.delayed(const Duration(seconds: 3));
  Navigator.pop(context);
  Navigator.pushReplacementNamed(context, '/');
}

void reload(context) async {
  Globals.listadoCategoriasSponsorsObtenido = false;
  Globals.listadoDiasObtenido = false;
  Globals.listadoPonentesObtenido = false;
  Globals.listadoTracksObtenido = false;
  Globals.listadoSponsorsObtenido = false;
  Globals.listadoSesionesObtenido = false;
  Globals.homeModulesObtenido = false;
  Globals.galeriasImagenesObtenido = false;
  await CalendarDao().deleteAll();
  await CategorieSponsorDao().deleteAll();
  await HomeModuleDao().deleteAll();
  await ImageDao().deleteAll();
  await ImageGalleryDao().deleteAll();
  await MenuDao().deleteAll();
  await SessionDao().deleteAll();
  await SpeakerDao().deleteAll();
  await SponsorDao().deleteAll();
  await TrackDao().deleteAll();
  loadPage(context, '/home');
}

/// Descarga el archivo en el teléfono
Future<void> downloadFile(String url) async {
  Response response =
      await Dio().get(url, options: Options(responseType: ResponseType.bytes));
  await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
      name: url.substring(url.lastIndexOf('/') + 1));
}

/// Sube una imagen a la galería
Future<void> uploadImage(BuildContext context, GaleriaImagenes galeria,
    String description, String base64) async {
  galeria.galleryPhotos
      .add(await Api.uploadPhoto(galeria, description, base64));
  galeria.numPhotos++;
  await ImageGalleryDao().update(galeria);
  if (context.mounted) {
    Navigator.pop(context);
  }
}
