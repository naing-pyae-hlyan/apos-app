import 'package:apos_app/lib_exp.dart';

class MyScaffold extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? fab;
  final EdgeInsetsGeometry? padding;
  final Widget? bottomNavigationBar;
  const MyScaffold({
    super.key,
    required this.body,
    this.backgroundColor,
    this.appBar,
    this.padding,
    this.fab,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.hideKeyboard(),
      child: SafeArea(
        child: Scaffold(
          appBar: appBar,
          backgroundColor: backgroundColor ?? Consts.scaffoldBackgroundColor,
          body: Padding(
            padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: body,
          ),
          floatingActionButton: fab,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }
}

AppBar myAppBar({
  required Widget title,
  bool centerTitle = true,
  final List<Widget>? actions,
  double elevation = 16,
}) =>
    AppBar(
      automaticallyImplyLeading: true,
      title: title,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Consts.secondaryColor,
      actions: [
        if (actions != null) ...actions,
        horizontalWidth16,
      ],
    );

class MyScaffoldDataGridView<M> extends StatelessWidget {
  final Widget? header;
  final Stream<M> stream;
  final Function(M) streamBuilder;
  // final MyBlocBuilder<M> blocBuilder;
  final double elevation;
  const MyScaffoldDataGridView({
    super.key,
    this.header,
    required this.stream,
    required this.streamBuilder,
    this.elevation = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      body: MyCard(
        elevation: elevation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (header != null) ...[
              header!,
              verticalHeight16,
            ],
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: StreamBuilder<M>(
                  stream: stream,
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const MyCircularIndicator();
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: myText(
                          snapshot.error.toString(),
                          color: Consts.errorColor,
                        ),
                      );
                    }

                    return streamBuilder(snapshot.requireData);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
