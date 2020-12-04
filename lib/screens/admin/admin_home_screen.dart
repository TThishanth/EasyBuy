import 'package:eCommerce/screens/auth/auth_screen.dart';
import 'package:eCommerce/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: RaisedButton(
              child: Text('Admin'),
              color: Theme.of(context).primaryColor,
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
              }),
        ),
      ),
    );
  }
}