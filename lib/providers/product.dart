import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> toggleFavStatus(String token, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    final url =
        'https://shop-app-5489d-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final resp = await http.put(
        Uri.parse(url),
        body: json.encode(
          isFavourite,
        ),
      );
      if (resp.statusCode >= 400) {
        isFavourite = oldStatus;
      }
    } catch (error) {
      isFavourite = oldStatus;
    }
    notifyListeners();
  }
}
