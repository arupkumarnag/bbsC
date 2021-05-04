import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final int qty;
  final int price;
  final String img;

  CartItem({
    @required this.id,
    @required this.name,
    @required this.qty,
    @required this.price,
    @required this.img
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(String pdtid, String name, double price, String img) {
    if (_items.containsKey(pdtid)) {
      _items.update(
          pdtid,
            (existingCartItem) => CartItem(
            img: existingCartItem.img,        ///Image
            id: DateTime.now().toString(),
            name: existingCartItem.name,
            qty: existingCartItem.qty + 1,
            price: existingCartItem.price,
          ));
    } else {
      _items.putIfAbsent(
          pdtid,
              () => CartItem(
            name: name,
            img: img,           ///image
            id: DateTime.now().toString(),
            qty: 1,
            price: price.toInt(),
          ));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  ///Removes Single Item from MAP     === WORK Here
  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].qty > 1) {          //>1
      _items.update(
          id,
            (existingCartItem) => CartItem(
            img: existingCartItem.img,        ///Image
            id: DateTime.now().toString(),
            name: existingCartItem.name,
            qty: existingCartItem.qty - 1,
            price: existingCartItem.price,
          ));
    } else {
      removeItem(id);   ///called once only

    }
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.qty;
    });
    return total;
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}

