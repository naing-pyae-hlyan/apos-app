import 'package:apos_app/lib_exp.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashPage extends StatefulWidget {
  final bool needToUpdateFavItems;
  const SplashPage({
    super.key,
    this.needToUpdateFavItems = false,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late AuthBloc authBloc;
  late DbBloc dbBloc;

  Future<void> _checkCredentials() async {
    if (!await FCMUtils.checkNotificationPermission()) {
      await FCMUtils.requestNotiPermission();
    }

    final username = await SpHelper.username;
    final password = await SpHelper.password;
    authBloc.add(AuthEventLogin(
      email: username,
      password: password,
      rememberMe: true,
      needToUpdateFavItems: widget.needToUpdateFavItems,
    ));
  }

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    dbBloc = context.read<DbBloc>();
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
      backgroundColor: Consts.scaffoldBackgroundColor,
      body: BlocListener<AuthBloc, AuthState>(
        child: BlocListener<DbBloc, DbState>(
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
                        Consts.appName,
                        fontWeight: FontWeight.bold,
                        color: Consts.primaryColor,
                        fontSize: 24,
                      ),
                      verticalHeight32,
                      LoadingAnimationWidget.threeArchedCircle(
                        color: Consts.primaryColor,
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
          listener: (_, DbState state) {
            if (state is DbStateFail) {
              context.pushAndRemoveUntil(const LoginPage());
            }

            if (state is DbStateGetProductsWithCategoryFromServerSuccess) {
              context.pushAndRemoveUntil(const NavHomePage());
            }
          },
        ),
        listener: (_, AuthState state) async {
          if (state is AuthStateFail) {
            context.pushAndRemoveUntil(const LoginPage());
          }
          if (state is AuthStateLoginSuccess) {
            dbBloc.add(DbEventGetProductsWithCategoryFromServer());
          }
        },
      ),
    );
  }
}
