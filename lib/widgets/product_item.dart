import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imgUrl;

  // ProductItem(this.id, this.title, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authToken = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: prod.id,
            );
          },
          child: Image.network(
            prod.imgUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (ctx, prod, child) => IconButton(
              icon: Icon(
                prod.isFavourite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Colors.red,
              onPressed: () {
                prod.toggleFavStatus(authToken.token, authToken.userId);
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.additem(prod.id, prod.title, prod.price);
              // Scaffold.of(context).showSnackBar(snackbar);
              // Scaffold.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Added Item to Cart",
                  ),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(prod.id);
                    },
                  ),
                  duration: Duration(milliseconds: 1500),
                ),
              );
            },
          ),
          title: Text(
            prod.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      // child: ,
    );
  }
}
