import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_Exception.dart';
import 'dart:convert';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   desc: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imgUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   desc: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imgUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   desc: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imgUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   desc: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imgUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get Filteritems {
    return _items.where((element) => element.isFavourite).toList();
  }

  List<Product> get items {
    // if (_showFavoritesOnly)
    //   return _items.where((element) => element.isFavourite).toList();
    return [..._items];
  }

  Product filterProducts(String productId) {
    return _items.firstWhere((prod) => prod.id == productId);
  }

  Future<void> fetchAndGetProducts() async {
    const url =
        'https://shop-app-5489d-default-rtdb.firebaseio.com/products.json';
    try {
      final resposne = await http.get(Uri.parse(url));
      final extractedData = json.decode(resposne.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((id, prod) {
        loadedProducts.add(Product(
          id: id,
          title: prod['title'],
          desc: prod['desc'],
          imgUrl: prod['imgUrl'],
          price: prod['price'],
          isFavourite: prod['isFavourite'],
        ));
      });
      // ignore: unnecessary_statements
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // void showFavOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> addProducts(product) async {
    const url =
        'https://shop-app-5489d-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'desc': product.desc,
          'imgUrl': product.imgUrl,
          'price': product.price,
          'isFavourite': product.isFavourite,
        }),
      );
      final newProduct = Product(
        title: product.title,
        desc: product.desc,
        price: product.price,
        imgUrl: product.imgUrl,
        id: (json.decode(response.body))['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final idx = _items.indexWhere((prod) => prod.id == id);
    if (idx >= 0) {
      final url =
          'https://shop-app-5489d-default-rtdb.firebaseio.com/products/$id.json';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'desc': newProduct.desc,
            'price': newProduct.price,
            'imgUrl': newProduct.imgUrl,
          }));
      _items[idx] = newProduct;
      notifyListeners();
    }
    return;
  }

  Future<void> deleteProd(String id) async {
    final url =
        'https://shop-app-5489d-default-rtdb.firebaseio.com/products/$id.json';
    var existingProductIdx = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIdx];
    final response = await http.delete(Uri.parse(url));

    _items.removeAt(existingProductIdx);
    notifyListeners();
    if (response.statusCode >= 400) {
      _items.insert(existingProductIdx, existingProduct);
      notifyListeners();
      throw HttpExepction('Couldn\'t Delete Product');
    }
    existingProduct = null;
    existingProductIdx = null;
  }
}
