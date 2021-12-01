// ignore_for_file: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  //authToken để gửi requests đến server
  final String authToken;
  //gắn order với user
  final String userId;

  //constructor (như Products)
  Orders(this.authToken, this.userId, this._orders);

  //Getter
  List<OrderItem> get orders {
    return [..._orders];
  }

  //Thêm 1 Order từ Cart vào: dùng cho nút ORDER NOW
  /* Add Order lên Server: tương tự như Add Product */
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    //Lưu vào Table Orders
    /* Khi add thì add vào trong thư mục có userId tương ứng */
    final url =
        'https://learn-flutter-shop-app-7cbf5-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    /*Mình cần dùng DateTime.now() ở 2 chỗ là gửi lên server và store vào local
    => tạo 1 biến lưu trữ trc để nó đồng bộ, nếu ko 2 lần gọi DateTime.now() có 
    thể tạo ra 2 giá trị khác nhau*/
    final timestamp = DateTime.now();

    //Có thể thêm error handling ở đây cho đầy đủ
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        /*Iso8601String: là 1 uniform String representation of dates, sau này
        có thể dễ dàng convert về DateTime object */
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
        /* Product là 1 List CartItem -> phải convert sang 1 list các Map
        (mà sau đó khi endcode() sẽ convert cái list đó thành Map nốt luôn) */
      }),
    );

    /*dùng insert() để thêm vào 1 vị trí nhất định: đầu tiên 
      -> order mới nhất sẽ xuất hiện đầu*/
    _orders.insert(
      0,
      OrderItem(
        /*Lấy ID từ cái id đc Firebase generate (khi add xong server sẽ gửi 1 
        response là item đc add vào)*/
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      ),
    );

    notifyListeners();
  }

  /* Lấy list Order từ Server xuống để hiển thị (như Product thôi)*/
  Future<void> fetchAndSetOrders() async {
    //khi lấy order cx lấy từ thư mục userId tương ứng
    final url =
        'https://learn-flutter-shop-app-7cbf5-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    final response = await http.get(Uri.parse(url));

    final List<OrderItem> loadedOrders = [];

    //extractedData có thể null nếu ko có dữ liệu trên server
    final Map<String, dynamic>? extractedData =
        json.decode(response.body) as Map<String, dynamic>?;

    //nếu null thì khỏi add vào list ở local làm gì, đỡ lỗi
    if (extractedData == null) {
      return;
    }

    //Lấy ra list orders
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price'],
              ),
            )
            .toList(),
      ));
    });

    //gán vào list order ở local
    _orders = loadedOrders.reversed.toList();
    //sắp xếp lại thứ tự cho đúng

    notifyListeners();
  }
}
