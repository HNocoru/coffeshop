import 'package:coffeshop/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/injector.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('access_token');

  final hasToken =
      token != null && token.isNotEmpty;

  final initialRoute =
      hasToken
          ? AppRoutes.orderList
          : AppRoutes.login;

  Injector.init();

  runApp(
    RestaurantApp(
      initialRoute: initialRoute,
    ),
  );
}

class RestaurantApp extends StatelessWidget {
  final String initialRoute;

  const RestaurantApp({
    super.key,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Injector.authViewModel,
        ),
        ChangeNotifierProvider.value(
          value: Injector.productViewModel,
        ),
        ChangeNotifierProvider.value(
          value: Injector.orderViewModel,
        ),
      ],

      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'RestaurantApp',

        debugShowCheckedModeBanner: false,

        theme: AppTheme.light,

        darkTheme: AppTheme.dark,

        initialRoute: initialRoute,

        onGenerateRoute:
            AppRouter.generate,
      ),
    );
  }
}