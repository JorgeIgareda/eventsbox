import 'package:eventsbox/globals/global_theme.dart';
import 'package:flutter/material.dart';

Widget accesosDirectos(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 150,
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              childAspectRatio: 0.4,
              scrollDirection: Axis.horizontal,
              children: [
                botonAccesoDirecto(context, 'Información del evento', '/info'),
                botonAccesoDirecto(context, 'Agenda', '/agenda'),
                botonAccesoDirecto(context, 'Ponentes', '/speakers'),
                botonAccesoDirecto(context, 'Patrocinadores', '/sponsors'),
                botonAccesoDirecto(context, 'Canales', '/canales'),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget botonAccesoDirecto(BuildContext context, String texto, String route) {
  return Container(
    margin: EdgeInsets.only(left: 10, right: texto == 'Canales' ?  10 : 0),
    child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: GlobalThemeData.lightThemeData.primaryColor,
            foregroundColor: GlobalThemeData.lightColorScheme.onPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        child: Text(
          texto,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )),
  );
}
