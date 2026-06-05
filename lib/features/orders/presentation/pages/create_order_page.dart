import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../products/presentation/viewmodels/product_viewmodel.dart';
import '../../../../core/utils/view_state.dart';
import '../viewmodels/order_viewmodel.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final TextEditingController tableCtrl = TextEditingController();
  final TextEditingController notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProductViewModel>().loadData();
    });
  }

  @override
  void dispose() {
    tableCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productVM = context.watch<ProductViewModel>();
    final orderVM = context.watch<OrderViewModel>();
    final products = productVM.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear pedido'),
      ),

      body: Column(
        children: [
          // ─────────────────────────────
          // INFO DEL PEDIDO
          // ─────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: tableCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Mesa',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Notas',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // ─────────────────────────────
          // PRODUCTOS — ahora con 3 estados
          // ─────────────────────────────
          Expanded(
            child: Builder(
              builder: (_) {
                // 1. Error de red o servidor
                if (productVM.state == ViewState.error) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          productVM.errorMessage ?? 'Error al cargar productos',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                          onPressed: () =>
                              context.read<ProductViewModel>().loadData(),
                        ),
                      ],
                    ),
                  );
                }

                // 2. Cargando
                if (productVM.state == ViewState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 3. Sin productos en el servidor
                if (products.isEmpty) {
                  return const Center(
                    child: Text('No hay productos disponibles'),
                  );
                }

                // 4. Todo bien — lista de productos
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    final product = products[index];
                    final qty = orderVM.cartQuantity(product.id);

                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('\$${product.price}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: qty > 0
                                ? () => orderVM.removeFromCart(product)
                                : null,
                          ),
                          Text('$qty'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: product.available
                                ? () => orderVM.addToCart(product)
                                : null,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ─────────────────────────────
          // TOTAL + BOTÓN
          // ─────────────────────────────
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Column(
              children: [
                Text(
                  'Total: \$${orderVM.cartTotal}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: orderVM.cartIsEmpty
                        ? null
                        : () async {
                            final table = int.tryParse(tableCtrl.text);

                            if (table == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ingresa un número de mesa válido'),
                                ),
                              );
                              return;
                            }

                            await orderVM.createOrder(
                              table,
                              notesCtrl.text.trim().isEmpty
                                  ? null
                                  : notesCtrl.text.trim(),
                            );

                            if (context.mounted) {
                              Navigator.pushReplacementNamed(context, '/orders');
                            }
                          },
                    child: const Text('Crear pedido'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}