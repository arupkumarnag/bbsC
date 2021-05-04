import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_client_reboot/models/orders_notifier/order_notifier.dart';
import 'package:grocery_client_reboot/models/product_model.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context, listen: false);
    var product = Provider.of<ProductModel>(context);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
           image: AssetImage('assets/images/abs1.jpg'),
            fit: BoxFit.fill),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,

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
                        child: Image.asset('assets/images/orders_details.jpg'),
                        top: -180.0,     ///was -10
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: new EdgeInsets.all(10.0),
                  sliver: new SliverList(
                    delegate: new SliverChildListDelegate([
                      
                    ]),
                  ),
                ),
              ];
            },

            body: Container(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Text(
                            'Order Details',
                            style: GoogleFonts.poppins(
                                fontSize: 25.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )),

                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: orderNotifier.model.orders
                              .map(
                                (orders) => ListTile(
                              tileColor: Colors.white70,
                              leading: Icon(Icons.brightness_1,
                                  size: 30.0, color: Colors.deepPurpleAccent),
                              title: Text(
                                orders,
                                style: GoogleFonts.poppins(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ),
        ),
      ),
    );
  }
}
