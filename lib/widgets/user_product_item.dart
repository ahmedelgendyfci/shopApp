import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        radius: 15,
      ),
      title: Text(this.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    EditProductScreen().screenId,
                    arguments: this.id,
                  );
                }),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(this.id);
                  } catch (error) {
                    // ignore: deprecated_member_use
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Deleting Faild',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
