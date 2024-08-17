import 'package:apos_app/lib_exp.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

enum NavHomeEnum { products, fav, orders, account }

class NavHomePage extends StatefulWidget {
  const NavHomePage({super.key});

  @override
  State<NavHomePage> createState() => _NavHomePageState();
}

class _NavHomePageState extends State<NavHomePage> {
  int _selectedIndex = 0;

  void _onDidChangedNavBar(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _tabs = const [
    NavProductsPage(),
    NavFavPage(),
    NavOrdersPage(),
    NavAccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _tabs[_selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
          color: Consts.primaryColor,
          backgroundColor: Consts.scaffoldBackgroundColor,
          buttonBackgroundColor: Consts.primaryColor,
          items: [
            CurvedNavigationBarItem(
              child: const Icon(
                Icons.home_rounded,
                size: 30,
                color: Colors.white,
              ),
              label: "Home",
              labelStyle: navBarLabelStyle,
            ),
            CurvedNavigationBarItem(
              child: const Icon(
                Icons.favorite,
                size: 30,
                color: Colors.white,
              ),
              label: "Favorite",
              labelStyle: navBarLabelStyle,
            ),
            CurvedNavigationBarItem(
              child: const Icon(
                Icons.receipt_long,
                size: 30,
                color: Colors.white,
              ),
              label: "Orders",
              labelStyle: navBarLabelStyle,
            ),
            CurvedNavigationBarItem(
              child: const Icon(
                Icons.account_circle_rounded,
                size: 30,
                color: Colors.white,
              ),
              label: "Account",
              labelStyle: navBarLabelStyle,
            ),
          ],
          onTap: (int index) {
            _onDidChangedNavBar(index);
          },
        ),
      ),
    );
  }

  TextStyle get navBarLabelStyle => const TextStyle(
        color: Colors.white,
        overflow: TextOverflow.ellipsis,
      );
}
