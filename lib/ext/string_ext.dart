extension StringExt on String {
  String get slugify => toUpperCase().replaceAll(' ', '-').replaceAll(
        RegExp(r'[^A-Z0-9\-]'),
        '',
      );
      
}
