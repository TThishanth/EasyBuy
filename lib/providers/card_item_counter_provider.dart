import 'package:flutter/foundation.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter = 1;
  int get count => _counter;
}
