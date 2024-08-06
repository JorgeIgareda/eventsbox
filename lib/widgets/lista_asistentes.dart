import 'package:eventsbox/models/asistente.dart';
import 'package:flutter/material.dart';

Widget listaAsistentes(List<Asistente> asistentes) {
  return asistentes.isNotEmpty
      ? ListView.builder(
          itemCount: asistentes.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/asistente',
                    arguments: asistentes[index]),
                child: Column(children: [
                  ListTile(
                    leading: asistentes[index].image.isNotEmpty
                        ? CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                NetworkImage(asistentes[index].image))
                        : CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.blue[900],
                            child: Text(asistentes[index].name[0],
                                style: const TextStyle(color: Colors.white))),
                    title: Text(
                        '${asistentes[index].name} ${asistentes[index].lastName}',
                        style: const TextStyle(fontSize: 15)),
                    subtitle: asistentes[index].company.isNotEmpty
                        ? Text(
                            asistentes[index].company,
                            style: TextStyle(color: Colors.grey[700]),
                          )
                        : null,
                    minVerticalPadding: 0,
                  ),
                  const Divider()
                ]));
          })
      : const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people, size: 150),
              Text('No hay asistentes',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              Text('Todos los asistentes aparecerán aquí')
            ],
          ),
        );
}
