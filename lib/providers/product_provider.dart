import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String shortInfo;
  final String description;
  final double price;
  final String imageUrl;
  final String status;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.shortInfo,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.status,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
