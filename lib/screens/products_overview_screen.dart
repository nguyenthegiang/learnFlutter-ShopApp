import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../providers/products.dart';

/*Tạo enum này chỉ để lưu trữ các giá trị đc chọn trong PopupMenuButton cho 
trực quan thôi*/
enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  //Biến để lưu trữ xem ng dùng chọn show favorite hay show all
  var _showOnlyFavorites = false;
  //Biến để cho didChangeDependencies() chỉ chạy 1 lần thôi
  var _isInit = true;
  //biến để làm loading spinner
  var _isLoading = false;

  @override
  void initState() {
    /* Khi mới vào product_overview (là khi mới khởi động app) thì load 
    List Product từ Web Server về*/

    // Provider.of<Products>(context).fetchAndSetProducts(); //SẼ LỖI

    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // }); //không lỗi, nma hơi hack tí

    super.initState();
  }

  @override
  void didChangeDependencies() {
    /* Khi mới vào product_overview (là khi mới khởi động app) thì load 
    List Product từ Web Server về*/
    if (_isInit) {
      setState(() {
        //chuyển màn hình sang loading
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          //chuyển màn hình lại bình thường sau khi lấy data xong
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          //Nút để người dùng chọn xem muốn xem tất cả sản phẩm hay chỉ favorite
          PopupMenuButton(
            //Function thay đổi giá trị biến theo lựa chọn
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            //Các lựa chọn
            itemBuilder: (_) => const [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),

          /*số hiển thị trên icon cart là số item có trong cart
            dùng Cart Provider => Phải set up Listener*/
          Consumer<Cart>(
            //Custom Widget của thầy
            builder: (_, cart, ch) => Badge(
              child: ch as Widget,
              //số này này
              value: cart.itemCount.toString(),
            ),
            //
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      //Drawer: cái menu từ phía bên trái
      drawer: AppDrawer(),
      //Truyền lựa chọn về ProductsGrid để hiển thị tương ứng
      //Nếu đang load thì hiển thị loading spinner
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
