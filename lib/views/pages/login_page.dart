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

  bool _rememberMe = false;

  void _login() {
    authBloc.add(AuthEventLogin(
      email: emailTxtCtrl.text,
      password: passwordTxtCtrl.text,
      rememberMe: _rememberMe,
    ));
  }

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    dbBloc = context.read<DbBloc>();
    errorBloc = context.read<ErrorBloc>();
    super.initState();
    doAfterBuild(
      callback: () {
        errorBloc.add(ErrorEventResert());
        usernameFn.requestFocus();
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
      backgroundColor: Consts.secondaryColor,
      body: Center(
        child: MyCard(
          padding: const EdgeInsets.all(32),
          child: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                myText("Welcome", fontSize: 32),
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
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  errorKey: _passwordErrorKey,
                  onSubmitted: (String str) {
                    _login();
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: MyCheckBoxWithLabel(
                      label: "Remember Me",
                      mainAxisAlignment: MainAxisAlignment.end,
                      onSelected: (bool selected) {
                        _rememberMe = selected;
                      },
                    ),
                  ),
                ),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (_, AuthState state) {
                    if (state is AuthStateLoginSuccess) {
                      dbBloc.add(DbEventGetProductsWithCategoryFromServer());
                    }
                    if (state is AuthStateFail) {
                      if (state.error.code == 1) {
                        usernameFn.requestFocus();
                        errorBloc.add(
                          ErrorEventSetError(
                            errorKey: _userNameErrorKey,
                            error: state.error,
                          ),
                        );
                        return;
                      }

                      if (state.error.code == 2) {
                        passwordFn.requestFocus();
                        errorBloc.add(
                          ErrorEventSetError(
                            errorKey: _passwordErrorKey,
                            error: state.error,
                          ),
                        );
                        return;
                      }
                    }
                  },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
