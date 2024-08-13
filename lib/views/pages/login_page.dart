import 'package:apos_app/lib_exp.dart';

const _userNameErrorKey = "user-name-error-key";
const _passwordErrorKey = "password-error-key";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthBloc authBloc;
  late DbBloc dbBloc;
  late ErrorBloc errorBloc;

  final emailTxtCtrl = TextEditingController();
  final passwordTxtCtrl = TextEditingController();
  final usernameFn = FocusNode();
  final passwordFn = FocusNode();

  void _login() {
    final password = passwordTxtCtrl.text;
    final hashPassword = HashUtils.hashPassword(password);
    authBloc.add(AuthEventLogin(
      email: emailTxtCtrl.text,
      password: hashPassword,
      rememberMe: true,
    ));
  }

  void _loginStateListener(BuildContext context, AuthState state) async {
    if (state is AuthStateLoginSuccess) {
      LoadingDialog.show();
      dbBloc.add(DbEventGetProductsWithCategoryFromServer());
      // final fcmToken = await SpHelper.fcmToken;
      // final customerId = CacheManager.currentCustomer?.id;

      // authBloc.add(
      //   AuthEventUpdateFcm(customerId: customerId, fcmToken: fcmToken),
      // );
    }
    // if (state is AuthStateUpdateFcmSuccess) {
    //   dbBloc.add(DbEventGetProductsWithCategoryFromServer());
    // }

    if (state is AuthStateFail) {
      String? errorKey;
      if (state.error.code == 1) {
        usernameFn.requestFocus();
        errorKey = _userNameErrorKey;
      } else if (state.error.code == 2) {
        passwordFn.requestFocus();
        errorKey = _passwordErrorKey;
      }

      errorBloc.add(ErrorEventSetError(errorKey: errorKey, error: state.error));
    }
  }

  void _dbStateListener(BuildContext context, DbState state) {
    if (state is DbStateGetProductsWithCategoryFromServerSuccess) {
      LoadingDialog.hide();
      context.pushAndRemoveUntil(const NavHomePage());
      return;
    }

    if (state is DbStateFail) {
      LoadingDialog.hide();
      showErrorDialog(
        context,
        title: "Server Error",
        description: state.error.message,
        onTapOk: () {},
      );
    }
  }

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    dbBloc = context.read<DbBloc>();
    errorBloc = context.read<ErrorBloc>();
    super.initState();
    doAfterBuild(
      callback: () {
        usernameFn.requestFocus();
        errorBloc.add(ErrorEventResert());
      },
    );
  }

  @override
  void dispose() {
    emailTxtCtrl.dispose();
    passwordTxtCtrl.dispose();
    usernameFn.dispose();
    passwordFn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocListener<DbBloc, DbState>(
            listener: _dbStateListener,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                myText("Login", fontSize: 32),
                verticalHeight64,
                MyInputField(
                  controller: emailTxtCtrl,
                  focusNode: usernameFn,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  errorKey: _userNameErrorKey,
                ),
                verticalHeight16,
                MyPasswordInputField(
                  controller: passwordTxtCtrl,
                  focusNode: passwordFn,
                  hintText: "Password",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  errorKey: _passwordErrorKey,
                  onSubmitted: (String str) {
                    _login();
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: myText(
                      "Forgot Password",
                      color: Consts.primaryColor,
                    ),
                  ),
                ),
                verticalHeight24,
                BlocConsumer<AuthBloc, AuthState>(
                  listener: _loginStateListener,
                  builder: (_, AuthState state) {
                    if (state is AuthStateLoading) {
                      return const MyCircularIndicator();
                    }

                    return MyButton(
                      label: "Login",
                      icon: Icons.login,
                      labelColor: Colors.white,
                      backgroundColor: Consts.primaryColor,
                      onPressed: _login,
                    );
                  },
                ),
                verticalHeight24,
                TextButton(
                  onPressed: () => context.push(const RegisterPage()),
                  child: myText(
                    "Create an account",
                    color: Consts.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
