import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart' as od;

class OrdersScreen extends StatelessWidget {
  static const routaName = "/orders";

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        builder: (context, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).accentColor,
              ),
            );
          } else {
            if (dataSnapShot.error != null) {
              //Error HAndling
              return Center(
                child: Text("An Error Occured"),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, idx) => od.OrderItem(
                    orderData.orders[idx],
                  ),
                ),
              );
            }
          }
        },
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
      ),
    );
  }
}
