import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Sử dụng Provider để truy cập đến function trong cart.dart
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  /*Dùng Spacer() để khi MainAxisAlignment.spaceBetween căn đều
                  khoảng cách giữa 3 Widget -> Thêm Widget này vào giữa thì
                  cái Text() kia sẽ sang tận cùng bên trái và 2 cái còn lại 
                  sẽ sang tận cùng bên phải*/
                  const Spacer(),
                  Chip(
                    //truy cập đến tổng price thông qua Provider
                    label: Text(
                      '\$ ${cart.totalAmount}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6!
                              .color),
                    ),
                    /* Khác so với code mẫu: muốn truy cập vào primaryColor thì phải
                    colorScheme.primary */
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  /* FlatButton deprecated rồi nên mình chuyển sang TextButton
                  làm theo migration guide */
                  TextButton(
                    child: Text('ORDER NOW'),
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
