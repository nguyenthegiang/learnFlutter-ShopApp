import 'package:flutter/material.dart';
//dùng cho date format
import 'package:intl/intl.dart';

/*vì 2 class OrderItem bị trùng tên, mà mình phải dùng cả 2 -> dùng cách này
để phân biệt*/
import '../providers/orders.dart' as ord;

//Dùng trong OrdersScreen
class OrderItem extends StatelessWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(order.dateTime),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.expand_more),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
