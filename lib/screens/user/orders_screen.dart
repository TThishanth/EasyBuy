import 'package:eCommerce/providers/orders_provider.dart';
import 'package:eCommerce/widgets/drawer_widget.dart';
import 'package:eCommerce/widgets/order_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
        ),
        drawer: DrawerWidget(),
        body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (context, index) => OrderItemWidget(
            order: orderData.orders[index],
          ),
        ),
      ),
    );
  }
}
