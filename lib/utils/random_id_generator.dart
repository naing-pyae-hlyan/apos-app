import 'dart:math';
import 'package:apos_app/lib_exp.dart';

class RandomIdGenerator {
  static String generateRandomString(int length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

  static String generateRandomDigits(int length) {
    const digits = '0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => digits.codeUnitAt(random.nextInt(digits.length))));
  }

  static String generateUniqueId() {
    String randomLetters = generateRandomString(3); // 3 random letters
    String randomDigits = generateRandomDigits(4); // 4 random digits
    return ("$randomLetters $randomDigits").slugify; // ABC-1234
  }

  static String getnerateCategoryUniqueId() {
    String uniqueId = "";
    bool isUnique = false;
    while (!isUnique) {
      uniqueId = generateUniqueId();
      var result = CacheManager.categories.where((CategoryModel category) {
        return category.readableId == uniqueId;
      });

      if (result.isEmpty) {
        isUnique = true;
      }
    }
    return uniqueId;
  }

  static String getnerateProductUniqueId() {
    String uniqueId = "";
    bool isUnique = false;
    while (!isUnique) {
      uniqueId = generateUniqueId();
      var result = CacheManager.products.where((ProductModel product) {
        return product.readableId == uniqueId;
      });

      if (result.isEmpty) {
        isUnique = true;
      }
    }
    return uniqueId;
  }
}
