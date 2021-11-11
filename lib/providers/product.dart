import 'package:flutter/material.dart';

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
  void toggleFavoriteStatus() {
    //mỗi lần gọi đến hàm này thì đổi giá trị của isFavorite
    isFavorite = !isFavorite;
    /*và mỗi khi isFavorite thay đổi thì gọi đến notifyListener để thông báo 
    cho những chỗ Listen cái provider này -> nó sẽ rebuild (là các product_item)*/
    notifyListeners();
  }
}
