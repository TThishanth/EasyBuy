import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eCommerce/screens/admin/admin_home_screen.dart';
import 'package:eCommerce/screens/auth/auth_screen.dart';
import 'package:eCommerce/services/auth_services.dart';
import 'package:eCommerce/widgets/progress_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User currentUser = FirebaseAuth.instance.currentUser;

  /* *************************************************** */

  Drawer drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.home,
              color: Theme.of(context).accentColor,
            ),
            title: Text('Home'),
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.signOutAlt,
              color: Theme.of(context).accentColor,
            ),
            title: Text('LogOut'),
            onTap: () {
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
        ],
      ),
    );
  }

  AppBar appBar() {
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
        IconButton(
          icon: Icon(FontAwesomeIcons.shoppingCart),
          onPressed: () {},
        ),
      ],
      centerTitle: true,
    );
  }

  SafeArea buildHomePage() {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(),
        drawer: drawer(),
        body: Container(
          child: Center(
            child: Text('Home'),
          ),
        ),
      ),
    );
  }

  /* *************************************************** */

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: usersRef.doc(currentUser.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return circularProgress();
            break;
          default:
            return checkRole(snapshot.data);
        }
      },
    );
  }

  checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data()['role'] == 'admin') {
      return AdminHomeScreen();
    } else {
      return buildHomePage();
    }
  }
}
