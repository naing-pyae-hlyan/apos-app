import 'package:apos_app/lib_exp.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void showOTPDialog(
  BuildContext context, {
  required Function() onSuccess,
}) =>
    showAdaptiveDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _OTPDialog(
        onSuccess: onSuccess,
      ),
    );

class _OTPDialog extends StatefulWidget {
  final Function() onSuccess;
  const _OTPDialog({
    required this.onSuccess,
  });

  @override
  State<_OTPDialog> createState() => __OTPDialogState();
}

class __OTPDialogState extends State<_OTPDialog> {
  ValueNotifier<String> errorListener = ValueNotifier("");
  String? _otp;
  final pinTxtCtrl = TextEditingController();
  void _verifyOTP() async {
    errorListener.value = "";
    final otp = pinTxtCtrl.text.trim();

    if (otp != _otp) {
      errorListener.value = "Invalid OTP";
      return;
    }
    // close current otp dialog
    context.pop();
    widget.onSuccess();
  }

  @override
  void dispose() {
    // if (mounted) pinTxtCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    doAfterBuild(callback: () {
      LocalNotiService.showOTP(
        generatedOTP: (otp) {
          _otp = otp;
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Consts.secondaryColor,
      title: myTitle("OTP Verify", textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          myText("Your code was sent to your phone."),
          verticalHeight8,
          SizedBox(
            width: context.screenWidth * 0.7,
            child: PinCodeTextField(
              appContext: context,
              autoFocus: true,
              controller: pinTxtCtrl,
              length: 6,
              keyboardType: TextInputType.number,
              cursorColor: Consts.primaryColor,
              onCompleted: (_) => _verifyOTP(),
            ),
          ),
          verticalHeight8,
          Align(
            alignment: Alignment.centerLeft,
            child: ValueListenableBuilder(
              valueListenable: errorListener,
              builder: (_, String value, __) {
                return errorText(value);
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _verifyOTP();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            surfaceTintColor: Colors.green,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: myText(
              "VERIFY",
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
