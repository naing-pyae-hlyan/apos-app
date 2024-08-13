import 'package:apos_app/lib_exp.dart';

const _userNameErrorKey = "user-name-error-key";
const _userEmailErrorKey = "user-email-error-key";
const _userPhoneErrorKey = "user-phone-error-key";
const _userAddressErrorKey = "user-address-error-key";
const _userPasswordErrorKey = "user-password-error-key";

class AccountEditPage extends StatefulWidget {
  const AccountEditPage({super.key});

  @override
  State<AccountEditPage> createState() => _AccountEditPageState();
}

class _AccountEditPageState extends State<AccountEditPage> {
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

  void _onUpdate() {
    errorBloc.add(ErrorEventResert());
    final password = passwordTxtCtrl.text;
    final hashPassword = HashUtils.hashPassword(password);
    if (CacheManager.currentCustomer?.id == null ||
        CacheManager.currentCustomer?.readableId == null) {
      return;
    }

    final customer = CustomerModel(
      id: CacheManager.currentCustomer?.id,
      readableId: CacheManager.currentCustomer!.readableId,
      status: CacheManager.currentCustomer!.status,
      name: nameTxtCtrl.text,
      email: emailTxtCtrl.text,
      phone: phoneTxtCtrl.text,
      password: hashPassword,
      address: addressTxtCtrl.text,
      fcmToken: CacheManager.currentCustomer!.fcmToken,
      createdDate: CacheManager.currentCustomer!.createdDate,
    );
    authBloc.add(AuthEventUpdateCustomer(customer: customer));
  }

  void _updateCustomerStateListener(BuildContext context, AuthState state) {
    if (state is AuthStateUpdateCustomerSuccess) {
      showSuccessDialog(
        context,
        message: "Account info update success",
        onTapOk: () async {
          CacheManager.currentCustomer = state.customer;
          await SpHelper.rememberMe(
            email: state.customer.email,
            password: state.customer.password!,
          );

          //close current register page
          if (mounted) {
            // ignore: use_build_context_synchronously
            context.pushAndRemoveUntil(const SplashPage());
          }
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

    final CustomerModel? user = CacheManager.currentCustomer;
    if (user != null) {
      nameTxtCtrl.text = user.name;
      emailTxtCtrl.text = user.email;
      phoneTxtCtrl.text = user.phone;
      addressTxtCtrl.text = user.address;
    }
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
      appBar: myAppBar(title: myTitle("Back"), centerTitle: false),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              myTitle("Account Info"),
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
                hintText: "Enter Password",
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                errorKey: _userPasswordErrorKey,
                onSubmitted: (String str) {},
              ),
              verticalHeight24,
              BlocConsumer<AuthBloc, AuthState>(
                listener: _updateCustomerStateListener,
                builder: (_, AuthState state) {
                  if (state is AuthStateLoading) {
                    return const MyCircularIndicator();
                  }

                  return TextButton(
                    onPressed: _onUpdate,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.indigo,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: myText("UPDATE", color: Colors.white),
                    ),
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
