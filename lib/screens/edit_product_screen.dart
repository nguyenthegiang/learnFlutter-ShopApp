import 'package:flutter/material.dart';

//Dùng chung Screen này để Edit Product và Add Product vì UI như nhau
//Dùng StatefulWidget để làm Input Validation luôn
class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      //body: ,
    );
  }
}
