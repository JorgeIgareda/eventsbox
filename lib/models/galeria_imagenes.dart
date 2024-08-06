import 'package:eventsbox/models/imagen.dart';

class GaleriaImagenes {
  int id;
  int orden;
  String name;
  String image;
  String thumb;
  String date; // AAAA-MM-DD HH:mm:ss
  int uploadAdmin;
  int numPhotos;
  List<Imagen> galleryPhotos;

  GaleriaImagenes(this.id, this.orden, this.name, this.image, this.thumb,
      this.date, this.uploadAdmin, this.numPhotos, this.galleryPhotos);
  factory GaleriaImagenes.fromJson(Map<String, dynamic> json, int order) {
    List<dynamic> list = json['gallery_photos'] as List;
    int ordenImagenes = 0;
    List<Imagen> imagenes = list
        .map((e) => Imagen.fromJson(e, json['id'] as int, ordenImagenes++))
        .toList();
    return GaleriaImagenes(
        json['id'] as int,
        order,
        json['name'] as String,
        json['image'] as String,
        json['thumb'] as String,
        json['date'] as String,
        json['upload_admin'] as int,
        json['num_photos'] as int,
        imagenes);
  }

  factory GaleriaImagenes.fromDatabase(
      Map<String, dynamic> json, List<Imagen> photos) {
    return GaleriaImagenes(
        json['id'] as int,
        json['item_order'] as int,
        json['name'] as String,
        json['image'] as String,
        json['thumb'] as String,
        json['date'] as String,
        json['upload_admin'] as int,
        json['num_photos'] as int,
        photos);
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'item_order': orden,
        'name': name,
        'image': image,
        'thumb': thumb,
        'date': date,
        'upload_admin': uploadAdmin,
        'num_photos': numPhotos
      };
}
