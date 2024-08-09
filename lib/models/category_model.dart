class CategoryModel {
  String? id;
  final String readableId;
  final String name;
  final List<String> sizes;
  final List<int> colorHexs;

  CategoryModel({
    this.id,
    required this.readableId,
    required this.name,
    required this.sizes,
    required this.colorHexs,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json, String docId) {
    return CategoryModel(
      id: docId,
      readableId: json['id'],
      name: json['name'],
      sizes:
          json['sizes'] == null ? [] : List.from(json['sizes'].map((x) => x)),
      colorHexs:
          json['colors'] == null ? [] : List.from(json['colors'].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': readableId,
      'name': name,
      'sizes': List.from(sizes.map((x) => x)),
      'colors': List.from(colorHexs.map((x) => x)),
    };
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryModel && id == other.id;
  }

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;

  static CategoryModel get allCategoriesValue => CategoryModel(
        id: "all-category",
        readableId: "all-category",
        name: "All Category",
        sizes: [],
        colorHexs: [],
      );

  static CategoryModel get selectCategoriesValue => CategoryModel(
        id: "select-category",
        readableId: "select-category",
        name: "Select Category",
        sizes: [],
        colorHexs: [],
      );

  bool get isDropdownTitle => id == "select-category" || id == "all-category";
}
