import 'package:eventsbox/database/image_gallery_dao.dart';
import 'package:eventsbox/globals/globals.dart';
import 'package:eventsbox/models/galeria_imagenes.dart';
import 'package:eventsbox/services/api.dart';
import 'package:eventsbox/widgets/bottom_menu.dart';
import 'package:eventsbox/widgets/hamburger_menu.dart';
import 'package:flutter/material.dart';

class GaleriasImagenesPage extends StatefulWidget {
  const GaleriasImagenesPage({super.key});

  @override
  State<GaleriasImagenesPage> createState() => _GaleriasImagenesPageState();
}

class _GaleriasImagenesPageState extends State<GaleriasImagenesPage> {
  late Future<List<GaleriaImagenes>> _galerias;

  @override
  void initState() {
    super.initState();
    _galerias = Globals.galeriasImagenesObtenido
        ? ImageGalleryDao().readAll()
        : Api.getImagesGallery();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _galerias,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return Scaffold(
              appBar: AppBar(title: const Text('Galería de fotos')),
              drawer: const HamburgerMenu(),
              body: mostrarGalerias(snapshot.data!),
              bottomNavigationBar: const BottomMenu());
        }));
  }

  Widget mostrarGalerias(List<GaleriaImagenes> galerias) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(10),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 0.8,
      children: List.generate(galerias.length, (index) {
        return GestureDetector(
          onTap: () async {
            {
              await Navigator.pushNamed(context, '/galeria_de_imagenes',
                  arguments: galerias[index]);
              setState(() {});
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.transparent, width: 0),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 1))
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: GridView.count(
                      crossAxisCount: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      children: [
                        galerias[index].numPhotos > 0
                            ? Image.network(
                                galerias[index].galleryPhotos[0].thumb,
                                fit: BoxFit.fill)
                            : Container(color: Colors.grey[200]),
                        galerias[index].numPhotos > 1
                            ? Image.network(
                                galerias[index].galleryPhotos[1].thumb,
                                fit: BoxFit.fill)
                            : Container(color: Colors.grey[200]),
                        galerias[index].numPhotos > 2
                            ? Image.network(
                                galerias[index].galleryPhotos[2].thumb,
                                fit: BoxFit.fill)
                            : Container(color: Colors.grey[200]),
                        galerias[index].numPhotos > 3
                            ? Image.network(
                                galerias[index].galleryPhotos[3].thumb,
                                fit: BoxFit.fill)
                            : Container(color: Colors.grey[200]),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(galerias[index].name,
                        overflow: TextOverflow.ellipsis, maxLines: 1))
              ],
            ),
          ),
        );
      }),
    );
  }
}
