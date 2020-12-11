import 'package:eCommerce/providers/orders_provider.dart';
import 'package:eCommerce/widgets/drawer_widget.dart';
import 'package:eCommerce/widgets/order_item_widget.dart';
import 'package:eCommerce/widgets/progress_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final userId = FirebaseAuth.instance.currentUser.uid;

  Container emptyOrdersScreen(isPotrait) {
    return Container(
      margin: EdgeInsets.only(top: isPotrait ? 150.0 : 40.0),
      width: double.infinity,
      child: Center(
        child: Column(
          children: [
            Container(
              child: SvgPicture.asset(
                'assets/images/no_order.svg',
                height: isPotrait ? 200.0 : 180.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Text(
                'No Orders',
                style: TextStyle(
                  fontSize: isPotrait ? 30.0 : 30.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPotrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
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
              builder: (context, orderData, child) => orderData.orders.isEmpty
                  ? emptyOrdersScreen(isPotrait)
                  : ListView.builder(
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
