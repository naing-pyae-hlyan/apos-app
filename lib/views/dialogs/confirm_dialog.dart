import 'package:apos_app/lib_exp.dart';

void showConfirmDialog(
  BuildContext context, {
  required String title,
  String? description,
  String? okLabel,
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
        onTapCancel: onTapCancel,
        onTapOk: onTapOk,
      ),
    );

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String? description;
  final String okLebel;
  final Function()? onTapCancel;
  final Function() onTapOk;
  const _ConfirmDialog({
    required this.title,
    this.description,
    required this.okLebel,
    this.onTapCancel,
    required this.onTapOk,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Consts.secondaryColor,
      icon: const Icon(
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
            backgroundColor: Colors.red,
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
