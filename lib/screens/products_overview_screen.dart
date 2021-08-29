import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart.dart';
import 'package:shop_app/widgets/21.1%20badge.dart';

import '../widgets/products_grid.dart';

enum filterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavData = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (filterOptions selectedVal) {
              setState(() {
                if (selectedVal == filterOptions.Favorites) {
                  _showOnlyFavData = true;
                } else {
                  _showOnlyFavData = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favorites"),
                value: filterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: filterOptions.All,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cartData, chd) => Badge(
              child: chd,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavData),
    );
  }
}
