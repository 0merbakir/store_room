class StoreRoom {
  final String id;
  final String roomId;
  final String space;

  StoreRoom({
    required this.id,
    required this.roomId,
    required this.space,
  });

  // Deserialize JSON to StoreRoom object
  factory StoreRoom.fromJson(Map<String, dynamic> json) {
    return StoreRoom(
      id: json['id'],
      roomId: json['roomId'],
      space: json['space'],
    );
  }

  // Serialize StoreRoom object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'space': space,
    };
  }
}
