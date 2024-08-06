import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:eventsbox/globals/global_theme.dart';
import 'package:eventsbox/models/patrocinador.dart';
import 'package:eventsbox/models/ponente.dart';
import 'package:eventsbox/models/session.dart';
import 'package:eventsbox/models/track.dart';
import 'package:eventsbox/pages/agenda/session_page.dart';
import 'package:flutter/material.dart';

Widget detalleSesion(
    BuildContext context,
    Session sesion,
    List<Track> tracks,
    List<Ponente> moderadores,
    List<Ponente> ponentes,
    List<Patrocinador> patrocinadores) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      ////////////////////////////////////////////////
      // -----------> TÍTULO <---------------------///
      ////////////////////////////////////////////////
      Padding(
        padding: const EdgeInsets.only(top: 10, left: 15, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Detalle de sesión', style: TextStyle(fontSize: 20)),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close, size: 35)),
          ],
        ),
      ),
      const Divider(),
      ////////////////////////////////////////////////
      // -----------> NOMBRE <----------------------//
      ////////////////////////////////////////////////
      ListTile(
          title: Text(sesion.name,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          trailing: Icon(
            Icons.star_border_outlined,
            color: GlobalThemeData.lightThemeData.primaryColor,
            size: 35,
          ),
          dense: true,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4)),
      ////////////////////////////////////////////////
      // -----------> HORARIO <---------------------//
      ////////////////////////////////////////////////
      ListTile(
          title: Text(
              sesion.noEndTime == 0
                  ? '${sesion.timeStart.substring(0, 5)} - ${sesion.timeEnd.substring(0, 5)}'
                  : sesion.timeStart.substring(0, 5),
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          leading: const Icon(Icons.schedule),
          horizontalTitleGap: 5,
          minVerticalPadding: 0,
          dense: true,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4)),
      ///////////////////////////////////////////////////
      // -----------> AÑADIR AL CALENDARIO <-----------//
      ///////////////////////////////////////////////////
      ListTile(
          title: Text('Añadir al calendario',
              style: TextStyle(
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                  color: Colors.grey[600],
                  decorationColor: Colors.grey[600])),
          leading: const Icon(Icons.event),
          horizontalTitleGap: 5,
          minVerticalPadding: 0,
          dense: true,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          onTap: () {
            final Event event = Event(
              title: sesion.name,
              description: '',
              location: sesion.location,
              startDate:
                  DateTime.parse('${sesion.dateStart} ${sesion.timeStart}'),
              endDate: DateTime.parse('${sesion.dateEnd} ${sesion.timeEnd}'),
            );
            Add2Calendar.addEvent2Cal(event);
          }),
      ////////////////////////////////////////////////
      // -----------> TRACKS <----------------------//
      ////////////////////////////////////////////////
      if (tracks.isNotEmpty) ...[
        Container(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          child: Row(
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
                          const EdgeInsets.only(right: 10, top: 5, bottom: 5),
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
          ),
        )
      ],
      /////////////////////////////////////////////////////
      // -----------> BOTÓN ACCEDER A SESIÓN <-----------//
      /////////////////////////////////////////////////////
      Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.23,
              vertical: 20),
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => SessionPage(sesion, tracks,
                            ponentes, moderadores, patrocinadores))));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: GlobalThemeData.lightColorScheme.onPrimary,
                  side: BorderSide(width: 2, color: Colors.blue.shade900),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Colors.blue.shade800)),
                  padding: EdgeInsets.zero),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                title: Text(
                  'Acceder a sesión',
                  style: TextStyle(
                      fontSize: 15,
                      color: GlobalThemeData.lightThemeData.primaryColor),
                ),
                leading: const Icon(Icons.remove_red_eye_outlined),
                iconColor: GlobalThemeData.lightThemeData.primaryColor,
                horizontalTitleGap: 5,
                dense: true,
              ))),
      ////////////////////////////////////////////////
      // -----------> MODERADORES <-----------------//
      ////////////////////////////////////////////////
      if (moderadores.isNotEmpty) ...[
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text('Moderado por',
                style: TextStyle(fontWeight: FontWeight.bold))),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                    itemCount: moderadores.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/ponente',
                              arguments: moderadores[index]);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(moderadores[index].image)),
                                Text(
                                    '${moderadores[index].name} ${moderadores[index].lastName}',
                                    style: const TextStyle(fontSize: 12)),
                                Text(moderadores[index].company,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey))
                              ]),
                        ),
                      );
                    }),
              ),
            ),
          ],
        )
      ],
      ////////////////////////////////////////////////
      // -----------> PONENTES <--------------------//
      ////////////////////////////////////////////////
      if (ponentes.isNotEmpty) ...[
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text('Ponentes',
                style: TextStyle(fontWeight: FontWeight.bold))),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                    itemCount: ponentes.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/ponente',
                              arguments: ponentes[index]);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(ponentes[index].image)),
                                Text(
                                    '${ponentes[index].name} ${ponentes[index].lastName}',
                                    style: const TextStyle(fontSize: 12)),
                                Text(ponentes[index].company,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey))
                              ]),
                        ),
                      );
                    }),
              ),
            ),
          ],
        )
      ],
      ////////////////////////////////////////////////
      // -----------> PATROCINADORES <--------------//
      ////////////////////////////////////////////////
      if (patrocinadores.isNotEmpty) ...[
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text('Patrocinado por',
                style: TextStyle(fontWeight: FontWeight.bold))),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: SizedBox(
              height: 50,
              child: ListView.builder(
                  itemCount: patrocinadores.length,
                  scrollDirection: Axis.horizontal,
                  itemExtent: 120,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/patrocinador',
                            arguments: patrocinadores[index]);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.topCenter,
                          child: Image.network(patrocinadores[index].logo,
                              fit: BoxFit.contain)),
                    );
                  }),
            ))
          ],
        )
      ]
    ],
  );
}
