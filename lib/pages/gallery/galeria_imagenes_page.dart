import 'package:eventsbox/database/attendee_dao.dart';
import 'package:eventsbox/models/asistente.dart';
import 'package:eventsbox/models/galeria_imagenes.dart';
import 'package:eventsbox/models/imagen.dart';
import 'package:eventsbox/routes/imagen_arguments.dart';
import 'package:flutter/material.dart';

class GaleriaImagenesPage extends StatefulWidget {
  final GaleriaImagenes galeria;
  const GaleriaImagenesPage(this.galeria, {super.key});

  @override
  State<GaleriaImagenesPage> createState() => _GaleriaImagenesPageState();
}

class _GaleriaImagenesPageState extends State<GaleriaImagenesPage> {
  late List<Imagen> _fotos;
  late Future<List<Asistente>> _usuarios;
  bool _lista = true;

  @override
  void initState() {
    super.initState();
    _usuarios = AttendeeDao().readAll();
  }

  @override
  Widget build(BuildContext context) {
    _fotos = widget.galeria.galleryPhotos;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => {
                    setState(() {
                      _lista = !_lista;
                    })
                  },
              icon: const Icon(Icons.grid_on)),
          IconButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/upload_image',
                    arguments: widget.galeria);
                setState(() {});
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: _fotos.isNotEmpty
          ? (_lista ? listaImagenes() : gridImagenes())
          : galeriaVacia(),
    )
        // ,
        // )
        ;
  }

  Widget listaImagenes() {
    return FutureBuilder(
        future: _usuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return ListView.builder(
              itemCount: _fotos.length,
              itemBuilder: (BuildContext context, int index) {
                Asistente usuario = snapshot.data!.firstWhere(
                    (asistente) => asistente.id == _fotos[index].user);
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/imagen',
                      arguments: ImagenArguments(_fotos[index], usuario)),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    height: 260,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.transparent, width: 0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 1))
                        ]),
                    child: Column(
                      children: [
                        SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Image.network(_fotos[index].image,
                                fit: BoxFit.fitWidth)),
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  usuario.image.isNotEmpty
                                      ? CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(usuario.image),
                                          radius: 15)
                                      : CircleAvatar(
                                          backgroundColor: Colors.blue[900],
                                          radius: 15,
                                          child: Text(
                                            usuario.name[0],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                  const SizedBox(width: 10),
                                  Text('${usuario.name} ${usuario.lastName}')
                                ],
                              ),
                              Row(
                                children: [
                                  _fotos[index].myLike == 0
                                      ? const Icon(Icons.favorite_border)
                                      : const Icon(Icons.favorite,
                                          color: Colors.red),
                                  const SizedBox(width: 5),
                                  Text(_fotos[index].likes.toString())
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }

  Widget gridImagenes() {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      padding: const EdgeInsets.all(5),
      children: List.generate(_fotos.length, (index) {
        return GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, '/imagen', arguments: _fotos[index]),
          child: Image.network(
            _fotos[index].thumb,
            fit: BoxFit.cover,
          ),
        );
      }),
    );
  }

  Widget galeriaVacia() {
    return const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.image, size: 150),
      Text('Esta galería está vacía',
          style: TextStyle(fontWeight: FontWeight.w500)),
      Text('¿Quieres ser el primero en subir una foto?')
    ]));
  }
}
