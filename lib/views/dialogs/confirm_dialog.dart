import 'package:apos_app/lib_exp.dart';

void showConfirmDialog(
  BuildContext context, {
  required String title,
  String? description,
  Function()? onTapCancel,
  required Function() onTapOk,
}) =>
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ConfirmDialog(
        title: title,
        description: description,
        onTapCancel: onTapCancel,
        onTapOk: onTapOk,
      ),
    );

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String? description;
  final Function()? onTapCancel;
  final Function() onTapOk;
  const _ConfirmDialog({
    required this.title,
    this.description,
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
        color: Consts.primaryColor,
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
        MyButton(
          label: "Delete",
          labelColor: Colors.white,
          borderColor: Colors.red,
          backgroundColor: Colors.red,
          icon: Icons.delete,
          onPressed: () {
            onTapOk();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
