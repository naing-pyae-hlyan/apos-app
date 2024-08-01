import 'package:apos_app/lib_exp.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late AuthBloc authBloc;
  late ItemBloc itemBloc;

  Future<void> _checkCredentials() async {
    final username = await SpHelper.username;
    final password = await SpHelper.password;

    // if (username.isNotEmpty && password.isNotEmpty) {
    authBloc.add(AuthEventLogin(
      username: username,
      password: password,
      rememberMe: true,
    ));
    // return;
    // }

    // if (mounted) context.pushAndRemoveUntil(const LoginPage());
  }

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    itemBloc = context.read<ItemBloc>();
    super.initState();
    doAfterBuild(
      callback: () async {
        await _checkCredentials();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Consts.primaryColor,
      body: BlocListener<AuthBloc, AuthState>(
        child: BlocListener<ItemBloc, ItemState>(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      myTitle(
                        "Hello There",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24,
                      ),
                      verticalHeight32,
                      LoadingAnimationWidget.threeArchedCircle(
                        color: Colors.white,
                        size: 50,
                      ),
                    ],
                  ),
                ),
                CommonUtils.versionLabel(),
                verticalHeight4,
              ],
            ),
          ),
          listener: (_, ItemState state) {
            if (state is ItemStateFail) {
              // TODO
              // context.pushAndRemoveUntil(const LoginPage());
            }

            if (state is ItemStateSuccess) {
              context.pushAndRemoveUntil(const NavHomePage());
            }
          },
        ),
        listener: (_, AuthState state) {
          if (state is AuthStateFail) {
            // TODO
            // context.pushAndRemoveUntil(const LoginPage());
          }
          if (state is AuthStateSuccess) {
            itemBloc.add(ItemEventGetProductsWithCategory());
          }
        },
      ),
    );
  }
}
