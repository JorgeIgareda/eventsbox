import 'package:intl/intl.dart';

class Ponente {
  int id;
  String name;
  String lastName;
  String image;
  String company;
  String position;
  String description;
  String city;

  Ponente(
      {required this.id,
      required this.name,
      required this.lastName,
      required this.image,
      required this.company,
      this.position = '',
      this.description = '',
      required this.city});
  factory Ponente.fromJson(Map<String, dynamic> json) {
    Ponente ponente = Ponente(
        id: json["id"] as int,
        name: json["name"] as String,
        lastName: json["last_name"] as String,
        image: json["image"] as String,
        company: json["company"] as String,
        city: json["city"] as String);

    if (json.containsKey("content")) {
      int loop = 1;
      for (var x in json["content"]) {
        if (loop == 1 || x["lang"] == Intl.getCurrentLocale()) {
          ponente.position = x["position"];
          ponente.description = x["description"];
        }
      }
    } else {
      ponente.position = json["position"];
      ponente.description = json["description"];
    }
    return ponente;
  }

  Ponente copyWith(
      {int? id,
      String? name,
      String? lastName,
      String? image,
      String? company,
      String? position,
      String? description,
      String? city}) {
    return Ponente(
        id: id ?? this.id,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        image: image ?? this.image,
        company: company ?? this.company,
        position: position ?? this.position,
        description: description ?? this.description,
        city: city ?? this.city);
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'last_name': lastName,
        'image': image,
        'company': company,
        'position': position,
        'description': description,
        'city': city,
      };
}
