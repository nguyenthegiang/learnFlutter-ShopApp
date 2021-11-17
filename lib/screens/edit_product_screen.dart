import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
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
  //biến dùng để kiểm tra xem đây có phải lần chạy init ko
  var _isInit = true;
  /*biến để lưu trữ giá trị khởi điểm của các TextField
      - nếu là add mới thì rỗng
      - nếu là edit thì có*/
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  /* Biến để lưu trữ xem chương trình có đang load ko (khi gửi http request);
  Nếu đang Load thì hiển thị màn hình loading */
  var _isLoading = false;

  @override
  void initState() {
    /*Tạo Listener cho _iamgeUrlFocusNode -> mỗi khi focus thay đổi thì chạy
    function _updateImageUrl()*/
    _iamgeUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    /*Nếu là Edit: lấy ID của Product truyền sang để tìm product tương ứng; 
      Nếu để code ở initState() thì hoàn hảo, nhưng ở đó lại ko gọi đc  nên 
      phải làm ở đây, và dùng _isInit để đảm bảo code này chỉ chạy 1 lần*/
    if (_isInit) {
      //Lấy id từ argument (có thể null)
      final String? productId =
          ModalRoute.of(context)!.settings.arguments as String?;

      //nếu add mới product -> ko có argument -> nếu thế thì ko làm đoạn dưới này
      if (productId != null) {
        //tìm product có id tương ứng, gán vào product của Widget này
        _editedProduct = Provider.of<Products>(
          context,
          listen: false,
        ).findById(productId);

        //gán vào biến để gán vào textField
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //ko set initialValue cho textField có controller đc
          //'imageUrl': _editedProduct.imageUrl,
        };
        //mà phải gán initalValue cho controller
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;

    super.didChangeDependencies();
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

    /* Chuyển màn hình sang trạng thái Loading để chờ send http requests xong
    mới chạy tiếp */
    setState(() {
      _isLoading = true;
    });

    //Kiểm tra xem đang là Edit hay Add để thực hiện tương ứng
    if (_editedProduct.id != '') {
      //Edit--
      //Nếu id ko phải '' thì là lấy từ Provider -> là Edit
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);

      /*Chuyển loading lại thành false vì đã load xong r 
      -> kết thúc hiển thị màn hình load*/
      setState(() {
        _isLoading = false;
      });

      //Tự động rời Page -> về page trc
      Navigator.of(context).pop();
    } else {
      //Add--
      //Add vào List
      /* Bây giờ addProduct() return về Future
      -> chỉ khi nào đoạn code trong Future chạy xong mới quay trở về trang trc
      -> cho Navigator.of(context).pop(); vào trong then();
        Bên cạnh đó thì trong lúc đợi Future load xong thì hiển thị hình loading */
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .then((_) {
        /*Chuyển loading lại thành false vì đã load xong r 
        -> kết thúc hiển thị màn hình load*/
        setState(() {
          _isLoading = false;
        });

        //Tự động rời Page -> về page trc
        Navigator.of(context).pop();
      });
    }

    //Navigator.of(context).pop();
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
      /* Nếu chương trình đang load (đang gửi http request và chờ response)
      thì hiển thị màn hình Loading */
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
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
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
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
                      //Gán giá trị khởi đầu (nếu là Edit)
                      initialValue: _initValues['title'],
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
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      //Tương tự
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          //price là double nên phải parse
                          price: double.parse(value ?? ''),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
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
                      initialValue: _initValues['price'],
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
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
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
                      initialValue: _initValues['description'],
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
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
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
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
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
                              // if (!value.endsWith('.png') &&
                              //     !value.endsWith('.jpg') &&
                              //     !value.endsWith('.jpeg')) {
                              //   return 'Please enter a valid image URL.';
                              // }
                              /* bỏ cái này đi, giờ đầy ảnh đuôi khác */
                              return null;
                            },
                            //ko set initialValue cho textField có controller đc
                            // initialValue: _initValues['imageUrl'],
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
