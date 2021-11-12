import 'dart:math'; //dùng min()

import 'package:flutter/material.dart';
//dùng cho date format
import 'package:intl/intl.dart';

/*vì 2 class OrderItem bị trùng tên, mà mình phải dùng cả 2 -> dùng cách này
để phân biệt*/
import '../providers/orders.dart' as ord;

//Dùng trong OrdersScreen
class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  //biến để quyết định xem có expand cái order item ko
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              //tùy thuộc xem đang expand hay ko mà hiển thị
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  //ấn vào nút này thì hiển thị thêm
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          //if() trong list -> tính năng từ Dart 2.2.2
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              /*chiều cao hiển thị phụ thuộc vào số lượng product trong item,
              càng nhiều thì cái container càng to, nhưng ko quá 180, quá thì
              scroll*/
              height: min(widget.order.products.length * 20.0 + 10, 100),
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prod.quantity}x \$${prod.price}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
