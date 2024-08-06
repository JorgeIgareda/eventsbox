import 'package:eventsbox/database/speaker_dao.dart';
import 'package:eventsbox/globals/globals.dart';
import 'package:eventsbox/models/ponente.dart';
import 'package:eventsbox/services/api.dart';
import 'package:flutter/material.dart';

class Ponentes extends StatefulWidget {
  const Ponentes({super.key});

  @override
  State<Ponentes> createState() => _PonentesState();
}

class _PonentesState extends State<Ponentes> {
  late Future<List<Ponente>> _listadoPonentes;

  @override
  void initState() {
    super.initState();
    _listadoPonentes = Globals.listadoPonentesObtenido
        ? SpeakerDao().readAll()
        : Api.getListadoPonentes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Ponente>>(
        future: _listadoPonentes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return noHayPonentes();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return snapshot.data!.isNotEmpty
              ? Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 300,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                                                    if (index == snapshot.data!.length) {
                          return const SizedBox(width: 10); // Espacio extra al final
                        }
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/ponente',
                                    arguments: snapshot.data![index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: 250,
                                          width: 170,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Image.network(
                                              snapshot.data![index].image,
                                              fit: BoxFit.cover)),
                                      Text(
                                          '${snapshot.data![index].name} ${snapshot.data![index].lastName}',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                      Text(snapshot.data![index].company,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 10))
                                    ]),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : noHayPonentes();
        });
  }

  Widget noHayPonentes() {
    return Container(
      width: 160,
      height: 280,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey.shade400, width: 1, style: BorderStyle.solid),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: const Text(
        'Próximamente verás los ponentes aquí',
        textAlign: TextAlign.center,
      ),
    );
  }
}
