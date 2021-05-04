import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_client_reboot/models/cart_model/cart.dart';
import 'package:grocery_client_reboot/models/product_model.dart';
import 'package:grocery_client_reboot/models/single_cart_item/single_cart_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

///This is the Final Checkout Page using Local MAP Function == Currently used as Final Checkout

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  Map<dynamic, dynamic> codData = {};
  Future<Null> getData() async {
    await FirebaseFirestore.instance
        .collection('delivery_charge').doc('ivYg5zmO6gzIYo8EfUXg')  // Enter Doc name manually if error => It worked !!
        .get().then((val) {
      codData.addAll(val.data());
    }).whenComplete(() {
      setState(() {});
    });
  }

  @override
  void initState() {
    getData();      ///Calls the Function from above and assigns the value
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    var array = Provider.of<ArrayProduct>(context);     ///Local Array Import
    var uuid = Uuid();

    return Scaffold(
        body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
       return [
        SliverAppBar(
          expandedHeight: 90.0,
          floating: true,
          pinned: false,    ///true
          snap: true,
          actionsIconTheme: IconThemeData(opacity: 0.0),
          flexibleSpace: Stack(
            children: <Widget>[
              Positioned(
                child: Image.asset('assets/images/shopping_cart.jpg'),
                top: -95.0,    
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
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  )),
              Divider(
                color: Colors.indigo,
                thickness: 3.0,
              ),
            ]),
          ),
        ),
      ];
    },

      body: Column(
          children: <Widget>[
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.info_outline_rounded, size: 22.0, color: Colors.redAccent),
                    SizedBox(width: 2.0,),
                    Text('Delivery Charges may apply,',
                      style: GoogleFonts.poppins(fontSize: 15.0, fontWeight: FontWeight.w500),
                    ),
                    InkWell(
                      child: Text(' click here.',
                        style: GoogleFonts.poppins(fontSize: 15.0,
                            fontWeight: FontWeight.w500, color: Colors.teal),
                      ),
                      onTap: () => Navigator.of(context).pushNamed('/faq')
                    ),
                  ],
                ),
              ),

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
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ),
        ]),
        ),
    ),

      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListTile(
                  title: Text('To Pay via COD:',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('₹ ${cart.totalAmount}',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black),
                  ),
                )),
              if (cart.totalAmount > 0)
              Expanded(
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                  onPressed: () {
                  var options = SetOptions(merge:true);
                  FirebaseFirestore.instance
                      .collection('orders')
                      .doc().set({
                      'userId' : FirebaseAuth.instance.currentUser.uid,
                      'userEmail' : FirebaseAuth.instance.currentUser.email,
                      'orderId' : uuid.v4(),
                      'timeOfOrder': DateTime.now(),
                      'orderStatus' : 'Placed',
                      'totalAmount' : cart.totalAmount,
                      'orders' : array.cartArray,
                      'codExtra' : cart.totalAmount < codData['minOrderValue'] ? codData['deliveryCharge'] : 0,
                  }, options).then((value) => array.clearArrayList()); ///options

                    cart.clear(); 

                    _showOrderSuccess();
                  },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                   ),
                    child: Text(
                    'Place Order',
                    style: GoogleFonts.poppins(
                    fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              )
            ///===Button willbe disabled
            else if (cart.totalAmount < 0)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: Text(
                      '',
                      style: GoogleFonts.poppins(
                          fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.redAccent),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _showOrderSuccess() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Success !!!')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: Text('Your Order has been placed.', style: GoogleFonts.poppins(fontSize: 15.0, fontWeight: FontWeight.w500),)),
                SizedBox(height: 20.0,),
                Center(child: Text('You can track your orders in My Orders Section.', style: GoogleFonts.poppins(fontSize: 15.0, fontWeight: FontWeight.w500),)),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text('Okay', style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w500),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
          elevation: 20.0,
        );
      },
    );
  }
}
