import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  final String screenId = 'cartScreen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    var children2 = [
      Text(
        'Total',
        style: TextStyle(fontSize: 20),
      ),
      Spacer(),
      SizedBox(
        width: 10,
      ),
      Chip(
        label: Text(
          cart.totalAmount.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      // ignore: deprecated_member_use
      OrderNow(cart: cart),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: children2,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return CartItemW(
                  cart.items.values.toList()[index].id,
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].quantity,
                  cart.items.values.toList()[index].title,
                );
              },
              itemCount: cart.getItemsCount(),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderNow extends StatefulWidget {
  const OrderNow({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderNowState createState() => _OrderNowState();
}

class _OrderNowState extends State<OrderNow> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(
                  color: widget.cart.totalAmount > 0
                      ? Theme.of(context).primaryColor
                      : null),
            ),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );

              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
            },
    );
  }
}
