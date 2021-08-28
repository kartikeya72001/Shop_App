import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  ProductItem(this.id, this.title, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(imgUrl),
    );
  }
}
