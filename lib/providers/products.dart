//import cái này để convert data sang JSON
import 'dart:convert';

import 'package:flutter/material.dart';
//import cái này để gửi http request
import 'package:http/http.dart' as http;

import 'product.dart';

//Class chứa data cho Data Provider phải mix-in với ChangeNotifier
class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://images.sportsdirect.com/images/products/36206203_l.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Blanket',
    //   description: 'My favorite blanket',
    //   price: 99.99,
    //   imageUrl:
    //       'https://m.media-amazon.com/images/I/71THWcYwDML._AC_SL1500_.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Pan',
    //   description: 'Frying pan',
    //   price: 69.99,
    //   imageUrl:
    //       'https://m.media-amazon.com/images/I/819hzZIFNuL._AC_SL1500_.jpg',
    // ),
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
  /* Cho function này return về Future, để phía bên UI mình có thể code để
  đợi send http requests xong */
  Future<void> addProduct(Product product) async {
    //Gửi HTTP Requests đến Server để lưu giữ liệu lên server
    const url =
        'https://learn-flutter-shop-app-7cbf5-default-rtdb.firebaseio.com/products.json';
    /* Link đến Server: thêm cái /products.json để kiểu tạo 1 table Products
    (chỉ có Firebase mới làm đc tn thôi) */

    /* Muốn cho function này return về Future:
        - Nếu return sau khi chạy toàn bộ đoạn http.post().then()... thì nó
        sẽ return luôn chứ ko chờ code chạy xong
        - Nếu return trong then() thì nó lại sai vì phải return ở bên ngoài
      -> return về cả khối http.post().then()... này luôn, vì then() cx return
      về future mà*/
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
        /* Dùng package http để gửi 1 Post request đến url đó;
      1 số argument: 
        - url: (version mới của package http) chỉ chấp nhận object Uri thôi
              -> phải parse
        - headers: chứa 1 số meta data (chưa cần)
        - body: phải truyền vào JSON data:
          + import dart:convert để convert data sang JSON 
          + tạo map và convert nó sang JSON*/
      );
      /* Gọi then() để có thể thao tác với response và Server trả về */
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        /*id lấy từ ID và Server gen ra
        phải convert từ JSON sang Map -> lấy value của key 'name'*/
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);

      notifyListeners();
    } catch (error) {
      print(error); //print error ra

      throw (error); //lại throw error ra
    }
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

  /* Lấy list Product từ Web Server */
  Future<void> fetchAndSetProducts() async {
    const url =
        'https://learn-flutter-shop-app-7cbf5-default-rtdb.firebaseio.com/products.json';
    //Dùng get request để lấy data
    try {
      final response = await http.get(Uri.parse(url));
      //Decode data từ JSON sang Map rồi sang List Product
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      //list chứa các product lấy về
      final List<Product> loadedProducts = [];
      //decode
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      //gán vào item
      _items = loadedProducts;

      notifyListeners();
    } catch (error) {
      //nếu có lỗi thì tung ra để xử lý ở Widget
      rethrow;
      //dùng rethrow để tung ra lại lỗi đã catch đc
    }
  }
}
