import 'package:flutter/material.dart';

import '../widgets/product_item.dart';
import '../models/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  //Some Dummy Data for Products
  final List<Product> loadedProducts = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: loadedProducts.length,
        itemBuilder: (ctx, i) => ProductItem(
          loadedProducts[i].id,
          loadedProducts[i].title,
          loadedProducts[i].imageUrl,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
