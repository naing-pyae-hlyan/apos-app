import 'package:apos_app/lib_exp.dart';

class NavFavPage extends StatefulWidget {
  const NavFavPage({super.key});

  @override
  State<NavFavPage> createState() => _NavFavPageState();
}

class _NavFavPageState extends State<NavFavPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Center(
          child: MyButton(
        onPressed: () => showPaymentDialog(
          context,
          onSelectedBank: (String bank) {},
        ),
        label: "Lee",
        icon: Icons.abc,
      )),
    );
  }
}
