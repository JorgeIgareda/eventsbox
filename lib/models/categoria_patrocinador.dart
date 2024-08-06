import 'package:intl/intl.dart';

class CategoriaPatrocinador {
  int id;
  String name;
  String color;
  int columns;

  CategoriaPatrocinador(
      {required this.id,
      this.name = '',
      required this.color,
      required this.columns});
  factory CategoriaPatrocinador.fromJson(Map<String, dynamic> json) {
    CategoriaPatrocinador categoria = CategoriaPatrocinador(
        id: json['id'] as int,
        color: json['color'] as String,
        columns: json['columns'] as int);
    if (json.containsKey('content')) {
      int loop = 1;
      for (var x in json['content']) {
        if (loop == 1 || x['lang'] == Intl.getCurrentLocale()) {
          categoria.name = x['name'];
        }
      }
    } else {
      categoria.name = json['name'];
    }

    return categoria;
  }

  Map<String, dynamic> toMap() =>
      {'id': id, 'name': name, 'color': color, 'columns': columns};
}
