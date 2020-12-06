import 'package:eCommerce/providers/card_provider.dart';
import 'package:eCommerce/providers/products_provider.dart';
import 'package:eCommerce/screens/user/cart_screen.dart';
import 'package:eCommerce/widgets/drawer_widget.dart';
import 'package:eCommerce/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static const routeName = '/home';
  AppBar appBar(context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: RichText(
        text: TextSpan(
          text: 'Easy',
          style: GoogleFonts.galada(
            textStyle: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          children: [
            TextSpan(
              text: 'Buy',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
      actions: [
        IconButton(
          icon: Icon(FontAwesomeIcons.search),
          onPressed: () {},
        ),
        Stack(
          children: [
            IconButton(
              icon: Icon(FontAwesomeIcons.shoppingCart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
            Positioned(
              top: 6.0,
              right: 4.0,
              child: Container(
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blue,
                ),
                constraints: BoxConstraints(
                  minHeight: 17,
                  minWidth: 17,
                ),
                child: Consumer<Cart>(
                  builder: (_, cart, ch) {
                    return Text(
                      cart.itemCount.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
      centerTitle: true,
    );
  }

  /* *************************************************** */

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(context),
      drawer: DrawerWidget(),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 20.0,
        ),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        ),
      ),
    );
  }
}
