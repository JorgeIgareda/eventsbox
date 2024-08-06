import 'package:eventsbox/globals/global_theme.dart';
import 'package:eventsbox/models/session.dart';
import 'package:flutter/material.dart';

class InfoSesion extends StatefulWidget {
  final Session sesion;
  final String moderadores;
  final String ponentes;
  const InfoSesion(this.sesion, this.moderadores, this.ponentes, {super.key});

  @override
  State<InfoSesion> createState() => _InfoSesionState();
}

class _InfoSesionState extends State<InfoSesion> {
  bool _isToggled = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        padding: const EdgeInsets.all(5),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(stops: const [
              0.025,
              0.025
            ], colors: [
              Colors.blue.shade800,
              GlobalThemeData.lightColorScheme.onPrimary
            ]),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 1))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ////////////////////////////////////////////////
            // -----------> NOMBRE <----------------------//
            ////////////////////////////////////////////////
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.sesion.name,
                      style: const TextStyle(fontSize: 15)),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isToggled = !_isToggled;
                      });
                    },
                    child: Icon(_isToggled ? Icons.star : Icons.star_border,
                        size: 30,
                        color: GlobalThemeData.lightThemeData.primaryColor),
                  )
                ],
              ),
            ),
            ////////////////////////////////////////////////
            // -----------> HORARIO <---------------------//
            ////////////////////////////////////////////////
            ListTile(
                title: Text(
                    widget.sesion.noEndTime == 0
                        ? '${widget.sesion.timeStart.substring(0, 5)} - ${widget.sesion.timeEnd.substring(0, 5)}'
                        : widget.sesion.timeStart.substring(0, 5),
                    style: const TextStyle(fontSize: 12)),
                leading: const Icon(Icons.schedule),
                horizontalTitleGap: 5,
                minVerticalPadding: 0,
                dense: true,
                visualDensity:
                    const VisualDensity(horizontal: 0, vertical: -4)),
            ////////////////////////////////////////////////
            // -----------> MODERADORES <-----------------//
            ////////////////////////////////////////////////
            widget.moderadores.isNotEmpty
                ? ListTile(
                    title: Text(widget.moderadores,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    leading: const Icon(Icons.security),
                    horizontalTitleGap: 5,
                    minVerticalPadding: 0,
                    dense: true,
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4))
                : const SizedBox(),
            ////////////////////////////////////////////////
            // -----------> PONENTES <--------------------//
            ////////////////////////////////////////////////
            widget.ponentes.isNotEmpty
                ? ListTile(
                    title: Text(widget.ponentes,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    leading: const Icon(Icons.mic),
                    horizontalTitleGap: 5,
                    minVerticalPadding: 0,
                    dense: true,
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4))
                : const SizedBox(),
          ],
        ));
  }
}
