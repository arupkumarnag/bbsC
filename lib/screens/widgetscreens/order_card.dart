import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_client_reboot/models/product_model.dart';

///This is how individual Order will look like in the Orders Screen

class OrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderId;

  OrderCard({
    Key key, this.data, this.itemCount, this.orderId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      child: ListView.builder(
          itemCount:  itemCount,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            ProductModel productModel = ProductModel.fromFirestore(data[index].data());
            return sourceOrderInfo(productModel, context);
          }
      ),
    );
  }

  Widget sourceOrderInfo(ProductModel productModel, BuildContext context) {
    return Container(

      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              productModel.productName,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 19.0),
            ),
            Text('₹ ${productModel.unitPrice}',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.black)),
            Text(
                productModel.productOffer != null
                    ? '${productModel.productOffer}'
                    : '',
                style: GoogleFonts.mcLaren(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal)),
            SizedBox(height: 10),
            Container(
            ),
          ],
        ),
      ),
    );
  }


}
