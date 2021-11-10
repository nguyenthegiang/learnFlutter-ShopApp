import 'package:flutter/material.dart';
//import provider package để dùng
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*Tạo Listener (chỉ có child (trực tiếp hoặc gián tiếp) của data provider 
    tương ứng mới tạo listener đc) => build() method này sẽ rebuild khi 
    data provider thay đổi
    Phải chỉ rõ là mình listen cái provider Products -> khi run nó sẽ tìm đến 
    cái Widget cha của nớ để tìm cái provider này, ko thấy thì nó lại chạy ngược
    tiếp lên cha của cha của nó...*/

    final productsData = Provider.of<Products>(context);
    /* giờ đây productsData sẽ là 1 bản sao của List Product trong 
    providers/products.dart (lấy thông qua getter mà mình tạo ở đó) */

    final products = productsData.items;
    /*truy cập thông qua .items -> giờ products sẽ là list product mà mình sử dụng */

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductItem(
        products[i].id,
        products[i].title,
        products[i].imageUrl,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
