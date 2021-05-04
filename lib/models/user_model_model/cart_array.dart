import 'package:flutter/foundation.dart';

class CartArrayList {
  final String name;
  final String price;
  final String quantity;
  final String imgUrl;


  CartArrayList({
    @required this.name,
    @required this.price,
    @required this.quantity,
    @required this.imgUrl,
  });

  CartArrayList.fromFirestore(Map<String,dynamic> firestore)
      : name = firestore['name'],
        price = firestore['price'],
        quantity = firestore['quantity'],
        imgUrl = firestore['imgUrl'];
}