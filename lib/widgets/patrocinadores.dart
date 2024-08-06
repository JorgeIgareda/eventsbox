import 'package:eventsbox/database/sponsor_dao.dart';
import 'package:eventsbox/globals/globals.dart';
import 'package:eventsbox/models/patrocinador.dart';
import 'package:eventsbox/services/api.dart';
import 'package:flutter/material.dart';

class Patrocinadores extends StatefulWidget {
  const Patrocinadores({super.key});

  @override
  State<Patrocinadores> createState() => _PatrocinadoresState();
}

class _PatrocinadoresState extends State<Patrocinadores> {
  late Future<List<Patrocinador>> _listadoPatrocinadores;

  @override
  void initState() {
    super.initState();
    _listadoPatrocinadores = Globals.listadoSponsorsObtenido
        ? SponsorDao().readAll()
        : Api.getSponsors();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _listadoPatrocinadores,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return noHayPatrocinadores();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return snapshot.data!.isNotEmpty
              ? Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                            height: 170,
                            child: ListView.builder(
                                itemExtent: 260,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                        context, '/patrocinador',
                                        arguments: snapshot.data![index]),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10, right: index == snapshot.data!.length - 1 ? 10 : 0),
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 120,
                                              width: 260,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1,
                                                      style: BorderStyle.solid),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: Image.network(
                                                  snapshot.data![index].logo,
                                                  fit: BoxFit.fill)),
                                          Text(snapshot.data![index].name,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ),
                                  );
                                }))),
                  ],
                )
              : noHayPatrocinadores();
        }));
  }

  Widget noHayPatrocinadores() {
    return Container(
      width: 300,
      height: 150,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey.shade400, width: 1, style: BorderStyle.solid),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: const Text(
        'Próximamente verás los patrocinadores aquí',
        textAlign: TextAlign.center,
      ),
    );
  }
}
