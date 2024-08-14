import 'package:apos_app/lib_exp.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

enum NavHomeEnum { products, fav, orders, account }

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
    return SafeArea(
      child: Scaffold(
        body: switch (_currentPage) {
          NavHomeEnum.products => const NavProductsPage(),
          NavHomeEnum.fav => const NavFavPage(),
          NavHomeEnum.orders => const NavOrdersPage(),
          NavHomeEnum.account => const NavAccountPage(),
        },
        bottomNavigationBar: CurvedNavigationBar(
          color: Consts.secondaryColor,
          backgroundColor: Consts.primaryColor,
          buttonBackgroundColor: Consts.secondaryColor,
          height: 56,
          items: const [
            Icon(Icons.dashboard, color: Consts.primaryColor, size: 30),
            Icon(Icons.favorite, color: Consts.primaryColor, size: 30),
            Icon(Icons.receipt_long, color: Consts.primaryColor, size: 30),
            Icon(Icons.person, color: Consts.primaryColor, size: 30),
          ],
          onTap: (int index) {
            switch (index) {
              case 0:
                _onDidChangedNavBar(NavHomeEnum.products);
                break;
              case 1:
                _onDidChangedNavBar(NavHomeEnum.fav);
                break;
              case 2:
                _onDidChangedNavBar(NavHomeEnum.orders);
                break;
              case 3:
                _onDidChangedNavBar(NavHomeEnum.account);
                break;
            }
          },
        ),
      ),
    );
  }
}
