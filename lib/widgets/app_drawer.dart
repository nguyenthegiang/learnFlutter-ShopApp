import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/auth.dart';

//Drawer để chuyển giữa product overview và order
class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friend!'),
            automaticallyImplyLeading: false,
            /*Dòng này để nó ko bao h thêm cái nút quay lại (vì nó là AppBar) vì
            nút quay lại sẽ ko hoạt động đc ở đây*/
          ),

          const Divider(), //1 cái dòng như <hr>
          ListTile(
            //Ấn vào cái này để quay về Home Page
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),

          const Divider(),
          ListTile(
            //Ấn vào cái này để đến Order Screen
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),

          const Divider(),
          ListTile(
            //Ấn vào cái này để đến Manage Product Screen
            leading: const Icon(Icons.edit),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),

          const Divider(),
          ListTile(
            //Ấn vào cái này để đến Logout
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              /*trg khi logout thì phải tắt drawer đi ko nó sẽ lỗi
              (video thì lỗi thôi chứ code của mình cx chả lỗi)*/
              Navigator.of(context).pop();
              //chuyển về home route trc khi logout, để tránh bị mấy lỗi linh tinh
              Navigator.of(context).pushReplacementNamed('/');
              //gọi đến logout của auth.dart
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
