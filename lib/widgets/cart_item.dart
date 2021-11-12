import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

//Widget này để hiển thị 1 CartItem trong CartScreen
class CartItem extends StatelessWidget {
  final String id;
  final String productId; //nhận về productId để xóa
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        //nền đỏ
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        /*cho nó cái margin = Card để background chỉ xuất hiện đằng sau Card thôi,
        ko bị thừa ra*/
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      //Chỉ có thể xóa = cách kéo từ phải sang trái
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        //khi xóa thì cũng xóa trong Provider
        Provider.of<Cart>(
          context,
          listen: false,
          //ko cần Listener vì Dismissible đã thực hiện xóa ở UI rồi
        ).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$ $price'),
                ),
              ),
              /* Thêm backgroundColor và foregroundColor (code mẫu ko có) 
              vì nó ko tự style theo Theme */
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor:
                  Theme.of(context).primaryTextTheme.headline6!.color,
            ),
            title: Text(title),
            subtitle: Text('Total: \$ ${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
