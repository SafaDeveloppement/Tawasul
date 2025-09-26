

class Category {
  final int id;
  final String name;
  final String? link;
  final String? imageUrl;
  final List<Category> children;

  Category({
    required this.id,
    required this.name,
    this.link,
    this.imageUrl,
    required this.children,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id_category'] ?? 0,
      name: json['name'] ?? '',
      link: json['link'],
      imageUrl: json['image_url'],
      children: (json['children'] as List<dynamic>?)
          ?.map((child) => Category.fromJson(child))
          .toList() ?? [],
    );
  }

  // Helper method to get all subcategory IDs including self
  List<int> getAllCategoryIds() {
    List<int> ids = [id];
    for (var child in children) {
      ids.addAll(child.getAllCategoryIds());
    }
    return ids;
  }
   List<int> getLeafCategoryIds() {
    List<int> ids = [];
    
    if (children.isEmpty) {
      // This is a leaf category
      ids.add(id);
    } else {
      // Recursively get leaf IDs from children
      for (var child in children) {
        ids.addAll(child.getLeafCategoryIds());
      }
    }
    
    return ids;
  }



}