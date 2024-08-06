class HomeModule {
  int id;
  int order;
  String module;
  int appVisible; // 0 si no se muestra en home, 0 si se muestra
  int hiddenTitle; // 0 si se oculta el titulo, 1 si se muestra el titulo
  String title;

  HomeModule(
      {required this.id,
      required this.order,
      required this.module,
      required this.appVisible,
      required this.hiddenTitle,
      this.title = ''});
  factory HomeModule.fromJson(Map<String, dynamic> json, int order) {
    HomeModule modulo = HomeModule(
        id: json['id_module'] as int,
        order: order,
        module: json['module'] as String,
        appVisible: json['app_visible'] as int,
        hiddenTitle: json['hidden_title'] as int);
    if (json.containsKey('content')) {
      for (var x in json['content']) {
        if (x['lang'] == 'es') {
          modulo.title = x['title'];
        }
      }
    } else {
      modulo.title = json['title'];
    }
    return modulo;
  }

  factory HomeModule.fromDatabase(Map<String, dynamic> json) => HomeModule(
      id: json['id_module'] as int,
      order: json['item_order'] as int,
      module: json['module'] as String,
      appVisible: json['app_visible'] as int,
      hiddenTitle: json['hidden_title'] as int,
      title: json['title'] as String);

  Map<String, dynamic> toMap() => {
        'id_module': id,
        'item_order': order,
        'module': module,
        'app_visible': appVisible,
        'hidden_title': hiddenTitle,
        'title': title
      };
}
