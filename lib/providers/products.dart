import 'package:flutter/material.dart';

import 'product.dart';

//Class chứa data cho Data Provider phải mix-in với ChangeNotifier
class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://images.sportsdirect.com/images/products/36206203_l.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Blanket',
      description: 'My favorite blanket',
      price: 99.99,
      imageUrl:
          'https://m.media-amazon.com/images/I/71THWcYwDML._AC_SL1500_.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Pan',
      description: 'Frying pan',
      price: 69.99,
      imageUrl:
          'https://m.media-amazon.com/images/I/819hzZIFNuL._AC_SL1500_.jpg',
    ),
  ];

  //Getter
  List<Product> get items {
    /* Không return về property, mà chỉ return về 1 bản sao của nó thôi, vì 
    property này là 1 List -> nếu return về nó thì là return về địa chỉ của nó 
    -> nó sẽ có thể bị thay đổi từ bên ngoài */
    return [..._items];
    /* Bởi vì mình muốn là mỗi khi list Product thay đổi -> gọi đến hàm 
    notifyListeners() để thực hiện thông báo cho các listener -> mình cần kiểm 
    soát đc khi nào list product thay đổi Ở ĐÂY, nếu mình để cho bên ngoài thay 
    đổi mà mình ko biết thì sẽ ko gọi đến notifyListener() đc */
  }

  //function này để product_detail_screen dùng
  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void addProduct() {
    notifyListeners();
  }
}