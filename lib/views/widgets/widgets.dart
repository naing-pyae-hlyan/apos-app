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

Widget circularColor(int color) => SizedBox(
      width: 12,
      height: 12,
      child: CircleAvatar(
        backgroundColor: Color(color),
      ),
    );

Widget circularCount(int count) {
  String number = count > 99 ? "99+" : "$count";
  return Container(
    width: 24,
    height: 24,
    padding: const EdgeInsets.all(2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(32),
      color: Consts.currencyRed,
    ),
    child: myText(
      number,
      color: Colors.white,
      textAlign: TextAlign.center,
      fontWeight: FontWeight.w800,
    ),
  );
}
