import 'package:eCommerce/screens/auth/auth_screen.dart';
import 'package:eCommerce/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: RaisedButton(
              child: Text('LogOut'),
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
