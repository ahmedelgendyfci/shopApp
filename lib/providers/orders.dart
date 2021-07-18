import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  var _token;
  var _userId;
  bool flag = true;

  void update(authToken, userId, [orders]) {
    if (flag) {
      _orders = orders;
      _userId = userId;
      _token = authToken;

      print('-------------------------- data order --------------------');
      print(_userId);
      print(_token);
      notifyListeners();
    }
    flag = false;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flutterupdate-aa74a-default-rtdb.firebaseio.com/orders.json?auth=$_token');
    final timestamp = DateTime.now();
    await http.post(
      url,
      body: json.encode({
        "createdBy": _userId,
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cartProduct) => {
                  'id': cartProduct.id,
                  'title': cartProduct.title,
                  'quantity': cartProduct.quantity,
                  'price': cartProduct.price,
                })
            .toList(),
      }),
    );

    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://flutterupdate-aa74a-default-rtdb.firebaseio.com/orders.json?auth=$_token&orderBy="createdBy"&equalTo="$_userId"');

    final response = await http.get(url);

    // print(json.decode(response.body));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    List<OrderItem> loadedOrders = [];

    // extractedData.map((orderId, orderData) => null);

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ),
                )
                .toList()),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
