import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//mình ko cần OrderItem trong orders.dart -> ko show để đỡ bị trùng tên vs Widget
import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

//màn hình hiển thị các order
class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  //để hiển thị loading spinner lúc lấy data từ server
  var _isLoading = false;

  /* Dùng initState() với Future.delayed hack để lấy list Orders từ Server và
  hiển thị */
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();

      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //set up Listener
    final orderData = Provider.of<Orders>(context);
    //print(orderData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      //Drawer: cái menu từ phía bên trái
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
            ),
    );
  }
}
