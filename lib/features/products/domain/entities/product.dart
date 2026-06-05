class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String imageUrl;
  final bool available;
  final int categoryId;

  const Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.imageUrl,
    required this.available,
    required this.categoryId,
  });
}