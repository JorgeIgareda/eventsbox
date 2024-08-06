import 'package:eventsbox/database/home_module_dao.dart';
import 'package:eventsbox/globals/globals.dart';
import 'package:eventsbox/models/home_module.dart';
import 'package:eventsbox/pages/chat/mensajes_page.dart';
import 'package:eventsbox/services/api.dart';
import 'package:eventsbox/widgets/accesos_directos.dart';
import 'package:eventsbox/widgets/asistentes.dart';
import 'package:eventsbox/widgets/bottom_menu.dart';
import 'package:eventsbox/widgets/expositores.dart';
import 'package:eventsbox/widgets/galeria_de_imagenes.dart';
import 'package:eventsbox/widgets/galeria_de_videos.dart';
import 'package:eventsbox/widgets/hamburger_menu.dart';
import 'package:eventsbox/widgets/imagen_principal.dart';
import 'package:eventsbox/widgets/patrocinadores.dart';
import 'package:eventsbox/widgets/ponentes.dart';
import 'package:eventsbox/widgets/sesiones.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

late Socket socket;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<HomeModule>> _modules;

  @override
  void initState() {
    super.initState();
    _modules = Globals.homeModulesObtenido
        ? HomeModuleDao().readAll()
        : Api.getModules();
    try {
      // Configure socket transports must be sepecified
      socket = io('https://liveapi.meetmaps.com/', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.connect();
      socket.emit("user_connection",
          [Globals.user, Globals.token, Globals.event, '', '']);
      socket.on('message_received_${Globals.event}_${Globals.user}',
          (data) async {
        Api.getChat();
        if (detailChatKey.currentState != null) {
          detailChatKey.currentState!.reload();
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mapa con los distintos módulos
    Map<String, Widget> widgetMap = {
      'agenda': const Sesiones(),
      'attendees': const Asistentes(), // Por hacer ASISTENTES
      'exhibitors': const Expositores(), // Por hacer EXPOSITORES
      'images_gallery':
          const GaleriaDeImagenes(), // Por hacer GALERIA DE IMAGENES
      'shortcuts': accesosDirectos(context),
      'speakers': const Ponentes(),
      'sponsors': const Patrocinadores(),
      'videos_gallery': const GaleriaDeVideos() // Por hacer GALERIA DE VIDEOS
    };

    return FutureBuilder(
      future: _modules,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Principal')),
          drawer: const HamburgerMenu(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Imagen principal del evento
                imagenPrincipal(),
                // Módulos de la página principal
                ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Si el título no esta oculto muestra una fila con el título y el botón de ver todo
                            snapshot.data![index].hiddenTitle == 0
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(snapshot.data![index].title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  '/${snapshot.data![index].module}');
                                            },
                                            child: Text('Ver todo',
                                                style: TextStyle(
                                                    color: Colors.blue[900],
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )
                                        ]),
                                  )
                                : const SizedBox(),
                            // Utilizo el mapa para colocar el módulo correspondiente
                            widgetMap[snapshot.data![index].module]!
                          ]);
                    }),
                const SizedBox(height: 20)
              ],
            ),
          ),
          bottomNavigationBar: const BottomMenu(),
        );
      },
    );
  }
}
