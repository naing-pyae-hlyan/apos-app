import 'package:apos_app/lib_exp.dart';

enum NavHomeEnum { products, orders, noti, account }

class NavHomePage extends StatefulWidget {
  const NavHomePage({super.key});

  @override
  State<NavHomePage> createState() => _NavHomePageState();
}

class _NavHomePageState extends State<NavHomePage> {
  NavHomeEnum _currentPage = NavHomeEnum.products;

  void _onDidChangedNavBar(NavHomeEnum navItem) {
    if (navItem == _currentPage) return;
    setState(() {
      _currentPage = navItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (_currentPage) {
        NavHomeEnum.products => const NavProductsPage(),
        NavHomeEnum.orders => const NavOrdersPage(),
        NavHomeEnum.noti => const NavNotiPage(),
        NavHomeEnum.account => const NavAccountPage(),
      },
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navIconButton(
              icon: Icons.dashboard,
              label: 'Home',
              isActive: _currentPage == NavHomeEnum.products,
              onTap: () => _onDidChangedNavBar(NavHomeEnum.products),
            ),
            _navIconButton(
              icon: Icons.receipt,
              label: 'Orders',
              isActive: _currentPage == NavHomeEnum.orders,
              onTap: () => _onDidChangedNavBar(NavHomeEnum.orders),
            ),
            _navIconButton(
              icon: Icons.notifications,
              label: 'Noti',
              isActive: _currentPage == NavHomeEnum.noti,
              onTap: () => _onDidChangedNavBar(NavHomeEnum.noti),
            ),
            _navIconButton(
              icon: Icons.person,
              label: 'Account',
              isActive: _currentPage == NavHomeEnum.account,
              onTap: () => _onDidChangedNavBar(NavHomeEnum.account),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navIconButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required Function() onTap,
  }) =>
      IconButton(
        isSelected: isActive,
        icon: Icon(
          icon,
          size: isActive ? 36 : 24,
          color: isActive
              ? Consts.primaryColor
              : Consts.primaryColor.withOpacity(0.45),
        ),
        onPressed: onTap,
      );
}
