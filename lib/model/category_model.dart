// class Category {
//   final int id;
//   final String name;
//   final String code;

//   Category({required this.id, required this.name, required this.code});

//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
//       name: json['name'] ?? 'No Name',
//       code: json['code'] ?? '',
//     );
//   }

//   static Category findCategoryByName(
//     List<Category> categories,
//     String namePattern,
//   ) {
//     return categories.firstWhere(
//       (category) =>
//           category.name.toLowerCase().contains(namePattern.toLowerCase()),
//       orElse: () => Category(id: 0, name: '', code: ''),
//     );
//   }
// }


class Category {
  final int id;
  final String name;
  final String code;

  Category({required this.id, required this.name, required this.code});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? 'No Name',
      code: json['code'] ?? '',
    );
  }
}