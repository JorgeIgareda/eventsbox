import 'package:eventsbox/database/attendee_dao.dart';
import 'package:eventsbox/models/asistente.dart';
import 'package:eventsbox/widgets/bottom_menu.dart';
import 'package:eventsbox/widgets/hamburger_menu.dart';
import 'package:eventsbox/widgets/lista_asistentes.dart';
import 'package:flutter/material.dart';

class AsistentesPage extends StatefulWidget {
  const AsistentesPage({super.key});

  @override
  State<AsistentesPage> createState() => _AsistentesPageState();
}

class _AsistentesPageState extends State<AsistentesPage> {
  late Future<List<Asistente>> _listadoAsistentes;

  final TextEditingController _searchController =
      TextEditingController(text: '');

  bool _search = false;
  int tipoOrden = 0;
  @override
  void initState() {
    super.initState();
    _listadoAsistentes = AttendeeDao().readAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HamburgerMenu(),
      appBar: AppBar(
          title: !_search
              ? const Text('Explorar')
              : TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  decoration: InputDecoration(
                      hintText: 'Buscar...',
                      border: InputBorder.none,
                      hintStyle:
                          TextStyle(color: Colors.grey[400], fontSize: 24))),
          actions: !_search
              ? [
                  IconButton(
                    onPressed: () => setState(() {
                      _searchController.addListener(() {
                        setState(() {
                          search(_searchController.text);
                        });
                      });
                      _search = true;
                    }),
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                            context, '/ordenar_asistentes');
                        if (result != null) {
                          setState(() {
                            tipoOrden = result as int;
                          });
                        }
                      },
                      icon: const Icon(Icons.filter_list))
                ]
              : [
                  IconButton(
                      onPressed: () => setState(() {
                            _search = false;
                            _searchController.text = '';
                          }),
                      icon: const Icon(Icons.close)),
                ]),
      body: search(_searchController.text),
      bottomNavigationBar: const BottomMenu(),
    );
  }

  Widget search(String query) {
    List<Asistente> matchQuery = [];
    return FutureBuilder(
        future: _listadoAsistentes,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          for (Asistente asistente in snapshot.data!) {
            if ('${asistente.name.toLowerCase()} ${asistente.lastName.toLowerCase()}'
                .contains(query.toLowerCase())) {
              matchQuery.add(asistente);
            }
          }

          return Container(
              child: listaAsistentes(ordenarAsistentes(matchQuery, tipoOrden)));
        }));
  }

  /// Ordena la lista de asistentes segun el orden que se le pase como parámetro
  /// 0 = Recientes
  /// 1 = Nombre
  /// 2 = Apellidos
  List<Asistente> ordenarAsistentes(List<Asistente> asistentes, int orden) {
    switch (orden) {
      case 0:
        asistentes.sort((a, b) => a.order.compareTo(b.order));
        break;
      case 1:
        asistentes.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case 2:
        asistentes.sort((a, b) =>
            a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase()));
    }
    return asistentes;
  }
}
