import 'package:flutter/material.dart';

import 'app_routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void redirectToLogin() {
  navigatorKey.currentState?.pushNamedAndRemoveUntil(
    AppRoutes.login,
    (route) => false,
  );
}
