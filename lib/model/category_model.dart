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
    // Debug logging to see what we're receiving
    print('=== PARSING CATEGORY JSON ===');
    print('Raw JSON: $json');
    print('id_category type: ${json['id_category']?.runtimeType}');
    print('id_category value: ${json['id_category']}');
    print('name: ${json['name']}');

    // Parse ID - handle different possible types
    int parseCategoryId(dynamic idValue) {
      if (idValue == null) {
        print('⚠️ Category ID is null, returning 0');
        return 0;
      }
      
      if (idValue is int) {
        return idValue;
      }
      
      if (idValue is String) {
        final parsed = int.tryParse(idValue);
        if (parsed != null) {
          return parsed;
        } else {
          print('⚠️ Failed to parse category ID from string: "$idValue"');
          return 0;
        }
      }
      
      print('⚠️ Unexpected type for category ID: ${idValue.runtimeType}');
      return 0;
    }

    // Parse children recursively
    List<Category> parseChildren(List<dynamic>? childrenJson) {
      if (childrenJson == null) {
        return [];
      }
      
      final List<Category> children = [];
      for (var child in childrenJson) {
        if (child is Map<String, dynamic>) {
          try {
            children.add(Category.fromJson(child));
          } catch (e) {
            print('⚠️ Error parsing child category: $e');
          }
        }
      }
      return children;
    }

    final categoryId = parseCategoryId(json['id_category']);
    final categoryName = json['name']?.toString() ?? 'Unnamed Category';
    
    if (categoryId == 0) {
      print('⚠️ Category has invalid ID: $json');
    }

    return Category(
      id: categoryId,
      name: categoryName,
      link: json['link']?.toString(),
      imageUrl: json['image_url']?.toString(),
      children: parseChildren(json['children'] as List<dynamic>?),
    );
  }

  // Convert to map for debugging
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'link': link,
      'imageUrl': imageUrl,
      'children': children.map((child) => child.toJson()).toList(),
    };
  }

  // Helper method to get all subcategory IDs including self
  List<int> getAllCategoryIds() {
    List<int> ids = [id];
    for (var child in children) {
      ids.addAll(child.getAllCategoryIds());
    }
    return ids;
  }

  // Get only leaf category IDs (categories with no children)
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

  // Find a category by ID in the hierarchy
  Category? findCategoryById(int targetId) {
    if (id == targetId) {
      return this;
    }
    
    for (var child in children) {
      final found = child.findCategoryById(targetId);
      if (found != null) {
        return found;
      }
    }
    
    return null;
  }

  // Get the full category path (breadcrumb)
  List<String> getCategoryPath() {
    return _getCategoryPath([]);
  }

  List<String> _getCategoryPath(List<String> path) {
    path.insert(0, name);
    return path;
  }

  // Get all parent categories (useful for breadcrumbs)
  List<Category> getParentCategories(List<Category> allCategories) {
    return _findParentCategories(this, allCategories, []);
  }

  List<Category> _findParentCategories(Category target, List<Category> categories, List<Category> path) {
    for (var category in categories) {
      if (category.id == target.id) {
        return path;
      }
      
      // Check if target is in children
      if (category.findCategoryById(target.id) != null) {
        final newPath = List<Category>.from(path)..add(category);
        return _findParentCategories(target, category.children, newPath);
      }
    }
    return path;
  }

  // Debug method to print category tree
  void printTree([String indent = '']) {
    print('$indent$name (ID: $id)');
    for (var child in children) {
      child.printTree('$indent  ');
    }
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, children: ${children.length}}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// Helper class for category-related utilities
class CategoryUtils {
  // Flatten all categories into a single list
  static List<Category> flattenCategories(List<Category> categories) {
    final List<Category> flattened = [];
    
    void flatten(Category category) {
      flattened.add(category);
      for (var child in category.children) {
        flatten(child);
      }
    }
    
    for (var category in categories) {
      flatten(category);
    }
    
    return flattened;
  }

  // Find category by name (case-insensitive)
  static Category? findCategoryByName(List<Category> categories, String name) {
    for (var category in categories) {
      if (category.name.toLowerCase() == name.toLowerCase()) {
        return category;
      }
      
      final foundInChildren = findCategoryByName(category.children, name);
      if (foundInChildren != null) {
        return foundInChildren;
      }
    }
    
    return null;
  }

  // Get all category IDs from a list of categories
  static List<int> getAllCategoryIdsFromList(List<Category> categories) {
    final List<int> ids = [];
    for (var category in categories) {
      ids.addAll(category.getAllCategoryIds());
    }
    return ids;
  }
}