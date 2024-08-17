import 'package:apos_app/lib_exp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void showOTPDialog(
  BuildContext context, {
  required User user,
}) =>
    showAdaptiveDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _OTPDialog(user: user),
    );

class _OTPDialog extends StatefulWidget {
  final User user;
  const _OTPDialog({required this.user});

  @override
  State<_OTPDialog> createState() => __OTPDialogState();
}

class __OTPDialogState extends State<_OTPDialog> {
  void _verifyOTP() async {
    await widget.user.reload();
    if (mounted && widget.user.emailVerified) {
      context.pop();
      // colose current OTP popup
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Consts.secondaryColor,
      title: myTitle("OTP", textAlign: TextAlign.center),
      content: Column(
        children: [
          myText("Enter the OTP sent to your email"),
          verticalHeight8,
          Expanded(
            child: PinCodeTextField(
              appContext: context,
              length: 6,
              onCompleted: (_) => _verifyOTP(),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: myText(
            "VERIFY",
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
