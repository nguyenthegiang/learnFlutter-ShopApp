import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';

/* Vì trong cart.dart cũng có Class CartItem, nhưng mình ko cần nó, mình chỉ cần
Class Cart trong cart.dart thôi; bên cạnh đó, mình cần Class CartItem trong
cart_item.dart => mình không muốn file này có thể gọi đến 2 Class cùng tên
-> bị trùng -> trong cart.dart mình chỉ truy xuất đến class Cart thôi! */
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Sử dụng Provider để truy cập đến function trong cart.dart
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  /*Dùng Spacer() để khi MainAxisAlignment.spaceBetween căn đều
                  khoảng cách giữa 3 Widget -> Thêm Widget này vào giữa thì
                  cái Text() kia sẽ sang tận cùng bên trái và 2 cái còn lại 
                  sẽ sang tận cùng bên phải*/
                  const Spacer(),
                  Chip(
                    //truy cập đến tổng price thông qua Provider
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6!
                              .color),
                    ),
                    /* Khác so với code mẫu: muốn truy cập vào primaryColor thì phải
                    colorScheme.primary */
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  /* FlatButton deprecated rồi nên mình chuyển sang TextButton
                  làm theo migration guide */
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          //List các CartItem
          //Muốn dùng ListView trong Column thì phải Wrap = Expanded
          Expanded(
            child: ListView.builder(
              //Gọi đến Provider
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i], //productId là key
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* Extract cái này ra làm Widget riêng vì nó có thay đổi -> cần phải là 
StatefulWidget (còn nếu chuyển cả cái Widget to trên kia làm Stateful thì nó
phải rebuild thừa mỗi lần cái này thay đổi -> Performace) */
class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      /* Nếu ko có Cart nào thì disable nút này = cách để
      onPressed = null */
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              /* Nếu đang load (đang gửi http request) thì cx disable button 
              và hiển thị loading spinner nữa*/
              setState(() {
                _isLoading = true;
              });

              //ấn nút này thì add cart vào Order
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );

              //trở lại bình thg
              setState(() {
                _isLoading = false;
              });

              //Add Cart vào Order rồi thì clear cái Cart này đi thôi
              widget.cart.clear();
            },
      style: TextButton.styleFrom(
        primary: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
