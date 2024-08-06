class ItemMenu {
  int id;
  int orden;
  String title;
  String icon;
  String content;
  int social; // 0 = no es red social, 1 = es red social
  int location; // 0 = en drawer, 1 = en bottom navigation bar, 2 = en ambos

  ItemMenu(this.id, this.orden, this.title, this.icon, this.content, this.social, this.location);
  factory ItemMenu.fromJson(Map<String, dynamic> json, int orden) {
    return ItemMenu(
        json['id'] as int,
        orden,
        json['title'] as String,
        json['icon'] as String,
        json['content'] as String,
        json['social'] as int,
        json['location'] as int);
  }

  factory ItemMenu.fromDatabase(Map<String, dynamic> json) {
    return ItemMenu(
        json['id'] as int,
        json['item_order'] as int,
        json['title'] as String,
        json['icon'] as String,
        json['content'] as String,
        json['social'] as int,
        json['location'] as int);
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'item_order': orden,
    'title': title,
    'icon': icon,
    'content': content,
    'social': social,
    'location': location
  };
}
