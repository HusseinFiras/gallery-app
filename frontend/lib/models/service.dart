class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;
  final String categoryId;
  final String imagePath; // Added image path

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.categoryId,
    required this.imagePath,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      durationMinutes: json['durationMinutes'] as int,
      categoryId: json['categoryId'] as String,
      imagePath: json['imagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'durationMinutes': durationMinutes,
      'categoryId': categoryId,
      'imagePath': imagePath,
    };
  }
}