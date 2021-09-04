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
  Map<String, CartItems> _items = {};

  Map<String, CartItems> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmt {
    double total = 0.0;
    _items.forEach((key, value) {
      total += (value.price * value.quantity);
    });
    return total;
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
    notifyListeners();
  }

  void removeItem(String prodId) {
    _items.remove(prodId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(productID) {
    if (!_items.containsKey(productID)) return;
    if (_items[productID].quantity > 1) {
      _items.update(
        productID,
        (value) => CartItems(
          id: value.id,
          title: value.title,
          price: value.price,
          quantity: value.quantity - 1,
        ),
      );
    } else {
      _items.remove(productID);
    }
    notifyListeners();
  }
}
