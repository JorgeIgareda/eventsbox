import 'package:eventsbox/database/categorie_sponsor_dao.dart';
import 'package:eventsbox/globals/globals.dart';
import 'package:eventsbox/models/categoria_patrocinador.dart';
import 'package:eventsbox/models/patrocinador.dart';
import 'package:eventsbox/services/api.dart';
import 'package:eventsbox/widgets/categoria_patrocinador.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PatrocinadorPage extends StatefulWidget {
  final Patrocinador patrocinador;
  const PatrocinadorPage(this.patrocinador, {super.key});

  @override
  State<PatrocinadorPage> createState() => _PatrocinadorPageState();
}

class _PatrocinadorPageState extends State<PatrocinadorPage> {
  late Future<List<CategoriaPatrocinador>> _categorias;

  @override
  void initState() {
    super.initState();
    _getCategoria();
  }

  void _getCategoria() async {
    Globals.listadoCategoriasSponsorsObtenido
        ? _categorias = CategorieSponsorDao().readAll()
        : _categorias = Api.getCategoriesSponsors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<CategoriaPatrocinador>>(
        future: _categorias,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          List<CategoriaPatrocinador> categorias = <CategoriaPatrocinador>[];
          for (CategoriaPatrocinador categoria in snapshot.data!) {
            if (categoria.id == widget.patrocinador.category) {
              categorias.add(categoria);
            }
          }
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Categorías'),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 25,
                          child: ListView.builder(
                              itemCount: categorias.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return categoriaPatrocinador(context,
                                    categorias[index].name, 0xFFFFFFFF);
                              }),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.all(30),
                      child:
                          Image(image: NetworkImage(widget.patrocinador.logo))),
                  Column(
                    children: [
                      Text(widget.patrocinador.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.patrocinador.linkedin.isNotEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(5),
                                  child: GestureDetector(
                                      onTap: () async {
                                        if (!await launchUrl(Uri.parse(
                                            widget.patrocinador.linkedin))) {
                                          throw Exception(
                                              'No se pudo abrir ${widget.patrocinador.linkedin}');
                                        }
                                      },
                                      child: const CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://upload.wikimedia.org/wikipedia/commons/thumb/8/81/LinkedIn_icon.svg/2048px-LinkedIn_icon.svg.png'))),
                                )
                              : const SizedBox(),
                          widget.patrocinador.twitter.isNotEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(5),
                                  child: GestureDetector(
                                      onTap: () async {
                                        if (!await launchUrl(Uri.parse(
                                            widget.patrocinador.twitter))) {
                                          throw Exception(
                                              'No se pudo abrir ${widget.patrocinador.twitter}');
                                        }
                                      },
                                      child: const CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://upload.wikimedia.org/wikipedia/commons/9/95/Twitter_new_X_logo.png'))),
                                )
                              : const SizedBox(),
                          widget.patrocinador.facebook.isNotEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(5),
                                  child: GestureDetector(
                                      onTap: () async {
                                        if (!await launchUrl(Uri.parse(
                                            widget.patrocinador.facebook))) {
                                          throw Exception(
                                              'No se pudo abrir ${widget.patrocinador.facebook}');
                                        }
                                      },
                                      child: const CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Facebook_logo_36x36.svg/2048px-Facebook_logo_36x36.svg.png'))),
                                )
                              : const SizedBox(),
                          widget.patrocinador.instagram.isNotEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(5),
                                  child: GestureDetector(
                                      onTap: () async {
                                        if (!await launchUrl(Uri.parse(
                                            widget.patrocinador.instagram))) {
                                          throw Exception(
                                              'No se pudo abrir ${widget.patrocinador.instagram}');
                                        }
                                      },
                                      child: const CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Instagram_icon.png/2048px-Instagram_icon.png'))),
                                )
                              : const SizedBox(),
                          widget.patrocinador.youtube.isNotEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(5),
                                  child: GestureDetector(
                                      onTap: () async {
                                        if (!await launchUrl(Uri.parse(
                                            widget.patrocinador.youtube))) {
                                          throw Exception(
                                              'No se pudo abrir ${widget.patrocinador.youtube}');
                                        }
                                      },
                                      child: const CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://i.pinimg.com/474x/a9/0f/83/a90f83a941ea1ec50803406f50512e93.jpg'))),
                                )
                              : const SizedBox(),
                          widget.patrocinador.web.isNotEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(5),
                                  child: GestureDetector(
                                      onTap: () async {
                                        if (!await launchUrl(Uri.parse(
                                            widget.patrocinador.web))) {
                                          throw Exception(
                                              'No se pudo abrir ${widget.patrocinador.web}');
                                        }
                                      },
                                      child: const CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://static.vecteezy.com/system/resources/previews/026/221/538/original/internet-icon-symbol-design-illustration-vector.jpg'))),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
