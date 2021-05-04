import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class ProductModel{
  final String productName;
  final int productQuantity;
  final String productDescription;
  final String productCategory;
  final String productOffer;
  final String unitType;
  final double unitPrice;
  final int availableUnits;
  final String vendorId;
  final String productId;
  final String imageUrl;
  final bool approved;
  final String note;
  final int quantity;
  final String documentId;    
  final String orderId;
  final String orderStatus;
  final int deliveryCharge;
  final String deliveryChargeId;
  final int minOrderValue;
  final String inStock;
  Timestamp timeOfOrder;
  final double totalAmount;
  final int codExtra;
  List orders;



  ProductModel({
    @required this.approved,
    this.productQuantity,
    @required this.availableUnits,
    this.imageUrl = "",
    this.note = "",
    @required this.productId,
    @required this.productName,
    @required this.unitPrice,
    @required this.unitType,
    this.vendorId,
    @required this.productDescription,    
    @required this.productOffer,        
    @required this.productCategory,    
    @required this.quantity,
    @required this.documentId,
    @required this.orderId,
    @required this.orderStatus,
    @required this.totalAmount,
    @required this.deliveryCharge,
    @required this.deliveryChargeId,
    @required this.minOrderValue,
    @required this.codExtra,
    @required this.inStock,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName' : productName,
      'productQuantity' : productQuantity,
      'unitType' : unitType,
      'unitPrice' : unitPrice,
      'availableUnits': availableUnits,
      'approved': approved,
      'imageUrl':imageUrl,
      'note':note,
      'productId':productId,
      'vendorId':vendorId,
      'productDescription': productDescription,   ///Added
      'productOffer': productOffer,                ///Added
      'productCategory': productCategory,
      'quantity' : quantity,
      'orderId' : orderId,
      'orderStatus': orderStatus,
      'timeOfOrder' : timeOfOrder,
      'totalAmount' : totalAmount,
      'deliveryCharge' : deliveryCharge,
      'deliveryChargeId' : deliveryChargeId,
      'minOrderValue' : minOrderValue,
      'codExtra' : codExtra,
      'inStock' : inStock,
    };
  }

  ///I Added Parameters

  ProductModel.fromFirestore(Map<String, dynamic> firestore)
      : productName = firestore['productName'],
        productQuantity = firestore['productQuantity'],
        unitType = firestore['unitType'],
        unitPrice = firestore['unitPrice'],
        availableUnits = firestore['availableUnits'],
        approved = firestore['approved'],
        imageUrl = firestore['imageUrl'],
        note = firestore['note'],
        productId = firestore['productId'],
        vendorId = firestore['vendorId'],
        productDescription = firestore['productDescription'],     ///Added
        productOffer = firestore['productOffer'], ///Added
        productCategory = firestore['productCategory'],
        quantity = firestore['quantity'],
        orderId = firestore['orderId' ],
        documentId = firestore['documentId'],
        orderStatus = firestore['orderStatus'],
        timeOfOrder = firestore['timeOfOrder'],
        orders = firestore['orders'],
        totalAmount = firestore['totalAmount'],
        deliveryCharge = firestore['deliveryCharge'],
        deliveryChargeId = firestore['deliveryChargeId'],
        minOrderValue = firestore['minOrderValue'],
        codExtra = firestore['codExtra'],
        inStock = firestore['inStock'];
}

class ArrayProduct {
  var uuid = Uuid();

  List cartArray = [];        ///Data to be stored here temp

  ///01- Adds the items at the end of the Array. Use in '+' button = Use in qty_unit screen
  addArrayItem(id) {    ///productname is added
    cartArray.addAll([id]);     ///Adds the items at the end of the Array.
  }

  ///02- Will remove one item from the array from the end. use in '-' buttons. Use in qty_unit screen
  removeSingleArrayItem(id) {
    cartArray.removeLast();       ///Will remove one item from the array from the end. use in + - buttons.
  }


  ///03- Will remove all items bearing the same ID from the Array. Use in 1st Check Out.
  removeArrayItemWithSameId(id) {
    cartArray.removeWhere((item) => item == id);
  }


  ///04. Removes entire arraylist data || to be used at the Final (2nd) CheckoutScreen on the PopUp 'OK' Button
  void clearArrayList() {
    cartArray.clear();          ///removes entire arraylist data || to be used at the Final (2nd) CheckoutScreen
  }

}


