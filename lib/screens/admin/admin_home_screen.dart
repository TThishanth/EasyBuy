//import 'dart:io';

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eCommerce/providers/products_provider.dart';
import 'package:eCommerce/screens/admin/admin_product_upload_screen.dart';
//import 'package:eCommerce/screens/admin/admin_edit_product_screen.dart';
import 'package:eCommerce/screens/auth/auth_screen.dart';
import 'package:eCommerce/services/auth_services.dart';
import 'package:eCommerce/widgets/admin_product_item_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

final storageRef = FirebaseStorage.instance.ref();
final productsRef = FirebaseFirestore.instance.collection('products');

class AdminHomeScreen extends StatefulWidget {
  static const routeName = '/admin';
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int currentIndex = 0;
  final _picker = ImagePicker();

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  /* ******************************************************************* */

  captureImageWithCamera() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      maxHeight: 680.0,
      maxWidth: 970.0,
    );

    Navigator.of(context).pushReplacementNamed(
      AdminUploadScreen.routeName,
      arguments: pickedFile,
    );
  }

  selectImageFromGallery() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 680.0,
      maxWidth: 970.0,
    );

    Navigator.of(context).pushReplacementNamed(
      AdminUploadScreen.routeName,
      arguments: pickedFile,
    );
  }

  pickImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            'Product Image',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                'Capture with camera',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: captureImageWithCamera,
            ),
            SimpleDialogOption(
              child: Text(
                'Select From Gallery',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: selectImageFromGallery,
            ),
            Divider(),
            SimpleDialogOption(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  /* ******************************************************************** */

  Scaffold myOrdersScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            text: 'New',
            style: GoogleFonts.galada(
              textStyle: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            children: [
              TextSpan(
                text: 'Orders',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(),
    );
  }

  /* ******************************************************************* */

  Scaffold logOutScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            text: 'Sign',
            style: GoogleFonts.galada(
              textStyle: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            children: [
              TextSpan(
                text: 'Out',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: SvgPicture.asset(
                'assets/images/logout.svg',
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: RaisedButton(
                elevation: 8.0,
                padding: EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 10.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Provider.of<Authentication>(context, listen: false)
                      .signOut()
                      .whenComplete(
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AuthScreen(),
                          ),
                        ),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ******************************************************************* */

  Scaffold homePageScreen(productsData) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            text: 'Admin',
            style: GoogleFonts.galada(
              textStyle: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            children: [
              TextSpan(
                text: 'Panel',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (context, index) => UserProductItem(
            title: productsData.items[index].title,
            imageUrl: productsData.items[index].imageUrl,
          ),
        ),
      ),
    );
  }

  /* ******************************************************************* */

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => pickImage(context),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
          hasNotch: true,
          fabLocation: BubbleBottomBarFabLocation.end,
          opacity: 0.2,
          currentIndex: currentIndex,
          onTap: changePage,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
          elevation: 10.0,
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Home'),
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.access_time,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.access_time,
                color: Colors.deepPurple,
              ),
              title: Text('New Orders'),
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.logout,
                color: Colors.blue,
              ),
              title: Text('Logout'),
            ),
          ],
        ),
        body: (currentIndex == 0)
            ? homePageScreen(productsData)
            : (currentIndex == 1)
                ? myOrdersScreen()
                : logOutScreen(),
      ),
    );
  }
}
