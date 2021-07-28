class Reviews {
  String? id, name, image, message;
  dynamic timestamp;

  Reviews({this.id, this.name, this.image, this.message, this.timestamp});

  factory Reviews.fromFirestore(Map<String, dynamic> data) {
    return Reviews(
        id: data['id'],
        name: data['name'],
        image: data['image'],
        message: data['message'],
        timestamp: data['timestamp']);
  }

  Map<String, dynamic> reviewToMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'message': message,
      'timestamp': timestamp
    };
  }
}
