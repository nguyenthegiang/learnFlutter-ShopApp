import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//mình ko cần OrderItem trong orders.dart -> ko show để đỡ bị trùng tên vs Widget
import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

//màn hình hiển thị các order
class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    //set up Listener
    //final orderData = Provider.of<Orders>(context);

    //print(orderData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      //Drawer: cái menu từ phía bên trái
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshop) {
          if (dataSnapshop.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshop.error != null) {
              //...
              //Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
