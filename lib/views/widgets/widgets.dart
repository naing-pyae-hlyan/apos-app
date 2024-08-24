import 'dart:convert';

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

Widget checked() => const SizedBox(
      width: 24,
      height: 24,
      child: CircleAvatar(
        backgroundColor: Consts.primaryColor,
        child: Icon(
          Icons.check,
          size: 18,
          color: Colors.white,
        ),
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

Widget leadingProductImage(String? image) {
  if (image == null) return _defaultNoImage;
  Uint8List? memory;
  try {
    memory = base64Decode(image);
  } catch (_) {}

  if (memory == null) return _defaultNoImage;

  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.memory(
      memory,
      width: 64,
      height: 64,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _defaultNoImage,
    ),
  );
}

Widget get _defaultNoImage => Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[300],
      ),
    );
