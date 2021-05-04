import 'package:flutter/foundation.dart';
import 'package:grocery_client_reboot/models/user_model_model/cart_array.dart';


class UserDataCart {
  final String email;
  final String name;
  final String phone;
  final String userId;
  final String address;
  final String totalToPay;
  final CartArrayList cartArrayList;

  UserDataCart ({
    @required this.email,
    @required this.name,
    @required this.phone,
    @required this.userId,
    @required this.address,
    @required this.totalToPay,
    @required this.cartArrayList,
  });

  UserDataCart.fromFirestore(Map<String, dynamic> firestore)
      : name = firestore['name'],
        email= firestore['email'],
        phone = firestore['phone'],
        userId = firestore['userId'],
        address = firestore['address'],
        totalToPay = firestore['totalToPay'],
        cartArrayList = CartArrayList.fromFirestore(firestore['cartItemList']);
}