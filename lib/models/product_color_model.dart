import 'package:apos_app/lib_exp.dart';

class ProductColorModel {
  final String name;
  final int hex;
  bool status;
  ProductColorModel({
    required this.name,
    required this.hex,
    required this.status,
  });

  factory ProductColorModel.clone(ProductColorModel pc) => ProductColorModel(
        name: pc.name,
        hex: pc.hex,
        status: pc.status,
      );

  static List<int> getAllProductColorHexs() {
    return parseProductColorsToHexs(Consts.defaultAllProductColors);
  }

  // Just return the passed data
  static List<int> parseProductColorsToHexs(List<ProductColorModel> colors) {
    return colors.map((ProductColorModel pc) => pc.hex).toList();
  }

  // Just return the passed data
  static List<ProductColorModel> parseHexsToProductColors(
    List<int> hexs, {
    bool defaultStatus = true,
  }) {
    final List<ProductColorModel> colors = [];
    for (int hex in hexs) {
      for (ProductColorModel color in Consts.defaultAllProductColors) {
        if (color.hex == hex) {
          colors.add(ProductColorModel(
            name: color.name,
            hex: hex,
            status: defaultStatus,
          ));
          break;
        }
      }
    }
    return colors;
  }

  // return type will the same as Consts.defaultAllProductColors of length
  static List<ProductColorModel> parseHexsToAllProductColors({
    required List<int> hexs,
    required List<int> oldHexs,
  }) {
    final List<ProductColorModel> result = [];
    final List<ProductColorModel> parsedPc = parseHexsToProductColors(
      hexs,
      defaultStatus: false,
    );

    for (ProductColorModel pc in parsedPc) {
      bool status = false;
      for (int old in oldHexs) {
        if (old == pc.hex) {
          status = true;
          break;
        }
      }
      result.add(ProductColorModel(name: pc.name, hex: pc.hex, status: status));
    }
    // colors.length will the same as Consts.defaultAllProductColors of length
    return result;
  }
}
