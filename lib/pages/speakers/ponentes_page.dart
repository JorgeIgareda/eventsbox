import 'package:eventsbox/database/speaker_dao.dart';
import 'package:eventsbox/globals/globals.dart';
import 'package:eventsbox/models/ponente.dart';
import 'package:eventsbox/services/api.dart';
import 'package:eventsbox/widgets/bottom_menu.dart';
import 'package:eventsbox/widgets/hamburger_menu.dart';
import 'package:eventsbox/widgets/lista_ponentes.dart';
import 'package:flutter/material.dart';

class PonentesPage extends StatefulWidget {
  const PonentesPage({super.key});

  @override
  State<PonentesPage> createState() => _PonentesPageState();
}

class _PonentesPageState extends State<PonentesPage> {
  late Future<List<Ponente>> _listadoPonentes;

  final TextEditingController _searchController =
      TextEditingController(text: '');

  bool _search = false;

  @override
  void initState() {
    super.initState();
    _listadoPonentes = Globals.listadoPonentesObtenido
        ? SpeakerDao().readAll()
        : Api.getListadoPonentes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const HamburgerMenu(),
        appBar: AppBar(
            title: !_search
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ponentes'),
                      IconButton(
                          onPressed: () {
                            _searchController.addListener(() {
                              setState(() {
                                search(context, _searchController.text);
                              });
                            });
                            setState(() {
                              _search = true;
                            });
                          },
                          icon: const Icon(Icons.search))
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 136,
                            child: TextField(
                                controller: _searchController,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 24),
                                decoration: InputDecoration(
                                    hintText: 'Buscar...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 24)))),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _search = false;
                                _searchController.text = '';
                              });
                            },
                            icon: const Icon(Icons.close))
                      ])),
        body: search(context, _searchController.text),
        bottomNavigationBar: const BottomMenu());
  }

  // Devuelve la lista de ponentes que contengan el texto buscado (por defecto todos)
  Widget search(BuildContext context, String query) {
    List<Ponente> matchQuery = [];
    return FutureBuilder(
        future: _listadoPonentes,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          for (Ponente ponente in snapshot.data!) {
            if ('${ponente.name.toLowerCase()} ${ponente.lastName.toLowerCase()}'
                .contains(query.toLowerCase())) {
              matchQuery.add(ponente);
            }
          }
          return Container(
              padding: const EdgeInsets.all(20),
              child: listaPonentes(matchQuery));
        }));
  }
}
