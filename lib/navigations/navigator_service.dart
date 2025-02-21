import 'package:flutter/material.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

  Future<dynamic> push(String routeName, {String? arguments}) {
    return navigatorkey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  void popUntil(String routeName) {
    navigatorkey.currentState!.popUntil(
      (route) => route.settings.name == routeName,
    );
  }

  Future<dynamic> popAndPush(String routeName) {
    return navigatorkey.currentState!.popAndPushNamed(routeName);
  }

  void pop() {
    navigatorkey.currentState!.pop();
  }

  Future<dynamic> pushAndRemoveUntil(String routeName, String removeUntilRouteName, {String? arguments}) {
    return navigatorkey.currentState!.pushNamedAndRemoveUntil(routeName, (route) => route.settings.name == removeUntilRouteName, arguments: arguments);
  }

  Future<dynamic> pushReplacement(String routeName, {String? arguments}) {
    return navigatorkey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }
}
