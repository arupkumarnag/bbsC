import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_client_reboot/models/cart_model/cart.dart';
import 'package:grocery_client_reboot/models/product_model.dart';
import 'package:grocery_client_reboot/models/single_cart_item/single_cart_item.dart';
import 'package:grocery_client_reboot/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


///====THis is the Final Checkout Screen of for the User.


class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double total = 0.0;       ///To Calculate the total values

  @override
  void initState() {
    queryValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);
    

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('Review & Confirm Order',
                style: GoogleFonts.poppins(
                    fontSize: 22.0, fontWeight: FontWeight.w500))),
        backgroundColor: Colors.teal,
      ),

      body: Column(
          children: <Widget>[
            Card(
              elevation: 15.0,
              color: Colors.white70,
              shadowColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  child: Column(
                    children: [
                      SizedBox(height: 10.0,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Please update your contact & delivery address if changed. '
                              'Double Tap to Update !',
                          style: GoogleFonts.poppins(
                              fontSize: 15.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  onDoubleTap: () =>
                      Navigator.of(context).pushNamed('/addresspage'),
                ),
              ),
            ),

            Flexible(
              child: Column(children: <Widget>[
                if (cart.items.length > 0)
                  Expanded(
                    child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (ctx, i) => CartProduct(
                            cart.items.values.toList()[i].id,
                            cart.items.values.toList()[i].img,
                            cart.items.keys.toList()[i],
                            cart.items.values.toList()[i].price,
                            cart.items.values.toList()[i].qty,
                            cart.items.values.toList()[i].name)),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Center(
                        child: Text(
                          'Your Cart is Empty !',
                          style: GoogleFonts.poppins(
                            fontSize: 20.0,
                          ),
                        )),
                  ),
              ]),
              flex: 3,
            ),
          ]),

      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListTile(
                  title: Text(
                    'To Pay via COD:',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('   ₹ $total', style: GoogleFonts.roboto(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: () {
                  
                    _showOrderSuccess();

                  },
                  child: Text(
                    'Place Order',
                    style: GoogleFonts.poppins(
                        fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),

                  color: Colors.teal,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showOrderSuccess() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {

        return AlertDialog(
          title: Center(child: Text('Thank You !!!')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: Text('Your Order has been placed.', style: GoogleFonts.poppins(fontSize: 15.0, fontWeight: FontWeight.w500),)),
                SizedBox(height: 20.0,),
                Center(child: Text('We will keep you updated.', style: GoogleFonts.poppins(fontSize: 15.0, fontWeight: FontWeight.w500),)),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text('Okay', style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w500),),
                onPressed: () {

                  ///Delete the Firebase Docs.
                  FirebaseFirestore.instance.collection('users')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection('cartItems')
                      .get().then((snapshot) {
                     for (DocumentSnapshot ds in snapshot.docs){
                      ds.reference.delete();
                    }
                  });

                  Navigator.of(context).pushNamed('/landing');
                },
              ),
            ),
          ],
          elevation: 20.0,
        );
      },
    );
  }

  void queryValues() {
    FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('cartItems')
        .snapshots().listen((snapshot) {
      double tempTotal= snapshot.docs.fold(0, (tot, doc) =>
      tot + doc.data()['totalItemValue']);

      if(this.mounted) {
        setState(() {
          total = tempTotal;

          // debugPrint(total.toString());   //debug
        });
      }
    });
  }
}
