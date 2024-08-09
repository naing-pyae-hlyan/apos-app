import 'package:apos_app/lib_exp.dart';

void showErrorDialog(
  BuildContext context, {
  required String title,
  String? description,
  required Function() onTapOk,
}) =>
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ErrorDialog(
        title: title,
        description: description,
        onTapOk: onTapOk,
      ),
    );

class _ErrorDialog extends StatelessWidget {
  final String title;
  final String? description;
  final Function() onTapOk;
  const _ErrorDialog({
    required this.title,
    this.description,
    required this.onTapOk,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Consts.secondaryColor,
      title: myTitle(title),
      content: myText(description, maxLines: 4),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: myText('OK'),
        ),
      ],
    );
  }
}
