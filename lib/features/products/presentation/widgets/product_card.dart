import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cs =
        Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,

                  child:
                      product.imageUrl.isEmpty
                          ? const Center(
                              child: Icon(
                                Icons
                                    .image_not_supported,
                                size: 48,
                              ),
                            )
                          : Image.network(
                              product.imageUrl,

                              fit: BoxFit.cover,

                              errorBuilder:
                                  (
                                    _,
                                    _,
                                    _,
                                  ) {
                                    return const Center(
                                      child: Icon(
                                        Icons
                                            .broken_image,
                                      ),
                                    );
                                  },
                            ),
                ),

                if (!product.available)
                  Positioned(
                    top: 8,
                    right: 8,

                    child: Chip(
                      label: const Text(
                        'No disponible',
                      ),

                      backgroundColor:
                          cs.errorContainer,
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(12),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  product.name,

                  maxLines: 1,

                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      Theme.of(context)
                          .textTheme
                          .titleMedium,
                ),

                const SizedBox(height: 4),

                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                ),

                const SizedBox(height: 8),

                ElevatedButton(
                  onPressed:
                      product.available
                          ? () {}
                          : null,

                  child: const Text(
                    'Agregar',
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