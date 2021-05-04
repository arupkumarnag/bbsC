import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_client_reboot/models/cart_model/cart.dart';
import 'package:grocery_client_reboot/models/product_model.dart';
import 'package:provider/provider.dart';

///How an Item Looks Like

class CartProduct extends StatelessWidget {
  final String id;
  final String img;
  final String productId;
  final int price;
  final int qty;
  final String name;

  CartProduct(this.id, this.img, this.productId, this.price, this.qty, this.name);
  @override
  Widget build(BuildContext context) {
    var array = Provider.of<ArrayProduct>(context);     ///Local Array Import

    return Container(
      child: Card(
            child: ListTile(
              leading: (img != null)
                  ? Image.network(
                img,
                height: 80,
                width: 80,
              )
                  : Image.asset(
                'assets/images/vegetables.png',
                // height: 150,
                height: 80,
                width: 80,
              ),
              title: Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 19.0),),
              subtitle: Text('Total: ₹${(price) * (qty)}     Qty: $qty', style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 19.0,
                  color: Colors.black)),

              trailing: InkWell(
                onTap: () {
                  Provider.of<Cart>(context, listen: false).removeItem(productId);    ///Map function
                  array.removeArrayItemWithSameId(name);   ///remove from Array
                  print(array.cartArray);
                  },
                child: Icon(
                  Icons.delete,
                  size: 30.0,
                  color: Colors.red,
                ),
              ),
            ),
          ),
    );
  }
}

