import 'package:flutter/material.dart';

//Class lưu trữ 1 item của cart
class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

//class lưu trữ 1 list các cartItem
class Cart with ChangeNotifier {
  //Sử dụng map vì mỗi cartItem sẽ liên kết vs 1 Product thông qua ProductID
  late Map<String, CartItem> _items = {};
  //Map này có Key là ProductID và value là CartItem

  //Getter
  Map<String, CartItem> get items {
    /*Dùng Spread Operator để return về 1 bản copy của cái Map _items chứ ko 
    phải return về địa chỉ của nó*/
    return {..._items};
  }

  //Getter: get tổng số item trong cart để hiển thị ở cái icon cart trên appBar ở products_overview
  int get itemCount {
    //nếu map rỗng thì trả về 0
    return _items.length;
  }

  //Getter: get tổng price, dùng cho cart_screen.dart
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  //thêm 1 item: quantity thì + 1
  void addItem(String productId, double price, String title) {
    //Kiểm tra xem trong Cart đã có product này chưa
    if (_items.containsKey(productId)) {
      /*có rồi thì +1 vào quantity
      hàm update() để sửa 1 item trong Map, nhận 2 argument:
        - Key
        - function để sửa Value: function này truyền vào 1 argument là Object 
          chứa item cũ -> có thể giúp mình truy cập vào các property của item
          cũ -> hỗ trợ update (chỉ update những cái cần thôi, còn lại giữ nguyên);
          và function này return về Item đc sửa*/
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
        ),
      );
    } else {
      /*chưa có thì thêm mới: quantity = 1
      hàm putIfAbsent() để thêm 1 item vào Map, nhận 2 argument:
        - Key
        - function để thêm Value vào*/
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }

    //đừng quên gọi function này
    notifyListeners();
  }
}
