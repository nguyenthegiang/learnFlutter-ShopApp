import 'package:flutter/material.dart';

//Dùng chung Screen này để Edit Product và Add Product vì UI như nhau
//Dùng StatefulWidget để làm Input Validation luôn
class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  //biến này để set focus cho mấy thẻ input (thừa)
  final _priceFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          //Cũng có thể dùng SingleChildScrollView hoặc Column
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                /*-> khi mở bàn phím lên thì vị trí chữ Enter sẽ là biểu tượng
                'next' để đi đến thẻ input tiếp theo*/
                /*(thừa)*/ onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                /* Sửa bàn phím thành bàn phím số */
                /*(thừa)*/ focusNode: _priceFocusNode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
