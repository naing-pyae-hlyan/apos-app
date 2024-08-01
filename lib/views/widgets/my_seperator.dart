import 'package:apos_app/lib_exp.dart';

class MySeparator extends StatelessWidget {
  final double height;
  final double dash;
  final Color? color;
  const MySeparator({
    this.height = 1,
    this.dash = 4.0,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      final boxWidth = constraints.constrainWidth();
      final dashCount = (boxWidth / (2 * dash)).floor();
      return Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
        children: List.generate(
          dashCount,
          (index) => SizedBox(
            width: dash,
            height: height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color ?? Consts.primaryColor.withOpacity(0.8),
              ),
            ),
          ),
        ),
      );
    });
  }
}
