import 'package:apos_app/lib_exp.dart';

void showConfirmDialog(
  BuildContext context, {
  required String title,
  String? description,
  String? okLabel,
  Color? okColor,
  Icon? icon,
  Function()? onTapCancel,
  required Function() onTapOk,
}) =>
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ConfirmDialog(
        title: title,
        description: description,
        okLebel: okLabel ?? "OK",
        okColor: okColor,
        icon: icon,
        onTapCancel: onTapCancel,
        onTapOk: onTapOk,
      ),
    );

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String? description;
  final String okLebel;
  final Color? okColor;
  final Icon? icon;
  final Function()? onTapCancel;
  final Function() onTapOk;
  const _ConfirmDialog({
    required this.title,
    this.icon,
    this.description,
    required this.okLebel,
    required this.okColor,
    this.onTapCancel,
    required this.onTapOk,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Consts.secondaryColor,
      icon: icon ??
          const Icon(
            Icons.info,
            color: Consts.warningColor,
            size: 96,
          ),
      title: myTitle(title, textAlign: TextAlign.center),
      content: myText(description, maxLines: 4, textAlign: TextAlign.center),
      actions: [
        TextButton(
          onPressed: () {
            if (onTapCancel != null) {
              onTapCancel!();
            }
            Navigator.of(context).pop();
          },
          child: myText('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.pop(result: true);
            onTapOk();
          },
          style: TextButton.styleFrom(
            backgroundColor: okColor ?? Colors.red,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: myText(okLebel, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
