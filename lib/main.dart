import 'package:flutter/material.dart';
//import Provider Package để dùng
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /* Dùng MultiProvider để có thể sử dụng nhiều Provider cho 1 child */
    return MultiProvider(
      providers: [
        /* Wrap MaterialApp với Widget này để biến providers/products.dart trở thành
        1 Provider, và tạo 1 Data Container ở đây -> Khi Data Container thay đổi, 
        những child của nó mà listen cái data container này sẽ đc rebuild
        (Widget này cũng giúp các child của nó có thể tạo Listener) */

        /* Chỗ này cũng có thể dùng ChangeNotifierProvider.value thay vì 
        ChangeNotifierProvider cho đỡ thừa cái context, nhưng Data ở đây là 1 
        Object mà khi truyền vào mới đc khởi tạo -> nên dùng ChangeNotifierProvider
        thì nó hợp lý hơn và tránh bug */
        ChangeNotifierProvider(
          /*Phải có argument này: 
            - Với provider package version <= 3.0 : builder
            - Với version >= 4.0 : create   (chỉ khác tên thôi)
          argument này nhận 1 function: nhận về context và trả về 1 đối tượng của 
          Provider Class -> các child có thể tạo Listener để listen cùng 1 cái đối 
          tượng này*/
          create: (ctx) => Products(),
        ),
        /* Tạo Provider cho Cart */
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
      ],
      //child : nó sẽ Listen cho tất cả các Provider trong list trên kia
      child: MaterialApp(
        title: 'MyShop',
        /* My modification: accentColor bị deprecated rồi nên mình dùng
        colorScheme.secondary */
        theme: ThemeData(
          /* Muốn truy cập vào primaryColor: colorScheme.primary;
            Muốn truy cập vào accentColor: colorScheme.secondary; */
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.deepOrange),
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
        },
      ),
    );
  }
}
