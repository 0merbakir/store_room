class StoreRoom {
  final String id;
  final String title;
  final fillRate;

  //final String status;

  StoreRoom({
    required this.id,
    required this.title,
    this.fillRate
  });

  // Deserialize JSON to StoreRoom object
  factory StoreRoom.fromJson(Map<String, dynamic> json) {
    return StoreRoom(
      id: json['id'],
      title: json['title'],
      fillRate: json['fillRate']
    );
  }

  // Serialize StoreRoom object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'fillRate':fillRate
    };
  }
}
