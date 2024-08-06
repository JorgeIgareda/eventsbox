import 'package:eventsbox/database/attendee_dao.dart';
import 'package:eventsbox/database/chat_dao.dart';
import 'package:eventsbox/models/asistente.dart';
import 'package:eventsbox/models/chat.dart';
import 'package:eventsbox/widgets/bottom_menu.dart';
import 'package:eventsbox/widgets/hamburger_menu.dart';
import 'package:flutter/material.dart';

GlobalKey<_MensajesPageState> detailChatKey = GlobalKey<_MensajesPageState>();
class MensajesPage extends StatefulWidget {
  const MensajesPage({super.key});

  @override
  State<MensajesPage> createState() => _MensajesPageState();
}

class _MensajesPageState extends State<MensajesPage> {
  late Future<Map<int, Asistente>> _asistentes;
  late List<Chat> _mensajes;
  Map<int, int> _mensajesSinLeer = {};

  Future<Map<int, Asistente>> _getAsistentes() async {
    _mensajes = await ChatDao().readAll();
    List<Asistente> asistentes = await AttendeeDao().readAll();
    Map<int, Asistente> asistentesMap = {for (var a in asistentes) a.id: a};

    return asistentesMap;
  }

  reload() {
    _getAsistentes();
  }

  @override
  void initState() {
    super.initState();
    _asistentes = _getAsistentes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _asistentes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        // Almaceno en un Set los ID de todos los asistentes con los que el usuario ha tenido mensajes
        Set<int> asistentesConMensajesIds = {};
        for (var mensaje in _mensajes.reversed) {
          asistentesConMensajesIds.add(mensaje.chatTo);
          // Si el mensaje no fue leído, lo añade al contador
          if (mensaje.readed == 0) {
            _mensajesSinLeer[mensaje.chatTo] =
                (_mensajesSinLeer[mensaje.chatTo] ?? 0) + 1;
          }
        }
        // Creo la lista con los asistentes con los que el usuario ha tenido mensajes
        List<Asistente> asistentes = asistentesConMensajesIds
            .where((id) => snapshot.data!.containsKey(id))
            .map((id) => snapshot.data![id]!)
            .toList();

        return Scaffold(
          drawer: const HamburgerMenu(),
          appBar: AppBar(title: const Text('Mensajes')),
          body: ListView.builder(
              itemCount: asistentes.length,
              itemBuilder: (BuildContext context, int index) {
                int mensajesSinLeer =
                    _mensajesSinLeer[asistentes[index].id] ?? 0;
                return Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/chat',
                            arguments: asistentes[index]);
                        _mensajes = await ChatDao().readAll();
                        _mensajesSinLeer = {};
                        setState(() {
                        });
                      },
                      leading: asistentes[index].image.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(asistentes[index].image),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.blue[900],
                              child: Text(asistentes[index].name[0],
                                  style: const TextStyle(color: Colors.white))),
                      title: Text(
                          '${asistentes[index].name} ${asistentes[index].lastName}'),
                      subtitle: Text(asistentes[index].company),
                      trailing: mensajesSinLeer > 0
                          ? CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 16,
                              child: Text('$mensajesSinLeer',
                                  style: const TextStyle(color: Colors.white)))
                          : null,
                    ),
                    const Divider()
                  ],
                );
              }),
          bottomNavigationBar: const BottomMenu(),
        );
      },
    );
  }
}
