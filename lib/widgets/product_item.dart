import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    /* Sử dụng Provider.of để lấy dữ liệu từ Data Provider, nhưng set 
    listen = false để nó ko phải rebuild cả Widget, phần nào cần rebuild thì 
    Wrap với Consumer*/
    final product = Provider.of<Product>(context, listen: false);

    //sử dụng Cart Provider
    final cart = Provider.of<Cart>(context, listen: false);

    /*1 cách khác để làm Listener: lấy dữ liệu từ Data Provider; khả năng y hệt 
    như Provider.of -> Đó là Consumer:
      - Wrap cái Widget sử dụng dữ liệu = 1 Widget Consumer 
        (package:provider/provider.dart)
      - Widget này có 1 argument là builder: là 1 function nhận vào 3 tham số: 
      context, Object dữ liệu từ Data Provider, và child (ko cần quan tâm đến 
      child), function này return về cái Widget mà mình muốn Wrap ấy*/
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          //Nhấn vào thì chuyển sang product_detail_screen
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          /* Phần này cần rebuild nên mình sẽ Wrap với Consumer để nó có thể 
          rebuild */
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                /*Khi nhấn vào nút Favorite thì gọi đến toggleFavoriteStatus()
                để thực hiện thay đổi giá trị của isFavorite*/
                product.toggleFavoriteStatus();
                /*Và toggleFavoriteStatus() sẽ gọi đến notifyListener() -> 
                khiến cho Widget này rebuild -> thay đổi icon hiển thị tương ứng */
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              //Thêm sản phẩm vào cart thông qua Provider
              cart.addItem(product.id, product.price, product.title);

              //Hiển thị Pop up
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added item to cart!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
