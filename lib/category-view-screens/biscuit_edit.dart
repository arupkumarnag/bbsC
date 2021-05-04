import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_client_reboot/blocs/product_bloc.dart';
import 'package:grocery_client_reboot/models/application_user.dart';
import 'package:grocery_client_reboot/models/cart_model/cart.dart';
import 'package:grocery_client_reboot/models/product_model.dart';
import 'package:grocery_client_reboot/services/firestore_service.dart';
import 'package:provider/provider.dart';

class BiscuitPage extends StatefulWidget {
  @override
  _BiscuitPageState createState() => _BiscuitPageState();
}

class _BiscuitPageState extends State<BiscuitPage> {
  int total = 0;

  ///To Calculate the total Items counter
  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var productBloc = Provider.of<ProductBloc>(context);
    final cart = Provider.of<Cart>(context);
    
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            'Biscuit & Cookies',
            style: GoogleFonts.poppins(fontSize: 22.0, fontWeight: FontWeight.w600),
          )),
          backgroundColor: Colors.teal,
          actions: <Widget>[
            // if (total > 0)
              InkWell(
                onTap: () => Navigator.of(context).pushNamed('/cart'),
                child: Stack(
                  children: <Widget>[
                     IconButton(icon: new Icon(Icons.shopping_cart_outlined,
                       color: Colors.black, size: 40,),
                ),
                Positioned(
                    child: Stack(
                      children: <Widget>[
                        Icon(
                            Icons.brightness_1,
                            size: 30.0,
                            color: Colors.teal
                        ),
                        Positioned(
                            top: -1.0,
                            right: 5.0,
                            child: InkWell(
                              // onTap: () => Navigator.of(context).pushNamed('/cart'),
                              child: Center(
                                // child: Text('$total',
                                child: Text('${cart.items.length}',
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    )
                ),
                ]
            ),
              ),
          ],
        ),
        body: StreamBuilder<List<ProductModel>>(
            stream: productBloc.fetchAvailableBiscuits,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              ///Fix for length.null error
              if (snapshot.data.length > 0)
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        child: Row(
                          children: <Widget>[
                            product.inStock == 'Yes' ?
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.white,
                                ),
                                child: (product.imageUrl != null)
                                    ? Image.network(
                                              product.imageUrl,
                                              height: 80,
                                              width: 80,
                                            )
                                    : Image.asset(
                                        'assets/images/vegetables.png',
                                        // height: 150,
                                        height: 80,
                                        width: 80,
                                      ),
                              ),
                            )
                            : Expanded(
                              child: ImageFiltered(
                                imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 2),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.white,
                                  ),
                                  child: (product.imageUrl != null)
                                      ? Image.network(
                                    product.imageUrl,
                                    height: 80,
                                    width: 80,
                                  )
                                      : Image.asset(
                                    'assets/images/vegetables.png',
                                    // height: 150,
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    product.productName,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 19.0),
                                  ),
                                  product.inStock == 'Yes' ?
                                  Text('₹ ${product.unitPrice}',
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          color: Colors.black)) : Text(''),

                                  product.inStock == 'Yes' ?
                                  Text(
                                      product.productOffer != null
                                          ? '${product.productOffer}'
                                          : '',
                                      style: GoogleFonts.mcLaren(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal)) : Text(''),
                                  SizedBox(height: 10),
                                  Container(
                                    child: Center(
                                      child: Row(
                                        children: [
                                          product.inStock == 'Yes' ?
                                          RaisedButton(
                                            onPressed: () =>
                                              Navigator.of(context).pushNamed('/quantityunit/${product.productId}'),
                                            color: Colors.teal,
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.shopping_cart,
                                                  size: 30.0,
                                                  color: Colors.amber,
                                                ),
                                                SizedBox(width: 15.0,),
                                                Text('Select', style: GoogleFonts.poppins(
                                                    fontSize: 20.0, fontWeight: FontWeight.w600,color: Colors.white),),
                                              ],
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0),
                                                side: BorderSide(color: Colors.transparent)
                                            ),
                                          )
                                          //==Out of Stock====
                                          : Text('Out of Stock', style:GoogleFonts.poppins(
                                                  fontSize: 20.0, fontWeight: FontWeight.w600,color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              else
                return Center(
                    child: Text(
                  'No Products Available',
                  style: GoogleFonts.poppins(
                      fontSize: 20.0, fontWeight: FontWeight.w500),
                ));
            }),
      ),
    );
  }
}

