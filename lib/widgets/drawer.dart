import 'package:flutter/material.dart';
import 'package:myshop/providers/auth.dart';
import 'package:myshop/screens/auth_screen.dart';
import 'package:myshop/screens/orders_screen.dart';
import 'package:myshop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import '../screens/product_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('hello friend!'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushNamed(ProductOverviewScreen().screenId);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushNamed(OrdersScreen().screenId);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushNamed(UserProductsScreen().screenId);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(AuthScreen().screenId);
            },
          ),
        ],
      ),
    );
  }
}
