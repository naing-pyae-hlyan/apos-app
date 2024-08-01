import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

extension ContextExt on BuildContext {
  void pop({dynamic result}) => Navigator.of(this).pop(result);

  Future<dynamic> push(Widget page) =>
      Navigator.of(this).push(CustomPageRoute(page));

  Future<dynamic> pushReplacement(Widget page) =>
      Navigator.of(this).pushReplacement(CustomPageRoute(page));

  Future<dynamic> pushAndRemoveUntil(Widget page) =>
      Navigator.of(this).pushAndRemoveUntil(
        CustomPageRoute(page),
        (route) => false,
      );

  void hideKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  MediaQueryData get queryData => MediaQuery.of(this);

  Size get screenSize => queryData.size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  bool get isKeyboardOpening {
    return queryData.viewInsets.bottom != 0;
  }
}

class CustomPageRoute<T> extends PageRoute<T> {
  final Widget child;
  CustomPageRoute(this.child);

  @override
  @SemanticsHintOverrides()
  Color? get barrierColor => Colors.transparent;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(opacity: animation, child: child);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}
