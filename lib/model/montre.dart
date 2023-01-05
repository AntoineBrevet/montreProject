class Montre {
  final int id;
  final String title;
  final String image;
  final int price;
  final String description;

  const Montre({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.description,
  });

  factory Montre.fromJson(Map<String, dynamic> json) => Montre(
        id: json['id'],
        title: json['title'],
        image: json['image'],
        price: json['price'],
        description: json['description'],
      );
}
