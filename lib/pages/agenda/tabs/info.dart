import 'package:eventsbox/globals/global_theme.dart';
import 'package:eventsbox/models/patrocinador.dart';
import 'package:eventsbox/models/ponente.dart';
import 'package:eventsbox/models/session.dart';
import 'package:eventsbox/models/track.dart';
import 'package:eventsbox/widgets/lista_con_titulo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Info extends StatelessWidget {
  final Session sesion;
  final List<Track> tracks;
  final List<Ponente> ponentes;
  final List<Ponente> moderadores;
  final List<Patrocinador> patrocinadores;

  const Info(this.sesion, this.tracks, this.ponentes, this.moderadores,
      this.patrocinadores,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ////////////////////////////////////////////////
          // -----------> NOMBRE <----------------------//
          ////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListTile(
                title: Text(sesion.name, style: const TextStyle(fontSize: 20)),
                horizontalTitleGap: 5,
                minVerticalPadding: 0,
                dense: true,
                visualDensity:
                    const VisualDensity(horizontal: 0, vertical: -4)),
          ),
          ////////////////////////////////////////////////
          // -----------> HORARIO <---------------------//
          ////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: ListTile(
                title: Text(
                    sesion.noEndTime == 0
                        ? '${sesion.timeStart.substring(0, 5)} - ${sesion.timeEnd.substring(0, 5)}'
                        : sesion.timeStart.substring(0, 5),
                    style: const TextStyle(fontSize: 12)),
                leading: const Icon(
                  Icons.schedule,
                  size: 15,
                ),
                horizontalTitleGap: 0,
                minVerticalPadding: 0,
                dense: true,
                visualDensity:
                    const VisualDensity(horizontal: 0, vertical: -4)),
          ),
          ////////////////////////////////////////////////
          // -----------> TRACKS <----------------------//
          ////////////////////////////////////////////////
          if (tracks.isNotEmpty) ...[
            Row(
              children: [
                Expanded(
                    child: SizedBox(
                  height: 45,
                  child: ListView.builder(
                    itemCount: tracks.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        margin:
                            const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            color: Color(int.parse(tracks[index].color.replaceFirst(
                                '#',
                                '0xFF'))) // Para usar strings hexadecimales como colores
                            ),
                        child: Text(
                          tracks[index].name,
                          style: TextStyle(
                              color: GlobalThemeData.lightColorScheme.onPrimary,
                              fontSize: 12),
                        ),
                      );
                    },
                  ),
                ))
              ],
            )
          ],
          ////////////////////////////////////////////////
          // -----------> VALORACIÓN <------------------//
          ////////////////////////////////////////////////
          Container(
            padding: const EdgeInsets.all(10),
            child: RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) => const Icon(Icons.star),
                onRatingUpdate: (rating) {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            title: const Text('Enviar valoración'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('CANCELAR',
                                      style:
                                          TextStyle(color: Colors.blue[900]))),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('ENVIAR',
                                      style:
                                          TextStyle(color: Colors.blue[900])))
                            ],
                          ));
                }),
          ),
          ////////////////////////////////////////////////
          // -----------> PONENTES <--------------------//
          ////////////////////////////////////////////////
          if (ponentes.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: listaPonentesConTitulo(context, ponentes, 'Ponentes'),
            )
          ],
          ////////////////////////////////////////////////
          // -----------> MODERADORES <-----------------//
          ////////////////////////////////////////////////
          if (moderadores.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  listaPonentesConTitulo(context, moderadores, 'Moderadores'),
            )
          ],
          ////////////////////////////////////////////////
          // -----------> PATROCINADORES <--------------//
          ////////////////////////////////////////////////
          if (patrocinadores.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: listaPatrocinadoresConTitulo(
                  context, patrocinadores, 'Patrocinadores'),
            )
          ]
        ],
      ),
    );
  }
}
