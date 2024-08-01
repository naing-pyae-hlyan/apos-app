import 'package:apos_app/lib_exp.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Color? labelColor;
  final Color? backgroundColor;
  final Function() onPressed;
  final Color? borderColor;
  final IconData? icon;
  const MyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.labelColor,
    this.backgroundColor,
    this.borderColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: backgroundColor ?? Consts.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(124),
          side: BorderSide(
            color: borderColor ?? Consts.primaryColor,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 8, 24, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            myText(
              label,
              color: labelColor ?? Colors.white,
              fontWeight: FontWeight.bold,
            ),
            horizontalWidth16,
            Icon(
              icon,
              color: labelColor ?? Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
