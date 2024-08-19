import 'package:apos_app/lib_exp.dart';

class NavAccountPage extends StatefulWidget {
  const NavAccountPage({super.key});

  @override
  State<NavAccountPage> createState() => _NavAccountPageState();
}

class _NavAccountPageState extends State<NavAccountPage> {
  late AuthBloc authBloc;
  Future<void> _logout() async {
    showConfirmDialog(
      context,
      title: "Are you sure want to logout?",
      okLabel: "Logout",
      onTapOk: () async {
        authBloc.add(AuthEventLogout());
      },
    );
  }

  void _logoutStateListener(BuildContext context, AuthState state) async {
    if (state is AuthStateLogout) {
      CacheManager.clear();
      await SpHelper.clear();
      if (mounted) {
        // ignore: use_build_context_synchronously
        context
            .pushAndRemoveUntil(const SplashPage(needToUpdateFavItems: true));
      }
    }
    if (state is AuthStateFail) {
      if (mounted) {
        showErrorDialog(
          // ignore: use_build_context_synchronously
          context,
          title: "Failed!",
          description: state.error.message,
          onTapOk: () {},
        );
      }
    }
  }

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                MyCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      verticalHeight32,
                      const Icon(
                        Icons.person,
                        size: 64,
                        color: Consts.primaryColor,
                      ),
                      verticalHeight8,
                      myText(
                        CacheManager.currentCustomer?.name,
                        fontWeight: FontWeight.w700,
                      ),
                      verticalHeight8,
                      _row(
                        key: "Email",
                        value: CacheManager.currentCustomer?.email,
                      ),
                      verticalHeight4,
                      _row(
                        key: "Phone",
                        value: CacheManager.currentCustomer?.phone,
                      ),
                      verticalHeight4,
                      _row(
                        key: "Address",
                        value: CacheManager.currentCustomer?.address,
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.push(const AccountEditPage()),
                  label: myText("Edit", color: Colors.black),
                  icon: const Icon(Icons.edit_square, color: Colors.black),
                ),
              ],
            ),
            verticalHeight32,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocConsumer<AuthBloc, AuthState>(
                  listener: _logoutStateListener,
                  builder: (_, state) {
                    if (state is AuthStateLoading) {
                      return const MyCircularIndicator();
                    }
                    return TextButton.icon(
                      onPressed: _logout,
                      label: myText("Logout", color: Colors.red),
                      icon: const Icon(Icons.logout, color: Colors.red),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CommonUtils.versionLabel(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row({
    required String key,
    required String? value,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          myText(key),
          Flexible(
            child: myText(value, textAlign: TextAlign.end),
          ),
        ],
      );
}
