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
import 'package:eventsbox/widgets/info_sesion.dart';
import 'package:flutter/material.dart';

class Dia extends StatefulWidget {
  final String date;
  const Dia(this.date, {super.key});

  @override
  State<Dia> createState() => _DiaState();
}

class _DiaState extends State<Dia> {
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
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          List<Session> sesionesDelDia = <Session>[];
          for (Session s in snapshot.data!) {
            if (s.tabText == widget.date) {
              sesionesDelDia.add(s);
            }
          }
          return ListView.builder(
              itemCount: sesionesDelDia.length,
              itemBuilder: (BuildContext context, int index) {
                // Obtengo los ponentes de la sesión
                List<String> sessionSpeakers =
                    sesionesDelDia[index].speakers.split(',');
                List<Ponente> speakers = <Ponente>[];
                String speakersNames = '';
                if (sessionSpeakers.isNotEmpty) {
                  for (int i = 0; i < sessionSpeakers.length; i++) {
                    for (int j = 0; j < _speakers.length; j++) {
                      if (sessionSpeakers[i] == _speakers[j].id.toString()) {
                        speakers.add(_speakers[j]);
                        speakersNames +=
                            '${_speakers[j].name} ${_speakers[j].lastName}';

                        if (i < sessionSpeakers.length - 1) {
                          speakersNames += ',';
                        }
                      }
                    }
                  }
                  List<String> nombresSplit = speakersNames.split(',');
                  nombresSplit.sort(((a, b) => a.compareTo(b)));
                  speakersNames = nombresSplit.join(', ');
                  speakers.sort(((a, b) => a.name.compareTo(b.name)));
                }
                // Obtengo los moderadores de la sesión
                List<String> sessionModerators =
                    sesionesDelDia[index].moderators.split(',');
                List<Ponente> moderators = <Ponente>[];
                String moderatorsNames = '';
                if (sessionSpeakers.isNotEmpty) {
                  for (int i = 0; i < sessionModerators.length; i++) {
                    for (int j = 0; j < _speakers.length; j++) {
                      if (sessionModerators[i] == _speakers[j].id.toString()) {
                        moderators.add(_speakers[j]);
                        moderatorsNames +=
                            '${_speakers[j].name} ${_speakers[j].lastName}';

                        if (i < sessionModerators.length - 1) {
                          moderatorsNames += ', ';
                        }
                      }
                    }
                  }
                }
                // Obtengo los tracks de la sesión
                List<String> sessionTracks =
                    sesionesDelDia[index].tracks.split(',');
                List<Track> tracks = <Track>[];
                if (sessionTracks.isNotEmpty) {
                  for (int i = 0; i < sessionTracks.length; i++) {
                    for (int j = 0; j < _tracks.length; j++) {
                      if (sessionTracks[i] == _tracks[j].id.toString()) {
                        tracks.add(_tracks[j]);
                      }
                    }
                  }
                }
                // Obtengo los patrocinadores de la sesión
                List<String> sessionSponsors =
                    sesionesDelDia[index].sponsors.split(',');
                List<Patrocinador> sponsors = <Patrocinador>[];
                if (sessionSponsors.isNotEmpty) {
                  for (int i = 0; i < sessionSponsors.length; i++) {
                    for (int j = 0; j < _sponsors.length; j++) {
                      if (sessionSponsors[i] == _sponsors[j].id.toString()) {
                        sponsors.add(_sponsors[j]);
                      }
                    }
                  }
                }
                // Muestro la información básica de la sesión y si se pulsa sobre ella abre un AlertDialog con los detalles
                return GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: ((_) => AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            elevation: 0,
                            insetPadding:
                                const EdgeInsets.symmetric(horizontal: 25),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            content: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: detalleSesion(
                                  context,
                                  sesionesDelDia[index],
                                  tracks,
                                  moderators,
                                  speakers,
                                  sponsors),
                            ))));
                  },
                  child: InfoSesion(
                      sesionesDelDia[index],
                      moderatorsNames,
                      speakersNames),
                );
              });
        }));
  }
}
