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
  //controller cho input image
  final _imageUrlController = TextEditingController();
  final _iamgeUrlFocusNode = FocusNode();

  @override
  void initState() {
    /*Tạo Listener cho _iamgeUrlFocusNode -> mỗi khi focus thay đổi thì chạy
    function _updateImageUrl()*/
    _iamgeUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_iamgeUrlFocusNode.hasFocus) {
      //Khi thẻ input Image mất focus thì update state
      setState(() {});
    }
  }

  @override
  void dispose() {
    //phải dispose cả Listener
    _iamgeUrlFocusNode.removeListener(_updateImageUrl);
    //Xóa 2 object FocusNode() khi kết thúc
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    //dispose cả controller
    _imageUrlController.dispose();
    _iamgeUrlFocusNode.dispose();
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
              //Title
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
              //Price
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
              //Description
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
              //Image
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //Image Preview
                  Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      //hiện thị image dựa vào giá trị trong controller
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            )),
                  //Image URL input
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      //bàn phím URL
                      keyboardType: TextInputType.url,
                      //thẻ text cuối cùng thì nên để nút Enter là hình Submit
                      textInputAction: TextInputAction.done,
                      //thẻ input này phải gán controller vì mình muốn preview nữa
                      controller: _imageUrlController,
                      /*gán focusNode cho cái này để khi user chuyển focus sang
                      thẻ input khác thay vì ấn Enter thì nó cũng hiển thị
                      preview hình ảnh lên*/
                      focusNode: _iamgeUrlFocusNode,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
