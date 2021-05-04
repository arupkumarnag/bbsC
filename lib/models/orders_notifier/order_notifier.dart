import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:grocery_client_reboot/models/product_model.dart';


class OrderNotifier with ChangeNotifier {
  List<ProductModel> _productModel = [];
  ProductModel _model;

  UnmodifiableListView<ProductModel> get productList => UnmodifiableListView(_productModel);

  ProductModel get model => _model;

  set productList(List<ProductModel> productList) {            
    _productModel = productList;
    notifyListeners();
  }

  set model(ProductModel productModel) {          
    _model = productModel;
    notifyListeners();
  }


}