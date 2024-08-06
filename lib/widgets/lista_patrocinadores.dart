import 'package:eventsbox/globals/global_theme.dart';
import 'package:eventsbox/models/categoria_patrocinador.dart';
import 'package:eventsbox/models/patrocinador.dart';
import 'package:flutter/material.dart';

Widget listaPatrocinadores(
    List<Patrocinador> patrocinadores, List<CategoriaPatrocinador> categorias) {
  if (patrocinadores.isNotEmpty) {
    return ListView.builder(
        itemCount: categorias.length,
        itemBuilder: (BuildContext context, int i) {
          List<Patrocinador> patrocinadoresEnCategoria = <Patrocinador>[];
          for (Patrocinador patrocinador in patrocinadores) {
            if (categorias[i].id == patrocinador.category) {
              patrocinadoresEnCategoria.add(patrocinador);
            }
          }
          return patrocinadoresEnCategoria.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(categorias[i].name,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700]))),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: patrocinadoresEnCategoria.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int j) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/patrocinador',
                                  arguments: patrocinadoresEnCategoria[j]);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: GlobalThemeData
                                      .lightColorScheme.onPrimary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 5,
                                        offset: const Offset(0, 1))
                                  ]),
                              child: Image(
                                  image: NetworkImage(
                                      patrocinadoresEnCategoria[j].logo)),
                            ),
                          );
                        })
                  ],
                )
              : const SizedBox();
        });
  } else {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flag, size: 150),
          Text('No hay patrocinadores',
              style: TextStyle(fontWeight: FontWeight.w500)),
          Text('Todos los patrocinadores aparecerán aquí')
        ],
      ),
    );
  }
}
