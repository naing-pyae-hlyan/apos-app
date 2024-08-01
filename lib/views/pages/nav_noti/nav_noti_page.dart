import 'package:apos_app/lib_exp.dart';

class NavNotiPage extends StatefulWidget {
  const NavNotiPage({super.key});

  @override
  State<NavNotiPage> createState() => _NavNotiPageState();
}

class _NavNotiPageState extends State<NavNotiPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Center(child: myText("Noti")),
    );
  }
}
