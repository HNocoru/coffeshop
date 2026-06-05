import 'package:coffeshop/core/routes/app_routes.dart' show AppRoutes;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/view_state.dart';
import '../viewmodels/product_viewmodel.dart';
import '../widgets/product_card.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductViewModel>().loadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductViewModel>(
        builder: (_, vm, _) {
          if (vm.state == ViewState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.state == ViewState.error) {
            return Center(child: Text(vm.errorMessage ?? 'Error'));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 120,
                // ✅ Back explícito — regresa a OrderList
                leading: IconButton(
                  onPressed: () {
                    final nav = Navigator.of(context);
                    if (nav.canPop()) {
                      nav.pop();
                    } else {
                      nav.pushReplacementNamed(AppRoutes.orderList);
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.orderList,
                      (route) => false,
                    ),
                    icon: const Icon(Icons.receipt_long),
                    tooltip: 'Ver pedidos',
                  ),
                ],
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Menú'),
                ),
              ),

              // Filtros de categoría
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('Todos'),
                        selected: vm.selectedCategoryId == null,
                        onSelected: (_) => vm.filterByCategory(null),
                      ),
                      const SizedBox(width: 8),
                      ...vm.categories.map((category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category.name),
                          selected: vm.selectedCategoryId == category.id,
                          onSelected: (_) => vm.filterByCategory(category.id),
                        ),
                      )),
                    ],
                  ),
                ),
              ),

              // Grid de productos
              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) => ProductCard(product: vm.filteredProducts[index]),
                    childCount: vm.filteredProducts.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}