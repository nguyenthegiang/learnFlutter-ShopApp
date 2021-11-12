import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//mình ko cần OrderItem trong orders.dart -> ko show để đỡ bị trùng tên vs Widget
import 'package:shop_app/providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

//màn hình hiển thị các order
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //set up Listener
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
      ),
    );
  }
}
