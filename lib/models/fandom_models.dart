// this is for each card that is like a page for each anime etc
class FandomModels {
  final String id;
  final String name;
  final String description;
  final String image;
  final String category;

  const FandomModels({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
  });

  factory FandomModels.fromFirestore(
      String documentId,
      Map<String, dynamic> data,
      ) {
    return FandomModels(
      id: documentId,
      name: data['name']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      image: data['image']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'category': category,
    };
  }
}