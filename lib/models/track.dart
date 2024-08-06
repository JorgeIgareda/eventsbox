class Track {
  int id;
  String name;
  String color;

  Track(this.id, this.name, this.color);

  factory Track.fromJson(Map<String, dynamic> json) {
    Track track = Track(
        json["id"] as int, json["name"] as String, json["color"] as String);
    return track;
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'color': color
  };
}
