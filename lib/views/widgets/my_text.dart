import 'package:apos_app/lib_exp.dart';

Text myText(
  String? text, {
  int maxLines = 2,
  double fontSize = 13.0,
  Color color = Consts.primaryFontColor,
  FontWeight? fontWeight,
  TextAlign textAlign = TextAlign.start,
  double? letterSpacing,
}) =>
    Text(
      text ?? '',
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w500,
        letterSpacing: letterSpacing,
      ),
      textScaler: TextScaler.noScaling,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      textAlign: textAlign,
    );

Text myTitle(
  String? text, {
  int maxLines = 2,
  double fontSize = 16.0,
  Color color = Consts.primaryFontColor,
  FontWeight? fontWeight,
  TextAlign textAlign = TextAlign.start,
  double? letterSpacing,
}) =>
    myText(
      text,
      maxLines: maxLines,
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight ?? FontWeight.w800,
      textAlign: textAlign,
      letterSpacing: letterSpacing,
    );

Widget errorText<T>(T value) {
  String error = "";
  if (value is String) error = value;
  // if (value is ErrorModel) error = value.message;

  return myText(
    error,
    color: Consts.errorColor,
    // fontWeight: FontWeight.w800,
  );
}
