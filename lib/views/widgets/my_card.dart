import 'package:apos_app/lib_exp.dart';

class MyCard extends StatelessWidget {
  final Widget child;
  final Color? cardColor;
  final Color? shadowColor;
  final EdgeInsetsGeometry? padding;
  final double elevation;
  const MyCard({
    super.key,
    required this.child,
    this.cardColor,
    this.shadowColor,
    this.padding,
    this.elevation = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor ?? Colors.white,
      surfaceTintColor: cardColor ?? Colors.white,
      shadowColor: shadowColor ?? Consts.secondaryColor,
      elevation: elevation,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
