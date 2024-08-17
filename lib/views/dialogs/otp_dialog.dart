import 'package:apos_app/lib_exp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void showOTPDialog(
  BuildContext context, {
  required String verificationId,
  required Function(User) onSuccess,
}) =>
    showAdaptiveDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _OTPDialog(
        verificationId: verificationId,
        onSuccess: onSuccess,
      ),
    );

class _OTPDialog extends StatefulWidget {
  final String verificationId;
  final Function(User) onSuccess;
  const _OTPDialog({required this.verificationId, required this.onSuccess});

  @override
  State<_OTPDialog> createState() => __OTPDialogState();
}

class __OTPDialogState extends State<_OTPDialog> {
  final pinTxtCtrl = TextEditingController();
  void _verifyOTP() async {
    final otp = pinTxtCtrl.text.trim();
    final credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );
    final result = await FAUtils.auth.signInWithCredential(credential);
    final user = result.user;

    if (mounted && user != null) {
      context.pop();
      widget.onSuccess(user);
    }
  }

  @override
  void dispose() {
    pinTxtCtrl.dispose();
    super.dispose();
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
          myText("Enter the OTP sent to your phone"),
          verticalHeight8,
          SizedBox(
            width: context.screenWidth * 0.7,
            child: PinCodeTextField(
              appContext: context,
              controller: pinTxtCtrl,
              length: 6,
              onCompleted: (_) => _verifyOTP(),
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
