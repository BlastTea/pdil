
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NavigationHelper {
  static to(Route route) {
    navigatorKey.currentState!.push(route);
  }

  static replaceTo(Route route) {
    navigatorKey.currentState!.pushReplacement(route);
  }

  static back() {
    navigatorKey.currentState!.pop();
  }

}