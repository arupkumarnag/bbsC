// import 'package:flutter/material.dart';
// import 'package:grocery_client_reboot/models/product_model.dart';
// import 'package:provider/provider.dart';
//
//
// class ProductDetail extends StatefulWidget {
//   // final String title;     ///name
//   // final double price;
//   // final String description;
//   // final String image;
//   // final String offer;
//   // final String id; ///productId
//   //
//   // ProductDetail({
//   //   this.title, this.price,
//   //   this.description, this.image,
//   //   this.offer, this.id
//   // });
//
//   @override
//   _ProductDetailState createState() => _ProductDetailState();
// }
//
//
// class _ProductDetailState extends State<ProductDetail> {
//   @override
//   Widget build(BuildContext context) {
//     var productItems = Provider.of<ProductModel>(context);
//     final productId = ModalRoute.of(context).settings.arguments as String;
//     final loadedPdt = Provider.of<ProductsModel>(context).findById(productId);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(loadedPdt.productName != null
//             ? '${loadedPdt.productName}' : 'no data',
//
//         ),
//       ),
//     );
//   }
// }
