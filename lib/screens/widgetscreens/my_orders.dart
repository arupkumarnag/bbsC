import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_client_reboot/app.dart';
import 'package:grocery_client_reboot/models/cart_model/cart.dart';
import 'package:grocery_client_reboot/models/orders_notifier/order_notifier.dart';
import 'package:grocery_client_reboot/models/product_model.dart';
import 'package:grocery_client_reboot/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {

  Map<dynamic, dynamic> codData = {};


  Future<Null> getData() async {
    await FirebaseFirestore.instance
        .collection('delivery_charge').doc('ivYg5zmO6gzIYo8EfUXg') 
        .get().then((val) {
      codData.addAll(val.data());
    }).whenComplete(() {
      print('Data Fetched');
      print(codData);
      setState(() {});
    });
  }


  @override
  void initState() {
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context, listen: false);
    service.getOrders(orderNotifier);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);

    ///Local Array Import

    return Scaffold(
        body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120.0,
              floating: true,
              pinned: false,

              ///true
              snap: true,
              actionsIconTheme: IconThemeData(opacity: 0.0),
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned(
                    child: Image.asset('assets/images/past_orders.jpg'),
                    top: -90.0,

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
                    'Your Order History',
                    style: GoogleFonts.poppins(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  )),
                  Divider(
                    color: Colors.deepPurple,
                    thickness: 3.0,
                  )
                ]),
              ),
            ),
          ];
        },

        body: ListView.separated(
          itemCount: orderNotifier.productList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.transparent,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                orderNotifier.model = orderNotifier.productList[index];
                  Navigator.of(context).pushNamed('/order-details');
              },
              child: Card(
                elevation: 10.0,
                shadowColor: Colors.blueAccent,
                color: Colors.lightGreen,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.info_outline_rounded, size: 22.0, color: Colors.blueAccent),
                            SizedBox(width: 10.0,),
                            Text('Click to view ordered items',
                              style: GoogleFonts.poppins(fontSize: 15.0, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.0,),
                      Divider(),
                      Row(
                        children: [
                          Text('Your Order Id : ', style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Text(
                        '${orderNotifier.productList[index].orderId}.',
                         style: GoogleFonts.poppins(fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Column(
                        children: <Widget>[
                          Text('---Time of Order---', style: GoogleFonts.poppins(fontSize: 22.0, fontWeight: FontWeight.w600)),
                          Text((orderNotifier.productList[index].timeOfOrder != null) ?
                          '${DateFormat.yMMMd().add_jm().format(orderNotifier.productList[index].timeOfOrder.toDate())}.' : '',
                              style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w600)),
                        ],
                      ),

                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Text(
                              'To Pay via COD : ',
                              style: GoogleFonts.roboto(fontSize: 20.0, fontWeight: FontWeight.w700)),
                          Text(
                              '₹ ${orderNotifier.productList[index].totalAmount.toString()}',
                              style: GoogleFonts.roboto(fontSize: 20.0)),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Text(
                              'COD Charges Extra : ',
                              style: GoogleFonts.roboto(fontSize: 20.0, fontWeight: FontWeight.w700)),
                          Text(
                              '₹ ${orderNotifier.productList[index].codExtra.toString()}',
                              style: GoogleFonts.roboto(fontSize: 20.0)),
                        ],
                      ),
                      SizedBox(height: 15.0),


                      Row(
                        children: <Widget>[
                          Text('Order Status : ',
                              style: GoogleFonts.poppins(
                                  fontSize: 20.0, fontWeight: FontWeight.w600)),
                          ///Order Status -- If Statement can be done here
                          Text('${orderNotifier.productList[index].orderStatus}', style: GoogleFonts.poppins(
                            fontSize: 20.0, fontWeight: FontWeight.w700, color: Colors.black)),
                      ],
                     ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ));
  }
}
