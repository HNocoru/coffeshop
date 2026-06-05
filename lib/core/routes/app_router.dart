import 'package:coffeshop/core/routes/app_routes.dart';
import 'package:coffeshop/features/auth/presentation/pages/login_page.dart';
import 'package:coffeshop/features/auth/presentation/pages/register_page.dart';
import 'package:coffeshop/features/orders/presentation/pages/create_order_page.dart';
import 'package:coffeshop/features/orders/presentation/pages/cashier_page.dart';
import 'package:coffeshop/features/orders/presentation/pages/order_detail_page.dart';
import 'package:coffeshop/features/orders/presentation/pages/order_list_page.dart';
import 'package:coffeshop/features/products/presentation/pages/menu_page.dart';
import 'package:coffeshop/features/profile/presentation/page/profile_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case AppRoutes.menu:
        return MaterialPageRoute(builder: (_) => const MenuPage());

      case AppRoutes.orderList:
        return MaterialPageRoute(builder: (_) => const OrderListPage());

      case AppRoutes.createOrder:
        return MaterialPageRoute(builder: (_) => const CreateOrderPage());

      case AppRoutes.cashier:
        return MaterialPageRoute(builder: (_) => const CashierPage());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case AppRoutes.orderDetail:
        final args = settings.arguments;

        if (args is! int) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('orderDetail requiere int como argumento'),
              ),
            ),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OrderDetailPage(orderId: args),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Ruta no encontrada: ${settings.name}')),
          ),
        );
    }
  }
}
