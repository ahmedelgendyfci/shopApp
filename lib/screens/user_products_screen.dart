import 'package:flutter/material.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:myshop/widgets/drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatefulWidget {
  final String screenId = 'userProductsScreen';
  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  Future<void> _refreshIndecatorFunction(context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen().screenId);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshIndecatorFunction(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshIndecatorFunction(context),
                child: Consumer<Products>(
                  builder: (context, productsData, child) => ListView.builder(
                    itemCount: productsData.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          UserProductItem(
                            productsData.items[index].id,
                            productsData.items[index].title,
                            productsData.items[index].imageUrl,
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
