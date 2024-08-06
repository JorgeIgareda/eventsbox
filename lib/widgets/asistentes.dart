import 'package:eventsbox/database/attendee_dao.dart';
import 'package:eventsbox/models/asistente.dart';
import 'package:flutter/material.dart';

class Asistentes extends StatefulWidget {
  const Asistentes({super.key});

  @override
  State<Asistentes> createState() => _AsistentesState();
}

class _AsistentesState extends State<Asistentes> {
  late Future<List<Asistente>> _asistentes;

  @override
  void initState() {
    super.initState();
    _asistentes = AttendeeDao().readAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _asistentes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return noHayAsistentes();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return snapshot.data!.isNotEmpty
              ? Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                          itemExtent: 160,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () => {
                                Navigator.pushNamed(context, '/asistente', arguments: snapshot.data![index])
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Column(
                                  children: [
                                    snapshot.data![index].image.isNotEmpty
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                snapshot.data![index].image),
                                            radius: 65)
                                        : CircleAvatar(
                                            radius: 65,
                                            backgroundColor: Colors.blue[900],
                                            child: Text(
                                                snapshot.data![index].name[0],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25))),
                                    const SizedBox(height: 10),
                                    Text(
                                        '${snapshot.data![index].name} ${snapshot.data![index].lastName}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis),
                                    Text(
                                      snapshot.data![index].company,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ))
                  ],
                )
              : noHayAsistentes();
        });
  }

  Widget noHayAsistentes() {
    return Container(
      width: 160,
      height: 280,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey.shade400, width: 1, style: BorderStyle.solid),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: const Text(
        'Próximamente verás los asistentes aquí',
        textAlign: TextAlign.center,
      ),
    );
  }
}
