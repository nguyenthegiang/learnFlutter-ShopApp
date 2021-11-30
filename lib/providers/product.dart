import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

/*Chuyển product.dart vào thư mục providers bởi vì mình muốn chuyển nó thành 
data provider để thực hiện thông báo mỗi khi giá trị isFavorite thay đổi */
class Product with ChangeNotifier {
  //Đầu tiên là cho nó mixin với ChangeNotifier
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  //Tạo function thay đổi giá trị của isFavorite
  /* nhận vào authToken để gửi request và userId*/
  Future<void> toggleFavoriteStatus(String token, String userId) async {
    //giữ value cũ để có thể roll back (cho Optimistic Update)
    final oldStatus = isFavorite;

    //mỗi lần gọi đến hàm này thì đổi giá trị của isFavorite
    isFavorite = !isFavorite;
    /*và mỗi khi isFavorite thay đổi thì gọi đến notifyListener để thông báo 
    cho những chỗ Listen cái provider này -> nó sẽ rebuild (là các product_item)*/
    notifyListeners();

    /* Update trên Server (Optimistic Update: thay đổi ở local đã r mới thay đổi
    trên Server) */
    /* Update Favorite riêng vs từng User: cho vào bảng userFavorites:
      mỗi user sẽ có 1 thư mục riêng là userId của user đó, và trong đó sẽ có
      các product và user đó favorite */
    final url =
        'https://learn-flutter-shop-app-7cbf5-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      /* với việc Favorite cho vào bảng riêng -> ko muốn dùng patch request để
      thêm data vào mà muốn ghi đè data cũ -> dùng put request */
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(
          isFavorite,
        ),
      );

      //vì http ko return error với patch() nên mình phải tự kiểm tra và return
      if (response.statusCode >= 400) {
        //rollback nếu lỗi
        _setFavValue(oldStatus);
      }
    } catch (error) {
      //rollback
      _setFavValue(oldStatus);
    }
  }

  /* vì có 2 chỗ cần dùng đoạn code nay -> cho ra function riêng để tránh 
  code duplication */
  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }
}
