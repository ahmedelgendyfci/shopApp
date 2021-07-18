import 'package:flutter/material.dart';
import '../providers/orders.dart';
import '../widgets/drawer.dart';
import '../widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  final String screenId = 'orderesScreen';
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // make it like this if i have a scenario data
  //whitch it could be rebuild and i don't want to fetch new data

  //start scenarion
  // 1
  Future _orderFuture;
// 2
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    // 3
    _orderFuture = _obtainOrdersFuture();
    super.initState();
  }
  //end scenarion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      // 4
      body: FutureBuilder(
        future: _orderFuture, // 5
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occurred'),
              );
            } else {
              return Consumer<Orders>(
                builder: (context, order, child) => ListView.builder(
                  itemBuilder: (context, index) {
                    return OrderItemWidget(order.orders[index]);
                  },
                  itemCount: order.orders.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
