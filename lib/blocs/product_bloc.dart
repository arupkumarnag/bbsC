import 'dart:async';
import 'dart:io';
import 'package:grocery_client_reboot/models/application_user.dart';
import 'package:grocery_client_reboot/models/product_model.dart';
import 'package:grocery_client_reboot/services/firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class ProductBloc {
  final _productName = BehaviorSubject<String>();
  final _productQuantity = BehaviorSubject<String>();
  final _unitType = BehaviorSubject<String>();
  final _productCategory = BehaviorSubject<String>();   
  final _unitPrice = BehaviorSubject<String>();
  final _availableUnits = BehaviorSubject<String>();
  final _productDescription = BehaviorSubject<String>();
  final _productOffer = BehaviorSubject<String>();
  final _vendorId = BehaviorSubject<String>();

  final _productSaved = PublishSubject<bool>();
  final _product = BehaviorSubject<ProductModel>();
  final _user = BehaviorSubject<ApplicationUser>();
  final db = ProductService();
  var uuid = Uuid();
  final _imageUrl = BehaviorSubject<String>();

  final _picker = ImagePicker();     
  final storageService = FirebaseStorageImageService();
  final _isUploading = BehaviorSubject<bool>();

  ///Get
  Stream<String> get productName => _productName.stream.transform(validateProductName);

  Stream<String> get productDescription => _productDescription.stream.transform(validateProductDescription);
  Stream<String> get unitType => _unitType.stream;
  Stream<String> get productCategory => _productCategory.stream;
  Stream<String> get productOffer => _productOffer.stream;
  Stream<double> get unitPrice => _unitPrice.stream.transform(validateUnitPrice);
  Stream<int> get availableUnits => _availableUnits.stream.transform(validateAvailableUnits);
  Future<ProductModel> fetchProduct(String productId) => db.fetchProduct(productId);

  Stream<bool> get isValid => CombineLatestStream.combine6(
      productName,
      // productQuantity,
      unitType,
      unitPrice,
      availableUnits,
      productDescription,
      productCategory,
          (a, b, c, d, e, f) => true);

 
  Stream<List<ProductModel>> get fetchAvailableBiscuits => db.fetchAvailableBiscuits();
  Stream<List<ProductModel>> get fetchAvailableKetchups => db.fetchAvailableKetchup();
  Stream<List<ProductModel>> get fetchAvailableMilk => db.fetchAvailableMilk();
  Stream<List<ProductModel>> get fetchAvailableNoodle => db.fetchAvailableNoodle();
  Stream<List<ProductModel>> get fetchAvailableRice => db.fetchAvailableRice();
  Stream<List<ProductModel>> get fetchAvailableSalt => db.fetchAvailableSalt();
  Stream<List<ProductModel>> get fetchAvailableSpice => db.fetchAvailableSpice();
  Stream<List<ProductModel>> get fetchAvailableTea => db.fetchAvailableTea();
  Stream<List<ProductModel>> get fetchCartItem => db.fetchCartItems();
  Stream<List<ProductModel>> get fetchCartDataIndividual => db.fetchIndividualCartItems();        
  String get userId => _user.value.userId;
  Stream<bool> get productSaved => _productSaved.stream;

  Future<ProductModel> fetchAvailableProducts(String productId) => db.fetchAvailableProducts(productId);

  Stream<String> get imageUrl=> _imageUrl.stream;  
  Stream<bool> get isUploading => _isUploading.stream;

  ///Set
  Function(String) get changeProductName => _productName.sink.add;
  Function(String) get changeProductDescription => _productDescription.sink.add;

  ///Added
  Function(String) get changeUnitType => _unitType.sink.add;
  Function(String) get changeProductCategory => _productCategory.sink.add;
  Function(String) get changeUnitPrice => _unitPrice.sink.add;
  Function(String) get changeAvailableUnits => _availableUnits.sink.add;
  Function(String) get changeAvailableQuantity => _productQuantity.sink.add;
  Function(String) get changeProductOffer => _productOffer.sink.add;
  Function(String) get changeProductQuantity => _productQuantity.sink.add;

  Function(String) get changeVendorId => _vendorId.sink.add;
  Function(String) get changeImageUrl => _imageUrl.sink.add;
  Function(ProductModel) get changeProduct => _product.sink.add;


  dispose() {
    _productName.close();
    _productQuantity.close();
    _unitType.close();
    _unitPrice.close();
    _availableUnits.close();
    _productDescription.close();
    _productCategory.close();
    _productOffer.close();
    _vendorId.close();
    _productSaved.close();
    _user.close();
    _product.close();
    _imageUrl.close(); 
    _isUploading.close();
  }

  ///================================Functions===========
  
  ///Validators

  final validateProductQuantity = StreamTransformer<String, int>.fromHandlers(
      handleData: (productQuantity, sink) {
        if (productQuantity != null) {
          try {
            sink.add(int.parse(productQuantity));
          } catch (error) {
            sink.addError('Must be a whole number');
          }
        }
      });

  final validateUnitPrice = StreamTransformer<String, double>.fromHandlers(
      handleData: (unitPrice, sink) {
        if (unitPrice != null) {
          try {
            sink.add(double.parse(unitPrice));
          } catch (error) {
            sink.addError('Must be a number');
          }
        }
      });

  final validateAvailableUnits = StreamTransformer<String, int>.fromHandlers(
      handleData: (availableUnits, sink) {
        if (availableUnits != null) {
          try {
            sink.add(int.parse(availableUnits));
          } catch (error) {
            sink.addError('Must be a whole number');
          }
        }
      });

  final validateProductName = StreamTransformer<String, String>.fromHandlers(
      handleData: (productName, sink) {
        if (productName != null) {
          if (productName.length >= 3 && productName.length <= 50) {
            sink.add(productName.trim());
          } else {
            if (productName.length < 3) {
              sink.addError('3 Character Minimum');
            } else {
              sink.addError('50 Character Maximum');
            }
          }
        }
      });

  ///===For Product Description Validator===================
  final validateProductDescription =
  StreamTransformer<String, String>.fromHandlers(
      handleData: (productDescription, sink) {
        if (productDescription != null){
          if (productDescription.length >= 5 && productDescription.length <= 200) {
            sink.add(productDescription.trim());
          } else {
            if (productDescription.length < 5) {
              sink.addError('3 Character Minimum');
            } else {
              sink.addError('200 Character Maximum');
            }
          }
        }
      });

  ///==========To Save Images From Gallery =======================

  pickImage() async {
    PickedFile image;

    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {

      /// Getting Image From Device
      image = await _picker.getImage(source: ImageSource.gallery);
      print(image.path);

      /// Now Upload to Firebase
      if (image != null) {
        _isUploading.sink.add(true);

        var imageUrl = await storageService.uploadProductImage(File(image.path), uuid.v4());
        print(imageUrl);
        changeImageUrl(imageUrl);       

        _isUploading.sink.add(false);

      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions & try again');
    }
  }
}



















// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:groceryapp_seller/models/product_model.dart';
// import 'package:groceryapp_seller/services/firestore_service.dart';
// import 'package:uuid/uuid.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:rxdart/subjects.dart';
//
//
// class ProductBloc {
//   final _productName = BehaviorSubject<String>();
//   final _unitType = BehaviorSubject<String>();
//   final _unitPrice = BehaviorSubject<String>();
//   final _availableUnits = BehaviorSubject<String>();
//   final _productDescription = BehaviorSubject<String>();
//   final _productCategory = BehaviorSubject<String>();    ///Product Category Option
//   final _productOffer = BehaviorSubject<String>();
//   final _vendorId = BehaviorSubject<String>();
//
//   final db = FirestoreService();
//   var uuid = Uuid();
//
//   ///Get
//   Stream<String> get productName => _productName.stream.transform(validateProductName);
//   Stream<String> get productDescription => _productDescription.stream.transform(validateProductDescription); ///Added
//   Stream<String> get productCategory => _unitType.stream; ///Added for Category of Product
//   Stream<String> get unitType => _unitType.stream;
//   Stream<String> get productOffer => _productOffer.stream;
//   Stream<double> get unitPrice => _unitPrice.stream.transform(validateUnitPrice);
//   Stream<int> get availableUnits => _availableUnits.stream.transform(validateAvailableUnits);
//
//   // Stream<bool> get isValid => CombineLatestStream.combine4(productName, unitType, unitPrice, availableUnits, (a, b, c, d) => true);
//   // Stream<bool> get isValid => CombineLatestStream.combine5(
//   //     productName, unitType, unitPrice, availableUnits, productDescription, (a, b, c, d, e) => true);
//
//   StreamBuilder<bool> get isValid => CombineLatestStream.combine6(
//       productName, unitType, unitPrice, availableUnits, productDescription, productCategory, (a, b, c, d, e, f) => true);
//
//   ///Set
//   Function(String) get changeProductName => _productName.sink.add;
//   Function(String) get changeProductDescription => _productDescription.sink.add;    ///Added
//   Function(String) get changeProductCategory => _productDescription.sink.add;    ///Product Category
//   Function(String) get changeUnitType => _unitType.sink.add;
//   Function(String) get changeUnitPrice => _unitPrice.sink.add;
//   Function(String) get changeAvailableUnits => _availableUnits.sink.add;
//   Function(String) get changeProductOffer => _productOffer.sink.add;        ///Added
//   Function(String) get changeVendorId => _vendorId.sink.add;
//
//
//   dispose() {
//     _productName.close();
//     _unitType.close();
//     _unitPrice.close();
//     _availableUnits.close();
//     _productDescription.close();
//     _productCategory.close();
//     _productOffer.close();
//     _vendorId.close();
//   }
//
//   Future<void> saveProduct() async {
//     var product = Product(
//       approved: true,
//       availableUnits: int.parse(_availableUnits.value),
//       productId: uuid.v4(),
//       productName: _productName.value.trim(),
//       unitPrice: double.parse(_unitPrice.value),
//       unitType: _unitType.value,
//       // vendorId: _vendorId.value,
//       productDescription: _productDescription.value,
//       productCategory: _productCategory.value,
//       productOffer: _productOffer.value,
//     );
//
//     return db
//         .setProduct(product)                      ///getProduct is now setProduct
//         .then((value) => print('Product Saved'))
//         .catchError((error) => print(error));
//   }
//
//
//
//   ///Validators
//   final validateUnitPrice = StreamTransformer<String, double>.fromHandlers(
//       handleData: (unitPrice, sink) {
//         try {
//           sink.add(double.parse(unitPrice));
//         } catch (error) {
//           sink.addError('Must be a number');
//         }
//       });
//
//   final validateAvailableUnits = StreamTransformer<String, int>.fromHandlers(
//       handleData: (availableUnits, sink) {
//         try {
//           sink.add(int.parse(availableUnits));
//         } catch (error) {
//           sink.addError('Must be a whole number');
//         }
//       });
//
//   final validateProductName = StreamTransformer<String, String>.fromHandlers(
//       handleData: (productName, sink) {
//         if (productName.length >= 3 && productName.length <= 20) {
//           sink.add(productName.trim());
//         } else {
//           if (productName.length < 3) {
//             sink.addError('3 Character Minimum');
//           } else {
//             sink.addError('25 Character Maximum');
//           }
//         }
//       });
//
//   ///===Added This Later == For Product Description Validator
//
//   final validateProductDescription = StreamTransformer<String,
//       String>.fromHandlers(handleData: (productDescription, sink) {
//     if (productDescription.length >= 5 && productDescription.length <= 200) {
//       sink.add(productDescription.trim());
//     } else {
//       if (productDescription.length < 5) {
//         sink.addError('3 Character Minimum');
//       } else {
//         sink.addError('200 Character Maximum');
//       }
//     }
//   });
//
//   // final validateProductCategory = StreamTransformer<String,
//   //     String>.fromHandlers(handleData: (productDescription, sink) {
//   //   if (productDescription.length >= 5 && productDescription.length <= 200) {
//   //     sink.add(productDescription.trim());
//   //   } else {
//   //     if (productDescription.length < 5) {
//   //       sink.addError('3 Character Minimum');
//   //     } else {
//   //       sink.addError('200 Character Maximum');
//   //     }
//   //   }
//   // });
//
// }