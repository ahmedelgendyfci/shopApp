import 'dart:convert';

import 'package:flutter/material.dart';

import './product.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  var _token;
  var _userId;
  bool flag = true;

  void update(authToken, userId, [items]) {
    if (flag) {
      _items = items;
      _userId = userId;
      _token = authToken;

      print('-------------------------- data 1 --------------------');
      print(_userId);
      print(_token);
      notifyListeners();
    }
    flag = false;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get itemsFav {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product newProduct) async {
    print('-------------------------- data add --------------------');
    print(_userId);
    print(_token);
    final url = Uri.parse(
        'https://flutterupdate-aa74a-default-rtdb.firebaseio.com/products.json?auth=$_token');
    try {
      var response = await http.post(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
          'isFavorite': newProduct.isFavorite,
          'createdBy': _userId,
        }),
      );
      // print(response.body);
      final newProd = Product(
        id: json.decode(response.body)['name'],
        title: newProduct.title,
        description: newProduct.description,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl,
      );
      _items.add(newProd);
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product editedProduct) async {
    final productIndex =
        _items.indexWhere((product) => editedProduct.id == product.id);

    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://flutterupdate-aa74a-default-rtdb.firebaseio.com/products/$id.json?auth=$_token');
      await http.patch(
        url,
        body: json.encode({
          'title': editedProduct.title,
          'description': editedProduct.description,
          'imageUrl': editedProduct.imageUrl,
          'price': editedProduct.price,
        }),
      );
      _items[productIndex] = editedProduct;
      notifyListeners();
    } else {}
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutterupdate-aa74a-default-rtdb.firebaseio.com/products/$id.json?auth=$_token');

    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Couldn\'t delete product.');
    }
    existingProduct = null;
  }

  Future<void> fetchAndSetProducts([bool filterByUder = false]) async {
    // print('-------------------------- data fetch --------------------');
    // print(_userId);
    // print(_token);

    var filter = '';
    if (filterByUder) {
      filter = 'orderBy="createdBy"&equalTo="$_userId"';
    } else {
      filter = '';
    }

    var url = Uri.parse(
        'https://flutterupdate-aa74a-default-rtdb.firebaseio.com/products.json?auth=$_token&$filter');

    var urlFav = Uri.parse(
        'https://flutterupdate-aa74a-default-rtdb.firebaseio.com/userFavorite/$_userId.json?auth=$_token');

    try {
      final response = await http.get(url);
      final favoriteResponse = await http.get(urlFav);
      // print(favoriteResponse.body);
      // print(json.decode(response.body));
      final extractedData =
          json.decode(response.body.toString()) as Map<String, dynamic>;
      final favResData = json.decode(favoriteResponse.body.toString());
      // print(userId);
      // print(favoriteResponse.body);
      List<Product> loadedProducts = [];
      extractedData.forEach((prodId, product) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: product['title'],
            description: product['description'],
            price: product['price'],
            imageUrl: product['imageUrl'],
            isFavorite: favResData == null
                ? false
                : favResData[prodId] ??
                    false, // if not null and not found make isFavorite false
          ),
        );
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
