import 'package:eventsbox/globals/global_theme.dart';
import 'package:eventsbox/models/patrocinador.dart';
import 'package:eventsbox/models/ponente.dart';
import 'package:flutter/material.dart';

Widget listaPonentesConTitulo(
    BuildContext context, List<Ponente> lista, String titulo) {
  return Stack(
    children: [
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(width: 1.2, color: Colors.blue.shade900),
            borderRadius: BorderRadius.circular(5)),
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          child: ListView.builder(
              itemCount: lista.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/ponente',
                        arguments: lista[index]);
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Container(
                                height: 40,
                                width: 40,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(lista[index].image),
                                )),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${lista[index].name} ${lista[index].lastName}',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(lista[index].company,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      index < lista.length - 1
                          ? const Divider()
                          : const SizedBox(height: 10)
                    ],
                  ),
                );
              }),
        ),
      ),
      Positioned(
          top: -12,
          left: 30,
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  color: GlobalThemeData.lightColorScheme.onPrimary,
                  child: Text(titulo,
                      style: TextStyle(fontSize: 14, color: Colors.blue[900])))
            ],
          )),
    ],
  );
}

Widget listaPatrocinadoresConTitulo(
    BuildContext context, List<Patrocinador> patrocinadores, String titulo) {
  return Stack(
    children: [
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(width: 1.2, color: Colors.blue.shade900),
            borderRadius: BorderRadius.circular(5)),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 11),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(patrocinadores.length, (index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/patrocinador',
                          arguments: patrocinadores[index]);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: GlobalThemeData.lightColorScheme.onPrimary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(0, 1))
                            ]),
                        child: Image(
                            image: NetworkImage(patrocinadores[index].logo))));
              }),
            )),
      ),
      Positioned(
          top: -12,
          left: 30,
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  color: GlobalThemeData.lightColorScheme.onPrimary,
                  child: Text(titulo,
                      style: TextStyle(fontSize: 14, color: Colors.blue[900]))),
            ],
          )),
    ],
  );
}
