import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);

  static const routeName = 'product-detail';

  @override
  Widget build(BuildContext context) {
    //lấy id trong argument từ named route
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    //tìm Product có id tương ứng thông qua Product Provider
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
      /*Cho dù list product có thay đổi thì cái màn hình ProductDetail này
      cũng ko bao giờ thay đổi (vì add thêm product thì cx ko ảnh hưởng đến
      product đang có) => screen này ko cần phải rebuild mỗi khi list product
      thay đổi */
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${loadedProduct.price}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
