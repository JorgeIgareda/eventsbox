import 'package:eventsbox/database/categorie_sponsor_dao.dart';
import 'package:eventsbox/database/sponsor_dao.dart';
import 'package:eventsbox/globals/globals.dart';
import 'package:eventsbox/models/categoria_patrocinador.dart';
import 'package:eventsbox/models/patrocinador.dart';
import 'package:eventsbox/services/api.dart';
import 'package:eventsbox/widgets/bottom_menu.dart';
import 'package:eventsbox/widgets/hamburger_menu.dart';
import 'package:eventsbox/widgets/lista_patrocinadores.dart';
import 'package:flutter/material.dart';

class PatrocinadoresPage extends StatefulWidget {
  const PatrocinadoresPage({super.key});

  @override
  State<PatrocinadoresPage> createState() => _PatrocinadoresPageState();
}

class _PatrocinadoresPageState extends State<PatrocinadoresPage> {
  late Future<List<Patrocinador>> _listadoPatrocinadores;
  late List<CategoriaPatrocinador> _listadoCategorias;

  final TextEditingController _searchController =
      TextEditingController(text: '');

  bool _search = false;

  @override
  void initState() {
    super.initState();
    _listadoPatrocinadores = _getPatrocinadores();
  }

  Future<List<Patrocinador>> _getPatrocinadores() async {
    _listadoCategorias = Globals.listadoCategoriasSponsorsObtenido
        ? await CategorieSponsorDao().readAll()
        : await Api.getCategoriesSponsors();
    return Globals.listadoSponsorsObtenido
        ? await SponsorDao().readAll()
        : await Api.getSponsors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: !_search
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Patrocinadores'),
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
                                    color: Colors.grey[400], fontSize: 24)))),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _search = false;
                            _searchController.text = '';
                          });
                        },
                        icon: const Icon(Icons.close))
                  ],
                )),
      drawer: const HamburgerMenu(),
      body: FutureBuilder(
          future: _listadoPatrocinadores,
          builder: ((context, snapshot) {
            return search(context, _searchController.text);
          })),
      bottomNavigationBar: const BottomMenu(),
    );
  }

  // Devuelve la lista de patrocinadores que contengan el texto buscado (por defecto todos)
  Widget search(BuildContext context, String query) {
    List<Patrocinador> matchQuery = [];
    return FutureBuilder(
        future: _listadoPatrocinadores,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          for (Patrocinador patrocinador in snapshot.data!) {
            if (patrocinador.name.toLowerCase().contains(query.toLowerCase())) {
              matchQuery.add(patrocinador);
            }
          }
          return listaPatrocinadores(matchQuery, _listadoCategorias);
        }));
  }
}
