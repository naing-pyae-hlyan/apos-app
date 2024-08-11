import 'package:apos_app/lib_exp.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => ErrorBloc()),
        BlocProvider(create: (_) => DbBloc()),
        BlocProvider(create: (_) => OrderBloc()),
        BlocProvider(create: (_) => CartBloc()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "aPOS-App",
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Consts.primaryColor,
      ),
      home: GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayColor: Colors.transparent,
        overlayWidgetBuilder: (_) => const LoadingWidget(),
        child: const SafeArea(
          child: SplashPage(),
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black12,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimationWidget.threeArchedCircle(
              color: Consts.primaryColor,
              size: 50,
            ),
            verticalHeight32,
            myText("Loading"),
          ],
        ),
      ),
    );
  }
}
