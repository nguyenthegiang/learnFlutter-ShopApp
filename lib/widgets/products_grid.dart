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
      /*Với mỗi ProductItem thì tạo cho nó 1 Data Provider với data là 1 Product
      ở đây -> thay vì phải truyền các giá trị xuống thì nó có thể lấy dữ liệu
      về Product thông qua Provider, và mỗi khi isFavorite thay đổi thì nó sẽ
      được thông báo -> rebuild*/
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        /*Dùng ChangeNotifierProvider.value vì nó sẽ có argument value thay vì
        create -> value thì chỉ nhận Data thôi chứ ko cần function (context) => Data
        -> đỡ bị thừa cái context
        Và có 2 điều kiện phù hợp để dùng:
          - Dùng Provider với Grid
          - Data truyền vào là 1 Object đã đc khởi tạo từ trc rồi*/
        value: products[i],
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
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
