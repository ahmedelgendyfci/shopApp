import 'package:flutter/material.dart';
import '../widgets/product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavs;

  ProductsGrid(this.showOnlyFavs);

  @override
  Widget build(BuildContext context) {
    // print(showOnlyFavs);
    final productsData = Provider.of<Products>(context);
    // to filter products
    final products = showOnlyFavs ? productsData.itemsFav : productsData.items;

    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
    );
  }
}
