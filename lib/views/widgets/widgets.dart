import 'package:apos_app/lib_exp.dart';

const emptyUI = SizedBox.shrink();

class Clickable extends StatelessWidget {
  final double radius;
  final Function() onTap;
  final Widget child;
  const Clickable({
    super.key,
    this.radius = 12,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      splashColor: Consts.secondaryColor,
      onTap: onTap,
      child: child,
    );
  }
}

Widget networkImage(String? url) => Image.network(
      url ?? "",
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Image.asset(
        "assets/icons/default.png",
        fit: BoxFit.contain,
      ),
    );
