import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void updateStatus(oldStatus) {
    this.isFavorite = oldStatus;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String _userId) async {
    final oldStatus = isFavorite;
    this.isFavorite = !this.isFavorite;
    notifyListeners();

    final url = Uri.parse(
        'https://flutterupdate-aa74a-default-rtdb.firebaseio.com/userFavorite/$_userId/$id.json?auth=$token');

    try {
      final response = await http.put(
        url,
        body: json.encode(isFavorite),
      );

      if (response.statusCode >= 400) {
        updateStatus(oldStatus);
      }
    } catch (error) {
      updateStatus(oldStatus);
    }
  }
}
