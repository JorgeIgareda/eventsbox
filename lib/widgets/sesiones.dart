import 'package:eventsbox/database/session_dao.dart';
import 'package:eventsbox/database/speaker_dao.dart';
import 'package:eventsbox/database/sponsor_dao.dart';
import 'package:eventsbox/database/track_dao.dart';
import 'package:eventsbox/globals/globals.dart';
import 'package:eventsbox/models/patrocinador.dart';
import 'package:eventsbox/models/ponente.dart';
import 'package:eventsbox/models/session.dart';
import 'package:eventsbox/models/track.dart';
import 'package:eventsbox/services/api.dart';
import 'package:eventsbox/widgets/detalle_sesion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Sesiones extends StatefulWidget {
  const Sesiones({super.key});

  @override
  State<Sesiones> createState() => _SesionesState();
}

class _SesionesState extends State<Sesiones> {
  late Future<List<Session>> _sesiones;
  late List<Ponente> _speakers = <Ponente>[];
  late List<Track> _tracks = <Track>[];
  late List<Patrocinador> _sponsors = <Patrocinador>[];

  @override
  void initState() {
    super.initState();
    _sesiones = _getSesiones();
  }

  Future<List<Session>> _getSesiones() async {
    _speakers = Globals.listadoPonentesObtenido
        ? await SpeakerDao().readAll()
        : await Api.getListadoPonentes();
    _tracks = Globals.listadoTracksObtenido
        ? await TrackDao().readAll()
        : await Api.getTracks();
    _sponsors = Globals.listadoSponsorsObtenido
        ? await SponsorDao().readAll()
        : await Api.getSponsors();
    return Globals.listadoSesionesObtenido
        ? await SessionDao().readAll()
        : await Api.getListaSesiones();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _sesiones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return noHaySesionesFuturas();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          DateTime now = DateTime.now();
          List<Session> sesiones = <Session>[];
          for (Session s in snapshot.data!) {
            if (DateTime.parse('${s.dateEnd} ${s.timeEnd}').isAfter(now)) {
              sesiones.add(s);
            }
          }
          sesiones.sort((a, b) => a.dateTimeOrder.compareTo(b.dateTimeOrder));
          return sesiones.isNotEmpty
              ? Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                      height: 150,
                      child: ListView.builder(
                          itemCount: sesiones.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemExtent: 300,
                          itemBuilder: (BuildContext context, int index) {
                            ///////////////////////////////////////
                            // Obtengo los ponentes de la sesión //
                            ///////////////////////////////////////
                            List<String> sessionSpeakers =
                                sesiones[index].speakers.split(',');
                            List<Ponente> speakers = <Ponente>[];
                            if (sessionSpeakers.isNotEmpty) {
                              for (int i = 0; i < sessionSpeakers.length; i++) {
                                for (int j = 0; j < _speakers.length; j++) {
                                  if (sessionSpeakers[i] ==
                                      _speakers[j].id.toString()) {
                                    speakers.add(_speakers[j]);
                                  }
                                }
                              }
                              speakers
                                  .sort(((a, b) => a.name.compareTo(b.name)));
                            }
                            //////////////////////////////////////////
                            // Obtengo los moderadores de la sesión //
                            //////////////////////////////////////////
                            List<String> sessionModerators =
                                sesiones[index].moderators.split(',');
                            List<Ponente> moderators = <Ponente>[];
                            if (sessionSpeakers.isNotEmpty) {
                              for (int i = 0;
                                  i < sessionModerators.length;
                                  i++) {
                                for (int j = 0; j < _speakers.length; j++) {
                                  if (sessionModerators[i] ==
                                      _speakers[j].id.toString()) {
                                    moderators.add(_speakers[j]);
                                  }
                                }
                              }
                            }
                            /////////////////////////////////////
                            // Obtengo los tracks de la sesión //
                            /////////////////////////////////////
                            List<String> sessionTracks =
                                sesiones[index].tracks.split(',');
                            List<Track> tracks = <Track>[];
                            if (sessionTracks.isNotEmpty) {
                              for (int i = 0; i < sessionTracks.length; i++) {
                                for (int j = 0; j < _tracks.length; j++) {
                                  if (sessionTracks[i] ==
                                      _tracks[j].id.toString()) {
                                    tracks.add(_tracks[j]);
                                  }
                                }
                              }
                            }
                            /////////////////////////////////////////////
                            // Obtengo los patrocinadores de la sesión //
                            /////////////////////////////////////////////
                            List<String> sessionSponsors =
                                sesiones[index].sponsors.split(',');
                            List<Patrocinador> sponsors = <Patrocinador>[];
                            if (sessionSponsors.isNotEmpty) {
                              for (int i = 0; i < sessionSponsors.length; i++) {
                                for (int j = 0; j < _sponsors.length; j++) {
                                  if (sessionSponsors[i] ==
                                      _sponsors[j].id.toString()) {
                                    sponsors.add(_sponsors[j]);
                                  }
                                }
                              }
                            }

                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: ((_) => AlertDialog(
                                        contentPadding: EdgeInsets.zero,
                                        elevation: 0,
                                        insetPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 25),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        content: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: detalleSesion(
                                              context,
                                              sesiones[index],
                                              tracks,
                                              moderators,
                                              speakers,
                                              sponsors),
                                        ))));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    right: 5, top: 5, bottom: 5),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        DateTime.parse(
                                                    sesiones[index].dateStart)
                                                .isBefore(now)
                                            ? Container(
                                                margin: const EdgeInsets.only(right: 10),
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: const Text('En directo',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              )
                                            : const SizedBox(),
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1,
                                                  style: BorderStyle.solid),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5))),
                                          child: const Text('Sesión'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(sesiones[index].name,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    ListTile(
                                      title: Text(
                                        formatDateTime(
                                            sesiones[index].dateStart,
                                            sesiones[index].dateEnd,
                                            sesiones[index].timeStart,
                                            sesiones[index].timeEnd),
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      leading: const Icon(Icons.schedule),
                                      horizontalTitleGap: 5,
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ))
                  ],
                )
              : noHaySesionesFuturas();
        });
  }

  Widget noHaySesionesFuturas() {
    return Container(
      height: 150,
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey.shade400, width: 1, style: BorderStyle.solid),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: const Text('No hay sesiones futuras'),
    );
  }

  /// Convierto los datos de fecha y hora de la sesión al formato en el que quiero que se muestren
  /// Ejemplo: date: 2024-04-25, time_start: 10:00:00, time_end: 15:00:00 se convierten a  "Jueves 25 de abril, 10:00 - 15:00"
  String formatDateTime(
      String date, String dateEnd, String timeStart, String timeEnd) {
    DateTime dateTimeStart = DateTime.parse('$date $timeStart');
    DateTime dateTimeEnd = DateTime.parse('$dateEnd $timeEnd');

    DateFormat dayFormat =
        DateFormat('EEEE', 'es_ES'); // Formato del día de la semana
    DateFormat dateFormat =
        DateFormat('d \'de\' MMMM', 'es_ES'); // Formato de la fecha
    DateFormat timeFormat = DateFormat('HH:mm'); // Formato de la hora

    String formattedDate =
        '${dayFormat.format(dateTimeStart)} ${dateFormat.format(dateTimeStart)}';
    String formattedTimeRange =
        '${timeFormat.format(dateTimeStart)} - ${timeFormat.format(dateTimeEnd)}';

    return '${formattedDate[0].toUpperCase()}${formattedDate.substring(1)}, $formattedTimeRange';
  }
}
