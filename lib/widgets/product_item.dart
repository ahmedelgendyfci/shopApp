import 'package:flutter/material.dart';
import 'package:myshop/providers/auth.dart';
import 'package:myshop/providers/cart.dart';
import '../screens/product_details_screen.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    // print('rebuild context');
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductDetails().screenId,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
                size: 20,
              ),
              onPressed: () {
                product.toggleFavoriteStatus(authData.token, authData.userId);
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
            onPressed: () {
              cart.addItems(product.id, product.title, product.price);
              // ignore: deprecated_member_use
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('${product.title} Added To The Cart!'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
