import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';

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

          const Divider(), //1 cái dòng như <hr>
          ListTile(
            //Ấn vào cái này để đến Order Screen
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
