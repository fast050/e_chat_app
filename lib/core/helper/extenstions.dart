import 'package:flutter/material.dart';

extension Navigation on BuildContext{
  Future<dynamic> pushNamed(String routeName, {Object? arguments}){
    return Navigator.pushNamed(this, routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}){
    return Navigator.pushReplacementNamed(this, routeName, arguments: arguments);
  }

  /// Pushes a named route and removes previous routes until [predicate] returns true.
  ///
  /// Examples:
  ///  - Clear all previous routes so the new route becomes the only one (back will close the app):
  ///      context.pushNamedAndRemoveUntil(Routes.home, predicate: (route) => false);
  ///  - Remove routes until a specific named route is reached:
  ///      context.pushNamedAndRemoveUntil(Routes.home, predicate: ModalRoute.withName('/login'));
  ///
  /// [routeName] is the name of the route to push. [arguments] are forwarded to the pushed route.
  /// The returned Future completes when the pushed route is popped (same as Navigator.pushNamed).
  Future<dynamic> pushNamedAndRemoveUntil(String routeName, {Object? arguments, required RoutePredicate predicate}){
    return Navigator.pushNamedAndRemoveUntil(this, routeName, predicate, arguments: arguments);
  }

  void pop() => Navigator.pop(this);
}