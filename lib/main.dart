import 'package:flutter/material.dart';
//import Provider Package để dùng
import 'package:provider/provider.dart';

import './screens/orders_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /* Dùng MultiProvider để có thể sử dụng nhiều Provider cho 1 child */
    return MultiProvider(
      providers: [
        /* Provider cho auth */
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),

        /* Wrap MaterialApp với Widget này để biến providers/products.dart trở thành
        1 Provider, và tạo 1 Data Container ở đây -> Khi Data Container thay đổi, 
        những child của nó mà listen cái data container này sẽ đc rebuild
        (Widget này cũng giúp các child của nó có thể tạo Listener) */

        /* Chỗ này cũng có thể dùng ChangeNotifierProvider.value thay vì 
        ChangeNotifierProvider cho đỡ thừa cái context, nhưng Data ở đây là 1 
        Object mà khi truyền vào mới đc khởi tạo -> nên dùng ChangeNotifierProvider
        thì nó hợp lý hơn và tránh bug */

        /* Dùng ChangeNotifierProxyProvider thay vì ChangeNotifierProvider để có
        thể làm cho cái Provider này phụ thuộc vào 1 Provider khác (Products phụ
        thuộc vào Auth), từ đó -> mỗi khi Provider Auth thay đổi thì Provider 
        Products Reload -> lấy đc những property trong Auth (mình cần lấy 
        Token để cho vào URL khi thực hiện Request)
        - Để thực hiện đc điều này thì Provider Auth cần phải khai báo trc (ở trên)
        - trong < > sẽ là 2 class: Auth là Provider mà mình muốn phụ thuộc, Products
        là class mình muốn return về của Provider này */
        ChangeNotifierProxyProvider<Auth, Products>(
          /*Phải có argument này: 
            - Với provider package version <= 3.0 : builder
            - Với version >= 4.0 : create   (chỉ khác tên thôi)
          argument này nhận 1 function: nhận về context và trả về 1 đối tượng của 
          Provider Class -> các child có thể tạo Listener để listen cùng 1 cái đối 
          tượng này*/

          /* version >= 4.0 : update
          truyền vào 3 argument:
            - context
            - Object của Provider Auth để mình dùng
            - Object cũ của Provider này (Products) trc khi reload -> để mình
            có thể update lại những thuộc tính ko đổi để nó ko bị mất 
            
            bên cạnh đó: create nữa (video bị thiếu cái này)*/

          create: (_) => Products('', '', []),
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            /* ở đây mình phải update để giữ lại List Product
            nhưng ở lần khởi chạy đầu tiên thì list null -> phải check null,
            nếu null thì return về list rỗng thôi */
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        /* Tạo Provider cho Cart */
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        /* Tạo Provider cho Order */
        ChangeNotifierProxyProvider<Auth, Orders>(
          //tương tự như Products
          create: (_) => Orders('', '', []),
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      //child : nó sẽ Listen cho tất cả các Provider trong list trên kia
      child: Consumer<Auth>(
        /*Đặt consumer của Auth cho MaterialApp() -> mỗi khi có thay đổi trong
        Auth() (login, logout, signup) thì MaterialApp() reload*/
        builder: (ctx, auth, _) => MaterialApp(
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
          /* Kiểm tra xem đã login chưa -> nếu rồi thì chuyển về Home */
          /* auto login: nếu chưa login thì thử gọi tryAutoLogin(), trong lúc đợi
          Future thì hiển thị màn hình chờ, đợi xong thì hiển thị AuthScreen()
          (ko cần check xem nó return true hay false, vì nếu nó auto login thành
          công thì nó sẽ gọi notifyListener() -> widget này sẽ tự rebuild, và
          khi nó check lại auth.isAuth thì sẽ return true -> về ProductsOverView) */
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
