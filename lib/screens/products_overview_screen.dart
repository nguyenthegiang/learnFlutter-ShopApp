import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

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
          )
        ],
      ),
      //Truyền lựa chọn về ProductsGrid để hiển thị tương ứng
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
