import 'package:flutter/material.dart';

class CartItems {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItems({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItems> _items;

  Map<String, CartItems> get items {
    return {...items};
  }

  void additem(String prodId, String title, double price) {
    if (_items.containsKey(prodId)) {
      _items.update(
          prodId,
          (e) => CartItems(
                id: e.id,
                title: e.title,
                quantity: e.quantity + 1,
                price: e.price,
              ));
    } else {
      _items.putIfAbsent(
          prodId,
          () => CartItems(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
  }
}
