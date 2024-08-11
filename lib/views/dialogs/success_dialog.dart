import 'package:apos_app/lib_exp.dart';

void showSuccessDialog(
  BuildContext context, {
  required String message,
  required Function() onTapOk,
}) =>
    showAdaptiveDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessDialog(message: message, onTapOk: onTapOk),
    );

class _SuccessDialog extends StatelessWidget {
  final String message;
  final Function() onTapOk;
  const _SuccessDialog({
    required this.message,
    required this.onTapOk,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Consts.secondaryColor,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 96,
      ),
      title: myTitle("SUCCESS", textAlign: TextAlign.center),
      content: myText(message, maxLines: 4, textAlign: TextAlign.center),
      actions: [
        TextButton(
          onPressed: () {
            context.pop(result: true);
            onTapOk();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.green[50],
            surfaceTintColor: Colors.green[50],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: myText(
              "OK",
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
