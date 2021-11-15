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
  final _descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    //Xóa 2 object FocusNode() khi kết thúc
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

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
                /*(thừa)*/ onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                /* 2 dòng dưới để tạo 1 thẻ input nhiều dòng (3 dòng) */
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                /* Vì nhiều dòng nên nút Enter sẽ phải dùng để xuống dòng 
                  -> ko cần cái này nữa */
                //textInputAction: TextInputAction.next,
                /*(thừa)*/ focusNode: _descriptionFocusNode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
