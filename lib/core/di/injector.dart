// lib/core/di/injector.dart — agregar auth
import 'package:coffeshop/core/network/api_client.dart';
import 'package:coffeshop/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coffeshop/features/auth/domain/repositories/auth_repository.dart';
import 'package:coffeshop/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:coffeshop/features/orders/data/repositories/order_repository_impl.dart';
import 'package:coffeshop/features/orders/domain/repositories/order_repository.dart';
import 'package:coffeshop/features/orders/presentation/viewmodels/order_viewmodel.dart';
import 'package:coffeshop/features/products/data/repositories/product_repository_impl.dart';
import 'package:coffeshop/features/products/domain/repositories/product_repository.dart';
import 'package:coffeshop/features/products/presentation/viewmodels/product_viewmodel.dart';
import 'package:coffeshop/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:coffeshop/features/profile/domain/repository/profile_repository.dart';
import 'package:coffeshop/features/profile/presentation/viewmodel/profile_viewmodel.dart';

class Injector {
  Injector._();

  static final ApiClient apiClient = ApiClient();

  static final AuthRepository authRepository = AuthRepositoryImpl(apiClient);
  static final AuthViewModel  authViewModel  = AuthViewModel(authRepository);

  static final ProductRepository productRepository = ProductRepositoryImpl(apiClient);
  static final ProductViewModel  productViewModel  = ProductViewModel(productRepository);

  static final OrderRepository orderRepository = OrderRepositoryImpl(apiClient);
  static final OrderViewModel  orderViewModel  = OrderViewModel(orderRepository);

  static final ProfileRepository profileRepository = ProfileRepositoryImpl(apiClient);
  static final ProfileViewModel profileViewModel = ProfileViewModel(profileRepository);

  // ← NUEVO: conecta el 401 con el logout
  static void init() {
    apiClient.onUnauthorized = () {
      authViewModel.logout();
    };
  }
}