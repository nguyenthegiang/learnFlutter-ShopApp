import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

//Quản lý Product: CRUD
class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  //function để refresh lại list product, phải truyền vào context để dùng
  Future<void> _refreshProducts(BuildContext context) async {
    //Dùng async - await để khi nào fetch data xong mới return
    await Provider.of<Products>(
      context,
      /* My customization: phải thêm listen: false nếu không sẽ lỗi */
      listen: false,
      //chỗ này chỉ hiện product của user thôi (để manage) -> truyền vào filterByUser = true
    ).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //Set up Listener -> Product Provider
    //Không dùng cái này đc nữa vì nếu dùng sẽ bị infinite loop
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          //ấn nút để thêm Product
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              //push cái screen này vào stack
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      //1 cái app drawer như các màn hình
      drawer: const AppDrawer(),
      //Dùng FutureBuilder để lấy lại list product từ server mỗi khi chuyển sang màn hình này
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    //Tạo cái RefreshIndicator để có tính năng Pull-to-refresh
                    onRefresh: () => _refreshProducts(context),
                    /*chuyển sang dùng Consumer vì cái Provider của productsData
                    trên kia ko dùng đc nữa*/
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: const EdgeInsets.all(8),
                        //Hiển thị List Product
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                productsData.items[i].id,
                                productsData.items[i].title,
                                productsData.items[i].imageUrl,
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
