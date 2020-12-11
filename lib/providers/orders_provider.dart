import 'package:eCommerce/providers/card_provider.dart';
import 'package:eCommerce/screens/admin/admin_home_screen.dart';
import 'package:eCommerce/screens/home_screen.dart';
import 'package:flutter/foundation.dart';

class OrderItem {
  final String id;
  final String ownerId;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.ownerId,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders(userId) async {
    try {
      final docsCollection =
          await userProductOrders.doc(userId).collection('userOrders').get();
      final List<OrderItem> loadedOrders = [];
      docsCollection.docs.forEach((orderItem) {
        loadedOrders.add(
          OrderItem(
            id: orderItem['id'],
            ownerId: orderItem['ownerId'],
            amount: orderItem['amount'],
            dateTime: DateTime.parse(orderItem['dateTime']),
            products: (orderItem['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    title: item['title'],
                    quantity: item['quantity'],
                  ),
                )
                .toList(),
          ),
        );
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total,
      String userId, String cartId) async {
    await adminProductOrders.doc(cartId).set({
      'id': cartId,
      'ownerId': userId,
      'amount': total,
      'dateTime': DateTime.now().toIso8601String(),
      'products': cartProducts
          .map((cp) => {
                'id': cp.id,
                'title': cp.title,
                'quantity': cp.quantity,
                'price': cp.price,
              })
          .toList(),
    });

    await userProductOrders
        .doc(userId)
        .collection('userOrders')
        .doc(cartId)
        .set({
      'id': cartId,
      'ownerId': userId,
      'amount': total,
      'dateTime': DateTime.now().toIso8601String(),
      'products': cartProducts
          .map((cp) => {
                'id': cp.id,
                'title': cp.title,
                'quantity': cp.quantity,
                'price': cp.price,
              })
          .toList(),
    }).then((_) {
      _orders.insert(
        0,
        OrderItem(
          id: cartId,
          ownerId: userId,
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts,
        ),
      );
      notifyListeners();
    });
  }
}
