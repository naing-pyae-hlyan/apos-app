import 'package:apos_app/lib_exp.dart';

class NavOrdersPage extends StatefulWidget {
  const NavOrdersPage({super.key});

  @override
  State<NavOrdersPage> createState() => _NavOrdersPageState();
}

class _NavOrdersPageState extends State<NavOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Center(child: myText("Orders")),
    );
  }
}
