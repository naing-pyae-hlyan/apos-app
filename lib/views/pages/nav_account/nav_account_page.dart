import 'package:apos_app/lib_exp.dart';

class NavAccountPage extends StatefulWidget {
  const NavAccountPage({super.key});

  @override
  State<NavAccountPage> createState() => _NavAccountPageState();
}

class _NavAccountPageState extends State<NavAccountPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Center(
        child: myText(
          CacheManager.currentCustomer?.name,
        ),
      ),
    );
  }
}
