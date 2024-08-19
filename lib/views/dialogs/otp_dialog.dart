import 'dart:async';
import 'package:apos_app/lib_exp.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void showOTPDialog(
  BuildContext context, {
  required Function() onSuccess,
}) =>
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
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
  ValueNotifier<bool> canSendListener = ValueNotifier(false);
  late StreamController<int> streamController;
  late Stream<int> countdownStream;
  Timer? timer;
  int currentSeconds = 60;

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

  void resendOTP() {
    startCountdown();
    requestOTP();
  }

  void startCountdown() {
    timer?.cancel();
    currentSeconds = 60;
    canSendListener.value = false;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (currentSeconds > 0) {
          streamController.add(--currentSeconds);
        } else {
          canSendListener.value = true;
          timer.cancel();
        }
      },
    );
  }

  void requestOTP() => LocalNotiService.showOTP(
        generatedOTP: (otp) {
          _otp = otp;
        },
      );

  @override
  void initState() {
    super.initState();
    streamController = StreamController();
    countdownStream = streamController.stream.asBroadcastStream();
    startCountdown();

    doAfterBuild(callback: () {
      requestOTP();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    streamController.close();

    super.dispose();
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
          myText("Your code was sent to your device."),
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
          verticalHeight16,
          StreamBuilder<int>(
            stream: countdownStream,
            builder: (_, snapshot) {
              final sec = snapshot.data ?? 60;
              if (sec == 0) return emptyUI;
              return myText(
                "Resend OTP in $sec seconds",
              );
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: canSendListener,
            builder: (_, bool canSend, __) {
              if (canSend) {
                return TextButton.icon(
                  onPressed: resendOTP,
                  label: myText("Resend OTP", color: Consts.primaryColor),
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Consts.primaryColor,
                  ),
                );
              }

              return emptyUI;
            },
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
