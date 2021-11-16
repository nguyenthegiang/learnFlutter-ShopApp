import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import '../screens/edit_product_screen.dart';

//Hiển thị 1 Product item trong List ở user_products_screen.dart
class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  //Lấy dữ liệu về 1 Product item từ user_products_screen thông qua Constructor
  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        /*backgroundImage ko nhận về 1 Widget Image mà nhận về 1 object:
          NetworkImage(<image_url>) hoặc AssetImage(<link>)
          => ko thể customize image này đc, nhưng CircleAvatar() sẽ lo việc
          sizing,...*/
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        //Phải có Container để set width nếu ko nó sẽ bị tràn màn hình
        width: 100,
        child: Row(
          children: [
            //Edit
            IconButton(
              onPressed: () {
                //chuyển sang screen edit product và truyền data sang để edit
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: id, //id product
                );
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            //Delete
            IconButton(
              onPressed: () {
                //Delete Product thông qua Provider
                Provider.of<Products>(context, listen: false).deleteProduct(id);
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
