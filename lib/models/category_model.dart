class Category {
  String? id;
  final String readableId;
  final String name;
  final bool hasSize;
  final bool hasColor;

  Category({
    this.id,
    required this.readableId,
    required this.name,
    required this.hasSize,
    required this.hasColor,
  });

  factory Category.fromJson(Map<String, dynamic> json, String docId) {
    return Category(
      id: docId,
      readableId: json['id'],
      name: json['name'],
      hasSize: json['has_size'] ?? false,
      hasColor: json['has_color'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': readableId,
      'name': name,
      'has_size': hasSize,
      'has_color': hasColor,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is Category && id == other.id;
  }

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;

  static Category get allCategoriesValue => Category(
        id: "all-category",
        readableId: "all-category",
        name: "All Category",
        hasSize: false,
        hasColor: false,
      );

  static Category get selectCategoriesValue => Category(
        id: "select-category",
        readableId: "select-category",
        name: "Select Category",
        hasSize: false,
        hasColor: false,
      );

  bool get isDropdownTitle => id == "select-category" || id == "all-category";
}
