import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String desc;
  final double price;
  final String imgUrl;
  bool isFavourite;
  Product({
    @required this.id,
    @required this.title,
    @required this.desc,
    @required this.imgUrl,
    this.isFavourite = false,
    @required this.price,
  });

  void toggleFavStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
