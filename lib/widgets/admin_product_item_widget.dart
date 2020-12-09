import 'package:eCommerce/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem({
    this.id,
    this.title,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          child: IconButton(
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: () {
              try {
                Provider.of<Products>(context, listen: false).deleteProduct(id);
              } catch (error) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleting failed!'),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
