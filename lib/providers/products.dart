//import cái này để convert data sang JSON
import 'dart:convert';

import 'package:flutter/material.dart';
//import cái này để gửi http request
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'product.dart';

//Class chứa data cho Data Provider phải mix-in với ChangeNotifier
class Products with ChangeNotifier {
  //String để lưu giữ Token khi Authentication
  final String? authToken;
  final String? userId;

  /*nhận token qua constructor 
  (truyền vào trong main.dart ở Provider khi khởi tạo Object)*/
  Products(this.authToken, this.userId, this._items);

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
    final url =
        'https://learn-flutter-shop-app-7cbf5-default-rtdb.firebaseio.com/products.json?auth=$authToken';
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
          //gắn product vs user
          'creatorId': userId,
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
  Future<void> updateProduct(String id, Product newProduct) async {
    //tìm index của item có id này
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    //nếu tìm đc thì sửa
    if (prodIndex >= 0) {
      /* --Update lên Web Server-- */

      /*Phải truyền id của Product vào để truy cập đến product tương ứng
       (tương tự như cấu trúc folder trên server thôi)
       (vì id là truyền vào nên url ko thể là const)*/
      final url =
          'https://learn-flutter-shop-app-7cbf5-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

      /* Gửi PATCH request để update -> bảo Firebase merge cái data (có id kia)
      với cái data truyền đến này 
      (cái nào mình truyền lên thì sửa, cái nào mình ko truyền lên (isFavorite)
      thì nó vẫn giữ)*/
      await http.patch(
        Uri.parse(url),
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }),
      );

      //sửa item
      _items[prodIndex] = newProduct;

      notifyListeners();
    } else {
      print('can\'t find product!');
    }
  }

  //Delete
  Future<void> deleteProduct(String id) async {
    /* Delete trên Server: cũng phải truyền vào ID */
    final url =
        'https://learn-flutter-shop-app-7cbf5-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

    //Lưu trữ lại item sẽ xóa vào 1 Object tạm thời để có thể rollback
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    //Xóa ở Local
    _items.removeAt(existingProductIndex);
    notifyListeners();

    //Xóa ở Server
    final response = await http.delete(Uri.parse(url));

    /* HTTP chỉ throw về Error với GET và POST, còn PATCH, PUT, DELETE thì kể cả 
    nếu có lỗi nó cx ko return về -> mình phải 
      tự throw ra:
        Xem xét status code của response: nếu là từ 400 trở đi thì là lỗi
        -> throw ra Exception
        ( ko nên throw ra Exception() mà nên tự build 1 Class exception dựa trên
        Exception() )*/
    if (response.statusCode >= 400) {
      //Nếu xảy ra lỗi -> ko xóa đc -> roll back (insert lại item vào)
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      //throw ra error để xử lý ở Widget
      throw HttpException('Could not delete product.');
    }
  }

  /* Lấy list Product từ Web Server */
  /* Không phải lúc nào mình cũng muốn filter: truyền vào 1 positional argument
  (ko bắt buộc phải có -> cho vào [ ] , mặc định là false) 
  nếu truyền vào là true thì mới Filter*/
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    /*nếu ng dùng muốn Filter thì mới cho thêm đoạn này:
    Lấy những Product của User tương ứng 
    Truy vấn kiểu này là của Firebase*/
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    //gắn token vào URL để lấy data sau khi đã authenticate
    var url =
        'https://learn-flutter-shop-app-7cbf5-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    //Dùng get request để lấy data
    try {
      final response = await http.get(Uri.parse(url));
      //Decode data từ JSON sang Map rồi sang List Product
      //có thể null nếu server ko có dữ liệu
      final Map<String, dynamic>? extractedData =
          json.decode(response.body) as Map<String, dynamic>?;

      //null thì return luôn
      if (extractedData == null) {
        return;
      }

      //thêm 1 request nữa để lấy về isFavorite
      url =
          'https://learn-flutter-shop-app-7cbf5-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(
        Uri.parse(url),
      );
      final favoriteData = json.decode(favoriteResponse.body);

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
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          /*nếu favoriteData null (ng dùng chưa có favorite nào) hoặc favoriteData 
          của product này null thì đều nghĩa là ng dùng ko favorite product này*/
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
