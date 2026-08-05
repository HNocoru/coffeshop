import 'package:coffeshop/core/routes/app_routes.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/injector.dart';
import 'core/routes/app_router.dart';
import 'core/routes/navigation.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Injector.init();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');
  final hasToken = token != null && token.isNotEmpty;

  var initialRoute = hasToken ? AppRoutes.orderList : AppRoutes.login;

  if (hasToken) {
    try {
      await Injector.profileViewModel
          .loadProfile()
          .timeout(const Duration(seconds: 5));
      if (Injector.profileViewModel.isCashier) {
        initialRoute = AppRoutes.cashier;
      }
    } catch (_) {
      // Sin red o fallo de perfil → se mantiene orderList como default
    }
  }

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (_) => RestaurantApp(initialRoute: initialRoute),
    ),
  );
}

class RestaurantApp extends StatelessWidget {
  final String initialRoute;

  const RestaurantApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Injector.authViewModel),
        ChangeNotifierProvider.value(value: Injector.productViewModel),
        ChangeNotifierProvider.value(value: Injector.orderViewModel),
        ChangeNotifierProvider.value(value: Injector.profileViewModel),
      ],

      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'RestaurantApp',

        debugShowCheckedModeBanner: false,

        theme: AppTheme.light,

        darkTheme: AppTheme.dark,

        initialRoute: initialRoute,

        onGenerateRoute: AppRouter.generate,

        locale: DevicePreview.locale(context),

        builder: DevicePreview.appBuilder,
      ),
    );
  }
}
