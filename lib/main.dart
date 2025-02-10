import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'navigations/route_generator.dart';

final localhostServer = InAppLocalhostServer(documentRoot: 'assets');
main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    navigatorKey: GlobalKey<NavigatorState>(),
    theme: ThemeData(fontFamily: 'Gilroy', colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, primary: Colors.black)),
    debugShowCheckedModeBanner: false,
    initialRoute: '/warehouse',
    onGenerateRoute: RouteGenerator.generateRoute,
    navigatorObservers: [MyNavigationObserver()],
  ));
}

class MyNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    print('Pushed Route: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    print('Popped Route: ${route.settings.name}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    print('Removed Route: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print("newRoute:  ${newRoute!.settings.name} oldRoute: ${oldRoute!.settings.name}");
  }
}
