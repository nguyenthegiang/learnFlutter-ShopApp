// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../providers/cart.dart';

//Chứa 1 sản phẩm trong Order
class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

//Chứa danh sách OrderItem
class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  //Getter
  List<OrderItem> get orders {
    return [..._orders];
  }

  //Thêm 1 Order từ Cart vào: dùng cho nút ORDER NOW
  void addOrder(List<CartItem> cartProducts, double total) {
    /*dùng insert() để thêm vào 1 vị trí nhất định: đầu tiên 
      -> order mới nhất sẽ xuất hiện đầu*/
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}
