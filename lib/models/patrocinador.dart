class Patrocinador {
  int id;
  String name;
  String web;
  String mail;
  String phone;
  String linkedin;
  String twitter;
  String facebook;
  String instagram;
  String youtube;
  int category;
  int exhibitor;
  String logo;
  String banner;

  Patrocinador(
      this.id,
      this.name,
      this.web,
      this.mail,
      this.phone,
      this.linkedin,
      this.twitter,
      this.facebook,
      this.instagram,
      this.youtube,
      this.category,
      this.exhibitor,
      this.logo,
      this.banner);
  factory Patrocinador.fromJson(Map<String, dynamic> json) {
    return Patrocinador(
        json["id"] as int,
        json["name"] as String,
        json["web"] as String,
        json["mail"] as String,
        json["phone"] as String,
        json["linkedin"] as String,
        json["twitter"] as String,
        json["facebook"] as String,
        json["instagram"] as String,
        json["youtube"] as String,
        json["category"] as int,
        json["exhibitor"] as int,
        json["logo"] as String,
        json["banner"] as String);
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'web': web,
        'mail': mail,
        'phone': phone,
        'linkedin': linkedin,
        'twitter': twitter,
        'facebook': facebook,
        'instagram': instagram,
        'youtube': youtube,
        'category': category,
        'exhibitor': exhibitor,
        'logo': logo,
        'banner': banner
      };
}
