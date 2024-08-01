import 'package:apos_app/lib_exp.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthBloc authBloc;
  // late CategoryBloc categoryBloc;

  final usernameTxtCtrl = TextEditingController();
  final passwordTxtCtrl = TextEditingController();
  final usernameFn = FocusNode();
  final passwordFn = FocusNode();

  bool _rememberMe = false;

  void _login() {
    authBloc.add(AuthEventLogin(
      username: usernameTxtCtrl.text,
      password: passwordTxtCtrl.text,
      rememberMe: _rememberMe,
    ));
  }

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    // categoryBloc = context.read<CategoryBloc>();
    super.initState();
    doAfterBuild(
      callback: () {
        usernameFn.requestFocus();
      },
    );
  }

  @override
  void dispose() {
    usernameTxtCtrl.dispose();
    passwordTxtCtrl.dispose();
    usernameFn.dispose();
    passwordFn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Center(
        child: MyCard(
          padding: const EdgeInsets.all(64),
          child: SizedBox(
            width: context.screenWidth * 0.6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                myText("Welcome", fontSize: 48),
                verticalHeight64,
                MyInputField(
                  controller: usernameTxtCtrl,
                  focusNode: usernameFn,
                  hintText: "Username",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                verticalHeight16,
                MyPasswordInputField(
                  controller: passwordTxtCtrl,
                  focusNode: passwordFn,
                  hintText: "Password",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (String str) {
                    _login();
                  },
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (_, state) {
                    if (state is AuthStateFail) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: errorText(state.error),
                        ),
                      );
                    }
                    return verticalHeight32;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: MyCheckBoxWithLabel(
                    label: "Remember Me",
                    mainAxisAlignment: MainAxisAlignment.end,
                    onSelected: (bool selected) {
                      _rememberMe = selected;
                    },
                  ),
                ),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (_, AuthState state) {
                    if (state is AuthStateSuccess) {
                      // categoryBloc.add(
                      //   CategoryEventReadData(
                      //     readSuccess: () {
                      //       context.pushAndRemoveUntil(const HomePage());
                      //     },
                      //   ),
                      // );
                    }
                    if (state is AuthStateFail) {
                      if (state.error.code == 1) {
                        usernameFn.requestFocus();
                        return;
                      }

                      if (state.error.code == 2) {
                        passwordFn.requestFocus();
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
