import 'package:apos_app/lib_exp.dart';

class MyStep extends StatelessWidget {
  final List<Widget> children;
  final Widget bottomNavigationBar;
  const MyStep({
    super.key,
    required this.bottomNavigationBar,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight - 208,
      child: Scaffold(
        backgroundColor: Consts.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
