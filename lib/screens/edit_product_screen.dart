import 'package:flutter/material.dart';

import '../providers/product.dart';

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
  /*Global Key để hỗ trợ interact với State của Form: GlobalKey là 1 Generic, 
  mà type truyền vào là 1 State của Widget*/
  final _form = GlobalKey<FormState>();
  //Object Product để lưu trữ thông tin của Form Submit
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void initState() {
    /*Tạo Listener cho _iamgeUrlFocusNode -> mỗi khi focus thay đổi thì chạy
    function _updateImageUrl()*/
    _iamgeUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_iamgeUrlFocusNode.hasFocus) {
      //validate image cả khi Preview nữa
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
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

  //Method để Submit Form
  void _saveForm() {
    /* Trước khi save form thì validate -> gọi đến validate() của Form
    -> nó sẽ gọi đến các function validator của TextFormField
    -> validate() sẽ trả về true nếu tất cả các validator đều thỏa mãn,
    chỉ cần 1 cái bị sai thì nó sẽ return false */
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
      //nếu validate sai thì ko lưu
    }

    /* Interact vs From Widget để lấy dữ liệu đc Submit -> truy cập trực tiếp
    đến 1 Widget ở trong Code -> Sử dụng Global Key (khá ít dùng, chủ yếu cho
    Form như ở đây) */
    _form.currentState!.save();
    /* save() sẽ trigger method ở onSaved ở tất cả các TextFormField 
    -> cho phép lấy value trong chúng và làm gì tùy ý (VD: lưu trong Map) */

    //Test
    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.price);
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        //Nút Submit Form
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          //Link Form Widget với GlobalKey
          key: _form,
          //Cũng có thể dùng SingleChildScrollView hoặc Column
          child: ListView(
            children: [
              //Title
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  /*Có thể set thêm style cho error message ở đây
                  (message sẽ hiển thị nếu validation bị sai)*/
                ),
                textInputAction: TextInputAction.next,
                /*-> khi mở bàn phím lên thì vị trí chữ Enter sẽ là biểu tượng
                'next' để đi đến thẻ input tiếp theo*/
                /*(thừa)*/ onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                /*Khi gọi đến save() trong _saveForm() -> các method trong 
                onSaved() của các textField sẽ đc gọi -> mỗi textField sẽ lưu
                trữ 1 thông tin của mình vào Object Product chung*/
                onSaved: (value) {
                  /* nhưng vì các property trong Product là final -> ko thể edit
                  -> mỗi lần muốn edit phải tạo lại 1 Product mới, override lên,
                  các giá trị cũ thì giữ nguyên */
                  _editedProduct = Product(
                    /*truyền vào value, nhưng value thuộc kiểu String? (có thể 
                    null) -> ko truyền thẳng đc, phải check: nếu null thì truyền
                    vào String rỗng -> ?? là if null operator*/
                    title: value ?? '',
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: '',
                  );
                },
                //validate user input
                validator: (value) {
                  if (value!.isEmpty) {
                    //Nếu input rỗng -> lỗi -> Thông báo lỗi
                    return 'Please provide a value.';
                  }
                  //ko thì OK r
                  return null;
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
                //Tương tự
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    //price là double nên phải parse
                    price: double.parse(value ?? ''),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: '',
                  );
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    //trg hợp để trống
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    //trường hợp input ko phải số
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    //trg hợp số <= 0
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
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
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: value ?? '',
                    imageUrl: _editedProduct.imageUrl,
                    id: '',
                  );
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description.';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters long.';
                  }
                  return null;
                },
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
                      /* ấn nút Enter ở thẻ input này cũng sẽ submit form, vì
                      nó là thẻ cuối cùng rồi mà */
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: value ?? '',
                          id: '',
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        //có thể check thêm xem link có phải image ko nếu muốn
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL.';
                        }
                        return null;
                      },
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
