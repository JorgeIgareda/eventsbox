class Imagen {
  int id;
  int orden;
  int user;
  String image;
  String thumb;
  String description;
  int likes;
  int myLike;
  int galleryId;

  Imagen(this.id, this.orden, this.user, this.image, this.thumb,
      this.description, this.likes, this.myLike, this.galleryId);
  factory Imagen.fromJson(Map<String, dynamic> json, int galleryId, int order) {
    return Imagen(
        json['id'] as int,
        order,
        json['user'] as int,
        json['image'] as String,
        json['thumb'] as String,
        json['description'] as String,
        json.containsKey('likes') ? json['likes'] as int : 0,
        json.containsKey('my_like') ? json['my_like'] as int : 0,
        galleryId);
  }

  factory Imagen.fromDatabase(Map<String, dynamic> json) {
    return Imagen(
        json['id'] as int,
        json['item_order'] as int,
        json['user'] as int,
        json['image'] as String,
        json['thumb'] as String,
        json['description'] as String,
        json['likes'] as int,
        json['my_like'] as int,
        json['gallery_id'] as int);
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'item_order': orden,
        'user': user,
        'image': image,
        'thumb': thumb,
        'description': description,
        'likes': likes,
        'my_like': myLike,
        'gallery_id': galleryId
      };
}
