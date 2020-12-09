import 'package:eCommerce/providers/orders_provider.dart';
import 'package:eCommerce/widgets/drawer_widget.dart';
import 'package:eCommerce/widgets/order_item_widget.dart';
import 'package:eCommerce/widgets/progress_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final userId = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
        ),
        drawer: DrawerWidget(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false)
              .fetchAndSetOrders(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return circularProgress();
            }
            return Consumer<Orders>(
              builder: (context, orderData, child) => ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (context, index) => OrderItemWidget(
                  order: orderData.orders[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
