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

  // var _showFavoritesOnly = false;

  //Getter
  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }

    /* Không return về property, mà chỉ return về 1 bản sao của nó thôi, vì 
    property này là 1 List -> nếu return về nó thì là return về địa chỉ của nó 
    -> nó sẽ có thể bị thay đổi từ bên ngoài */
    return [..._items];
    /* Bởi vì mình muốn là mỗi khi list Product thay đổi -> gọi đến hàm 
    notifyListeners() để thực hiện thông báo cho các listener -> mình cần kiểm 
    soát đc khi nào list product thay đổi Ở ĐÂY, nếu mình để cho bên ngoài thay 
    đổi mà mình ko biết thì sẽ ko gọi đến notifyListener() đc */
  }

  //function dùng trong products_grid, để chỉ lấy ra những favorite product thôi
  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  //function này để product_detail_screen dùng
  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  //Add 1 product vào List, dùng trong edit_product_screen
  void addProduct(Product product) {
    final newProduct = Product(
      id: DateTime.now().toString(), //unique id
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );

    _items.add(newProduct);

    notifyListeners();
  }

  //Function update Product vào Provider, dùng khi Edit ở edit product screen
  void updateProduct(String id, Product newProduct) {
    //tìm index của item có id này
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    //nếu tìm đc thì sửa
    if (prodIndex >= 0) {
      //sửa item
      _items[prodIndex] = newProduct;

      notifyListeners();
    } else {
      print('can\'t find product!');
    }
  }

  //Delete
  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);

    notifyListeners();
  }
}
