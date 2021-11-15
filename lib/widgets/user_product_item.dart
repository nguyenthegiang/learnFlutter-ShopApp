import 'package:flutter/material.dart';

//Hiển thị 1 Product item trong List ở user_products_screen.dart
class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  //Lấy dữ liệu về 1 Product item từ user_products_screen thông qua Constructor
  UserProductItem(this.title, this.imageUrl);

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
              onPressed: () {},
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            //Delete
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
