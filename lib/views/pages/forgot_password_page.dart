import 'package:apos_app/lib_exp.dart';

const _newPwdErrorKey = "fpp-new-pwd-error-key";
const _userPhoneErrorKey = "fpp-phone-error-key";
const _userEmailErrorKey = "fpp-email-error-key";

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late AuthBloc authBloc;
  late ErrorBloc errorBloc;

  final phoneTxtCtrl = TextEditingController();
  final emailTxtCtrl = TextEditingController();
  final newPwdTxtCtrl = TextEditingController();
  final newPwdFn = FocusNode();
  final emailFn = FocusNode();
  final phoneFn = FocusNode();

  Future<void> _forgotPassword() async {
    errorBloc.add(ErrorEventResert());
    final password = newPwdTxtCtrl.text;
    final hashPassword = HashUtils.hashPassword(password);
    final email = emailTxtCtrl.text;
    final phone = phoneTxtCtrl.text;
    authBloc.add(AuthEventForgotPasswordRequestOTP(
      password: hashPassword,
      phone: phone,
      email: email,
    ));
  }

  void _forgotPasswordStateListener(BuildContext context, AuthState state) {
    if (state is AuthStateForgotPasswordSuccess) {
      showSuccessDialog(
        context,
        message: "Your password is updated.",
        onTapOk: () {
          //close current forgot_password page
          context.pop();
        },
      );
    }

    if (state is AuthStateForgotPasswordRequestOTP) {
      showOTPDialog(
        context,
        onSuccess: () {
          authBloc.add(AuthEventForgotPasswordActivate(
            id: state.id,
            password: state.password,
            phone: state.phone,
          ));
        },
      );
    }

    if (state is AuthStateFail) {
      String? errorKey;
      if (state.error.code == 1) {
        phoneFn.requestFocus();
        errorKey = _userPhoneErrorKey;
      } else if (state.error.code == 2) {
        emailFn.requestFocus();
        errorKey = _userEmailErrorKey;
      } else if (state.error.code == 3) {
        newPwdFn.requestFocus();
        errorKey = _newPwdErrorKey;
      }
      errorBloc.add(ErrorEventSetError(errorKey: errorKey, error: state.error));
    }
  }

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    errorBloc = context.read<ErrorBloc>();
    super.initState();
    doAfterBuild(
      callback: () {
        errorBloc.add(ErrorEventResert());
      },
    );
  }

  @override
  void dispose() {
    if (mounted) {
      newPwdTxtCtrl.dispose();
      phoneTxtCtrl.dispose();
      newPwdFn.dispose();
      phoneFn.dispose();
      emailTxtCtrl.dispose();
      emailFn.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: myAppBar(title: myTitle("Back To Login"), centerTitle: false),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              myText("Forgot Password", fontSize: 32),
              verticalHeight24,
              MyInputField(
                controller: phoneTxtCtrl,
                focusNode: phoneFn,
                hintText: "Phone eg. 09123456789",
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textInputAction: TextInputAction.next,
                errorKey: _userPhoneErrorKey,
              ),
              verticalHeight16,
              MyInputField(
                controller: emailTxtCtrl,
                focusNode: emailFn,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                errorKey: _userEmailErrorKey,
              ),
              verticalHeight16,
              MyPasswordInputField(
                controller: newPwdTxtCtrl,
                focusNode: newPwdFn,
                hintText: "New Password",
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                errorKey: _newPwdErrorKey,
                onSubmitted: (String str) {},
              ),
              verticalHeight24,
              BlocConsumer<AuthBloc, AuthState>(
                listener: _forgotPasswordStateListener,
                builder: (_, AuthState state) {
                  if (state is AuthStateLoading) {
                    return const MyCircularIndicator();
                  }

                  return MyButton(
                    label: "Request OTP",
                    icon: Icons.login,
                    labelColor: Colors.white,
                    backgroundColor: Consts.primaryColor,
                    onPressed: _forgotPassword,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
