import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_client_reboot/app.dart';
import 'package:grocery_client_reboot/models/product_model.dart';
import 'dart:io';
import 'package:provider/provider.dart';

///This is the penultimate Checkout Page for Order Review


class CartDataScreen extends StatefulWidget {
  @override
  _CartDataScreenState createState() => _CartDataScreenState();
}

class _CartDataScreenState extends State<CartDataScreen> {
  double total = 0.0;

  ///To Calculate the total values

  @override
  void initState() {
    queryValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var array = Provider.of<ArrayProduct>(context);     ///Local Array Import

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: true,
                pinned: true,
                snap: true,
                actionsIconTheme: IconThemeData(opacity: 0.0),
                flexibleSpace: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Image.asset('assets/images/shopping_cart.jpg'),
                      top: -70.0,
                      ///was -10
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: new EdgeInsets.all(10.0),
                sliver: new SliverList(
                  delegate: new SliverChildListDelegate([
                    Center(
                        child: Text(
                      'Your Cart Items',
                      style: GoogleFonts.poppins(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    )),
                    Divider(
                      color: Colors.indigo,
                      thickness: 3.0,
                    )
                  ]),
                ),
              ),
            ];
          },
          body: Flexible(
            child: StreamBuilder<List<ProductModel>>(
                stream: productBloc.fetchCartItem,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: (Platform.isIOS)
                          ? CupertinoActivityIndicator()
                          : CircularProgressIndicator(),
                    );
                  if (snapshot.data.length > 0)
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        print(snapshot.data.length);
                        var cartItemFetch = snapshot.data[index];

                        return ListTile(
                          leading: (cartItemFetch.imageUrl != '')
                              ? Image.network(
                                  cartItemFetch.imageUrl,
                                  height: 80,
                                  width: 80,
                                )
                              : Image.asset(
                                  'assets/images/vegetables.png',
                                  // height: 150,
                                  height: 80,
                                  width: 80,
                                ),
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              cartItemFetch.productName,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600, fontSize: 20.0),
                            ),
                          ),
                          subtitle: Text(
                            '₹ ${cartItemFetch.unitPrice}    x ${cartItemFetch.quantity}',
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.black),
                          ),
                          trailing: InkWell(
                            child: Icon(
                              Icons.delete,
                              size: 30.0,
                              color: Colors.red,
                            ),
                            onTap: () {
                              ///Delete Item from Local Array
                              array.removeArrayItemWithSameId(cartItemFetch.productId);
                              print(array.cartArray.toString());  ///print

                              ///Delete Item from Firebase Function
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection('cartItems')
                                  .doc(cartItemFetch.documentId)
                                  .delete();
                            },
                          ),
                          isThreeLine: true,
                        );
                      },
                    );
                  else
                    return Center(
                        child: Text(
                      'Cart is Empty',
                      style: GoogleFonts.poppins(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ));
                }),
            flex: 3,
          ),
        ),
      ),

      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListTile(
                  title: Text(
                    'Grand Total:',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  subtitle: Text('    ₹ $total',
                      style: GoogleFonts.roboto(
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                )),
            if (total > 0)                  ///If Check
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/checkout'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: Text(
                      'Check Out',
                      style: GoogleFonts.poppins(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: Text(
                      'Check Out',
                      style: GoogleFonts.poppins(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void queryValues() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('cartItems')
        .snapshots()
        .listen((snapshot) {
      double tempTotal = snapshot.docs
          .fold(0, (tot, doc) => tot + doc.data()['totalItemValue']);

      if (this.mounted) {
        setState(() {
          total = tempTotal;

          // debugPrint(total.toString()); //debug
        });
      }


    });
  }
}
