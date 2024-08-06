class Asistente {
  int id;
  int order;
  int registerValidated;
  String name;
  String lastName;
  String image;
  String code;
  String company;
  String position;
  String city;
  String country;
  String web;
  String linkedin;
  String twitter;
  String facebook;
  String behance;
  String youtube;
  String contactMail;

  Asistente(
      this.id,
      this.order,
      this.registerValidated,
      this.name,
      this.lastName,
      this.image,
      this.code,
      this.company,
      this.position,
      this.city,
      this.country,
      this.web,
      this.linkedin,
      this.twitter,
      this.facebook,
      this.behance,
      this.youtube,
      this.contactMail);
  factory Asistente.fromJson(Map<String, dynamic> json) {
    return Asistente(
        json['id'] as int,
        json.containsKey('order')
            ? json['order'] as int
            : json['item_order'] as int,
        json['register_validated'] as int,
        json['name'] as String,
        json['last_name'] as String,
        json['img'] as String,
        json['code'] as String,
        json['company'] as String,
        json['position'] as String,
        json['city'] as String,
        json['country'] as String,
        json['web'] as String,
        json['linkedin'] as String,
        json['twitter'] as String,
        json['facebook'] as String,
        json['behance'] as String,
        json['youtube'] as String,
        json['contactmail'] as String);
  }

  Map<String, dynamic> topMap() => {
        'id': id,
        'item_order': order,
        'register_validated': registerValidated,
        'name': name,
        'last_name': lastName,
        'img': image,
        'code': code,
        'company': company,
        'position': position,
        'city': city,
        'country': country,
        'web': web,
        'linkedin': linkedin,
        'twitter': twitter,
        'facebook': facebook,
        'behance': behance,
        'youtube': youtube,
        'contactmail': contactMail
      };
}
