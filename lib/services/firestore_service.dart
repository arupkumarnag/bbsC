
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:grocery_client_reboot/app.dart';
import 'package:grocery_client_reboot/models/application_user.dart';
import 'package:grocery_client_reboot/models/orders_notifier/order_notifier.dart';
import 'package:grocery_client_reboot/models/product_model.dart';
import 'package:grocery_client_reboot/models/user_model_model/cart_userdata.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;  ///To Fetch current User

  Future<void> addUser(ApplicationUser user) {
    return _db.collection('users').doc(user.userId).set(user.toMap());
  }

  ///Fetch User
  Future<ApplicationUser> fetchUser(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) => ApplicationUser.fromFirestore(snapshot.data()));
  }

  ///Fetch Current User.
  Future getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  ///===========GEt User Specific Data==========

  Stream<List<ApplicationUser>> fetchUserData() {     ///WORKING
    return _db
        .collection('users')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)  ///add .toString() if required
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot.map((doc) => ApplicationUser.fromFirestore(doc.data()))
        .toList());
  }

  ///Fetching User for Edit Data==== 
  Future<ApplicationUser> fetchAvailableUsers(String userId){
    return _db.collection('users').doc(FirebaseAuth.instance.currentUser.uid)
        .get().then((snapshot) => ApplicationUser.fromFirestore(snapshot.data()));
  }

  ///Fetch User data with Future =========USE in Checkout Screen
  Future<ApplicationUser> fetchUserDataDelivery() {
    return _db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((snapshot) => ApplicationUser.fromFirestore(snapshot.data()));
  }

  ///Set User Data for update logic
  Future<void> setUserNow(ApplicationUser applicationUser) {
    var options = SetOptions(merge:true);
    return _db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set(applicationUser.toMap(),options);
  }

  ///This is also for Add Product
  Future<void> setProduct(ProductModel product) {
    var options = SetOptions(merge:true);
    return _db
        .collection('all_products')
        .doc(product.productId)
        .set(product.toMap(),options);
  }
  
  ///====Delete Function for CRUD
  Future<void> deleteItem(String id) {
    return _db.collection('notes').doc(id).delete();
  }

  ///====Update Function for CRUD == Change the collection name
  Future<void> updateItem(ApplicationUser user) {
    return _db.collection('notes').doc(user.userId).update(user.toMap());
  }

  ///Add Orders / CartItems to Firebase
  ///Set User Data for update logic

  Future<void> setCartItems(ProductModel productModel) {
    var options = SetOptions(merge:true);
    var uuid = Uuid();
    return _db
        .collection('orders')
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('cartItem')
        .doc(productModel.productId)
    // .collection('cartItems').doc(uuid.v4())
        .set(productModel.toMap(), options);    ///options
  }


///========Fetch Product for Route Array=============

  Future<ProductModel> fetchProduct(String productId){
    return _db.collection('all_products').doc(productId)
        .get().then((snapshot) => ProductModel.fromFirestore(snapshot.data()));
  }


  /// Fetch Cart Items ==== For Cart Item Fetch Now January 13-01-21 == This not for Array but Collection Doc Method
  Stream<List<ProductModel>> fetchCartItems() {
    return _db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('cartItems')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot.map((doc) => ProductModel.fromFirestore(doc.data()))
        .toList());
  }

  ///==========Fetch Order Data (Ref- Cheetah C V2)=========================
  
  getOrders(OrderNotifier orderNotifier) async{
    QuerySnapshot snapshot =  await FirebaseFirestore.instance.collection('orders')
    .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
    // .where('timeOfOrder', isLessThan: DateTime.now())
    .get();

    List<ProductModel> _productList = [];

    snapshot.docs.forEach((document) {
      ProductModel productModel = ProductModel.fromFirestore(document.data());
      _productList.add(productModel);
    });

    orderNotifier.productList = _productList;
  }
  
  ///===========FETCH USER DATA ALONG WITH CART ITEMS=============================================\\\\\\\

  ///Fetch Indiviual Cart Items from Cart for Ops

  Stream<List<ProductModel>> fetchIndividualCartItems() {
    return _db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('cartIndividualItems')
        .where('productId', isEqualTo: productModel.productId)      
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot.map((doc) => ProductModel.fromFirestore(doc.data()))
        .toList());
  }

  Stream<List<UserDataCart>> fetchUserDataForCart(){
    return _db
        .collection('users')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot
        .map((doc) => UserDataCart.fromFirestore(doc.data()))
        .toList());
  }


  ///==================All The Products to Be Displayed individually-======================
 
  Stream<List<ProductModel>> fetchAllProducts() {
    return _db
        .collection('all_products')
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot.map((doc) => ProductModel.fromFirestore(doc.data()))
        .toList());
  }

  /// Biscuit Fetch
  Stream<List<ProductModel>> fetchAvailableBiscuits() {
    return _db
        .collection('all_products')
        .where('productCategory', isEqualTo: 'Biscuit&Cookies' )      ///check here
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot.map((doc) => ProductModel.fromFirestore(doc.data()))
        .toList());
  }

  getBiscuits(OrderNotifier orderNotifier) async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('all_products')
        .where('productCategory', isEqualTo: 'Biscuit&Cookies').get();

    List<ProductModel> _productList = [];

    snapshot.docs.forEach((document) {
      ProductModel productModel = ProductModel.fromFirestore(document.data());

      _productList.add(productModel);
    });

    orderNotifier.productList = _productList;
  }



  /// Ketchup Fetch
  Stream<List<ProductModel>> fetchAvailableKetchup() {
    return _db
        .collection('all_products')
        .where('productCategory', isEqualTo: 'Ketchup&Mayo')
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot.map((doc) => ProductModel.fromFirestore(doc.data()))
        .toList());
  }

  getKetchupMayo(OrderNotifier orderNotifier) async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('all_products')
        .where('productCategory', isEqualTo: 'Ketchup&Mayo').get();

    List<ProductModel> _productList = [];

    snapshot.docs.forEach((document) {
      ProductModel productModel = ProductModel.fromFirestore(document.data());

      _productList.add(productModel);
    });

    orderNotifier.productList = _productList;
  }

  /// Milk Fetch
  Stream<List<ProductModel>> fetchAvailableMilk() {
    return _db
        .collection('all_products')
        .where('productCategory', isEqualTo: 'Milk&Dairy')
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot.map((doc) => ProductModel.fromFirestore(doc.data()))
        .toList());
  }

  getMilkDairy(OrderNotifier orderNotifier) async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('all_products')
        .where('productCategory', isEqualTo: 'Milk&Dairy').get();

    List<ProductModel> _productList = [];

    snapshot.docs.forEach((document) {
      ProductModel productModel = ProductModel.fromFirestore(document.data());

      _productList.add(productModel);
    });

    orderNotifier.productList = _productList;
  }

  /// Noodle Fetch
  Stream<List<ProductModel>> fetchAvailableNoodle() {
    return _db
        .collection('all_products')
        .where('productCategory', isEqualTo: 'Noodles&Snacks')
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot.map((doc) => ProductModel.fromFirestore(doc.data()))
        .toList());
  }

  getNoodlesSnacks(OrderNotifier orderNotifier) async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('all_products')
        .where('productCategory', isEqualTo: 'Noodles&Snacks').get();

    List<ProductModel> _productList = [];

    snapshot.docs.forEach((document) {
      ProductModel productModel = ProductModel.fromFirestore(document.data());

      _productList.add(productModel);
    });

    orderNotifier.productList = _productList;
  }

  /// Rice Fetch
  Stream<List<ProductModel>> fetchAvailableRice() {
    return _db
        .collection('all_products')
        .where('productCategory', isEqualTo: 'Rice&Pulses')
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot.map((doc) => ProductModel.fromFirestore(doc.data()))
        .toList());
  }

  getRicePulses(OrderNotifier orderNotifier) async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('all_products')
        .where('productCategory', isEqualTo: 'Rice&Pulses').get();

    List<ProductModel> _productList = [];

    snapshot.docs.forEach((document) {
      ProductModel productModel = ProductModel.fromFirestore(document.data());

      _productList.add(productModel);
    });

    orderNotifier.productList = _productList;
  }

  /// Salt Fetch
  Stream<List<ProductModel>> fetchAvailableSalt() {
    return _db
        .collection('all_products')
        .where('productCategory', isEqualTo: 'Sugar&Honey')
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot.map((doc) => ProductModel.fromFirestore(doc.data()))
        .toList());
  }

  getSugarHoney(OrderNotifier orderNotifier) async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('all_products')
        .where('productCategory', isEqualTo: 'Sugar&Honey').get();

    List<ProductModel> _productList = [];

    snapshot.docs.forEach((document) {
      ProductModel productModel = ProductModel.fromFirestore(document.data());

      _productList.add(productModel);
    });

    orderNotifier.productList = _productList;
  }

  /// Spice Fetch
  Stream<List<ProductModel>> fetchAvailableSpice() {
    return _db
        .collection('all_products')
        .where('productCategory', isEqualTo: 'Spices&Salt')
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot.map((doc) => ProductModel.fromFirestore(doc.data()))
        .toList());
  }

  getSpicesSalt(OrderNotifier orderNotifier) async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('all_products')
        .where('productCategory', isEqualTo: 'Spices&Salt').get();

    List<ProductModel> _productList = [];

    snapshot.docs.forEach((document) {
      ProductModel productModel = ProductModel.fromFirestore(document.data());

      _productList.add(productModel);
    });

    orderNotifier.productList = _productList;
  }


  /// Tea Fetch
  Stream<List<ProductModel>> fetchAvailableTea() {
    return _db
        .collection('all_products')
        .where('productCategory', isEqualTo: 'Tea&Coffee')
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) => snapshot.map((doc) => ProductModel.fromFirestore(doc.data()))
        .toList());
  }

  getTeaCoffee(OrderNotifier orderNotifier) async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('all_products')
        .where('productCategory', isEqualTo: 'Tea&Coffee').get();

    List<ProductModel> _productList = [];

    snapshot.docs.forEach((document) {
      ProductModel productModel = ProductModel.fromFirestore(document.data());

      _productList.add(productModel);
    });

    orderNotifier.productList = _productList;
  }


  ///Fetching Product for Edit Product / Products
  Future<ProductModel> fetchAvailableProducts(String productId){
    return _db.collection('all_products').doc(productId)
        .get().then((snapshot) => ProductModel.fromFirestore(snapshot.data()));
  }
}

///For Image Upload Service
class FirebaseStorageImageService {

  final storage = FirebaseStorage.instance;

  Future<String> uploadProductImage(File file, String fileName) async {
    var snapshot = await storage.ref()
        .child('productImages/$fileName')
        .putFile(file)
        .onComplete;

    return await snapshot.ref.getDownloadURL();       ///returns the url of image in firestore storage
  }

}

///For User Image Upload Service
class FirebaseStorageUserImageService {

  final storage = FirebaseStorage.instance;

  Future<String> uploadProductImage(File file, String fileName) async {
    var snapshot = await storage.ref()
        .child('userImages/$fileName')
        .putFile(file)
        .onComplete;

    return await snapshot.ref.getDownloadURL();       ///returns the url of image in firestore storage
  }

}