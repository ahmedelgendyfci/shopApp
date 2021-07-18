import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/widgets/badge.dart';
import 'package:myshop/widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  final String screenId = 'productOverviewScreen';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavs = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshIndecatorFunction(context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('MyShop'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorite'),
                value: FilterOptions.favorite,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.all,
              ),
            ],
            onSelected: (FilterOptions selected) {
              setState(() {
                if (selected == FilterOptions.favorite) {
                  _showOnlyFavs = true;
                  // print(_showOnlyFavs);
                } else {
                  _showOnlyFavs = false;
                  // print(_showOnlyFavs);
                }
              });
              // print('before sending:${_showOnlyFavs}');
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, ch) => Badge(
              child: ch,
              value: cart.getItemsCount().toString(),
            ),
            child: GestureDetector(
              child: Icon(Icons.shopping_cart),
              onTap: () {
                Navigator.of(context).pushNamed(CartScreen().screenId);
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _refreshIndecatorFunction(context),
              child: ProductsGrid(_showOnlyFavs)),
    );
    return scaffold;
  }
}
