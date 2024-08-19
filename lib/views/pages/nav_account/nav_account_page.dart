import 'package:apos_app/lib_exp.dart';

class NavAccountPage extends StatefulWidget {
  const NavAccountPage({super.key});

  @override
  State<NavAccountPage> createState() => _NavAccountPageState();
}

class _NavAccountPageState extends State<NavAccountPage> {
  late AuthBloc authBloc;

  void _onUpdate(CustomerUpdateAction action) {
    showCustomerUpdateDialog(context, action: action);
  }

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
      if (mounted && state.showErrorDialog) {
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
            SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 48),
                    child: MyCard(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(0.3),
                          },
                          children: [
                            accountData(
                              key: "Name:",
                              value: CacheManager.currentCustomer?.name,
                              onEdit: () => _onUpdate(
                                CustomerUpdateAction.name,
                              ),
                            ),
                            accountData(
                              key: "Email:",
                              value: CacheManager.currentCustomer?.email,
                              onEdit: () => _onUpdate(
                                CustomerUpdateAction.emial,
                              ),
                            ),
                            accountData(
                              key: "Phone:",
                              value: CacheManager.currentCustomer?.phone,
                              onEdit: () => _onUpdate(
                                CustomerUpdateAction.phone,
                              ),
                            ),
                            accountData(
                              key: "Address:",
                              value: CacheManager.currentCustomer?.address,
                              onEdit: () => _onUpdate(
                                CustomerUpdateAction.address,
                              ),
                            ),
                            accountData(
                              key: "Password:",
                              value: "********",
                              onEdit: () => _onUpdate(
                                CustomerUpdateAction.password,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(96),
                      color: Consts.secondaryColor,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(
                      Icons.account_circle_rounded,
                      color: Consts.primaryColor,
                      size: 96,
                    ),
                  ),
                ],
              ),
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

  TableRow accountData({
    required String key,
    required String? value,
    required Function() onEdit,
  }) =>
      TableRow(
        children: [
          TableCell(child: myText(key, fontSize: 14)),
          TableCell(
              child: myText(
            value,
            textAlign: TextAlign.end,
            fontSize: 14,
            maxLines: 4,
          )),
          TableCell(
            child: IconButton(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit,
                color: Colors.indigo,
                size: 16,
              ),
            ),
          ),
        ],
      );
}
