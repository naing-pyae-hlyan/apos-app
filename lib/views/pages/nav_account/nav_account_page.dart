import 'package:apos_app/lib_exp.dart';

class NavAccountPage extends StatefulWidget {
  const NavAccountPage({super.key});

  @override
  State<NavAccountPage> createState() => _NavAccountPageState();
}

class _NavAccountPageState extends State<NavAccountPage> {
  Future<void> _logout() async {
    showConfirmDialog(
      context,
      title: "Are you sure want to logout?",
      okLabel: "Logout",
      onTapOk: () async {
        await SpHelper.clear();
        CacheManager.clear();
        if (mounted) {
          context.pushAndRemoveUntil(const SplashPage());
        }
      },
    );
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
                TextButton.icon(
                  onPressed: _logout,
                  label: myText("Logout", color: Colors.red),
                  icon: const Icon(Icons.logout, color: Colors.red),
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
