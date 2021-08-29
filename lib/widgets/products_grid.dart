import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showFav;
  ProductsGrid(this._showFav);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final loadedProducts =
        _showFav ? productsData.Filteritems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, idx) {
        return ChangeNotifierProvider.value(
          // create: (ctx) => loadedProducts[idx],
          value: loadedProducts[idx],
          child: ProductItem(
              // loadedProducts[idx].id,
              // loadedProducts[idx].title,
              // loadedProducts[idx].imgUrl,
              ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
