import 'package:apos_app/lib_exp.dart';

const _userNameErrorKey = "user-name-error-key";
const _userEmailErrorKey = "user-email-error-key";
const _userPhoneErrorKey = "user-phone-error-key";
const _userAddressErrorKey = "user-address-error-key";
const _userPasswordErrorKey = "user-password-error-key";

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late AuthBloc authBloc;
  late ErrorBloc errorBloc;

  final nameTxtCtrl = TextEditingController();
  final emailTxtCtrl = TextEditingController();
  final phoneTxtCtrl = TextEditingController();
  final passwordTxtCtrl = TextEditingController();
  final addressTxtCtrl = TextEditingController();

  final nameFn = FocusNode();
  final emailFn = FocusNode();
  final phoneFn = FocusNode();
  final addressFn = FocusNode();
  final passwordFn = FocusNode();

  void _register() async {
    errorBloc.add(ErrorEventResert());
    final password = passwordTxtCtrl.text;
    final hashPassword = HashUtils.hashPassword(password);
    final fcmToken = await SpHelper.fcmToken;
    final customer = CustomerModel(
      readableId: RandomIdGenerator.getnerateProductUniqueId(),
      name: nameTxtCtrl.text,
      email: emailTxtCtrl.text,
      phone: phoneTxtCtrl.text,
      password: hashPassword,
      address: addressTxtCtrl.text,
      status: 1,
      fcmToken: fcmToken,
      createdDate: DateTime.now(),
    );
    authBloc.add(AuthEventRegister(customer: customer));
  }

  void _registerStateListener(BuildContext context, AuthState state) {
    if (state is AuthStateRegisterSuccess) {
      showSuccessDialog(
        context,
        message: "Register success",
        onTapOk: () {
          //close current register page
          context.pop();
        },
      );
    }

    if (state is AuthStateFail) {
      String? errorKey;
      if (state.error.code == 1) {
        nameFn.requestFocus();
        errorKey = _userNameErrorKey;
      } else if (state.error.code == 2) {
        emailFn.requestFocus();
        errorKey = _userEmailErrorKey;
      } else if (state.error.code == 3) {
        phoneFn.requestFocus();
        errorKey = _userPhoneErrorKey;
      } else if (state.error.code == 4) {
        addressFn.requestFocus();
        errorKey = _userAddressErrorKey;
      } else if (state.error.code == 5) {
        passwordFn.requestFocus();
        errorKey = _userPasswordErrorKey;
      }
      errorBloc.add(ErrorEventSetError(errorKey: errorKey, error: state.error));
    }
  }

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    errorBloc = context.read<ErrorBloc>();
    super.initState();

    doAfterBuild(callback: () {
      nameFn.requestFocus();
      errorBloc.add(ErrorEventResert());
    });
  }

  @override
  void dispose() {
    if (mounted) {
      nameTxtCtrl.dispose();
      emailTxtCtrl.dispose();
      phoneTxtCtrl.dispose();
      passwordTxtCtrl.dispose();
      addressTxtCtrl.dispose();
      nameFn.dispose();
      emailFn.dispose();
      phoneFn.dispose();
      addressFn.dispose();
      passwordFn.dispose();
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
              myText("Register", fontSize: 32),
              verticalHeight24,
              MyInputField(
                controller: nameTxtCtrl,
                focusNode: nameFn,
                hintText: "User Name",
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                errorKey: _userNameErrorKey,
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
                controller: addressTxtCtrl,
                focusNode: addressFn,
                hintText: "Address",
                maxLines: 3,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                errorKey: _userAddressErrorKey,
              ),
              verticalHeight16,
              MyPasswordInputField(
                controller: passwordTxtCtrl,
                focusNode: passwordFn,
                hintText: "New Password",
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                errorKey: _userPasswordErrorKey,
                onSubmitted: (String str) {},
              ),
              verticalHeight24,
              BlocConsumer<AuthBloc, AuthState>(
                listener: _registerStateListener,
                builder: (_, AuthState state) {
                  if (state is AuthStateLoading) {
                    return const MyCircularIndicator();
                  }

                  return MyButton(
                    label: "Register",
                    icon: Icons.login,
                    labelColor: Colors.white,
                    backgroundColor: Consts.primaryColor,
                    onPressed: _register,
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
