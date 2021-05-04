import 'dart:async';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_client_reboot/blocs/auth_bloc.dart';
import 'package:grocery_client_reboot/blocs/product_bloc.dart';
import 'package:grocery_client_reboot/models/application_user.dart';
import 'package:grocery_client_reboot/models/cart_model/cart.dart';
import 'package:grocery_client_reboot/screens/widgetscreens/main-category-two.dart';
import 'package:grocery_client_reboot/services/firestore_service.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  StreamSubscription _userSubscription;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var authBloc = Provider.of<AuthBloc>(context, listen: false);
      widget._userSubscription = authBloc.user.listen((user) {
        if (user == null)
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (route) => false);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    widget._userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
    var service = Provider.of<ProductService>(context);
    final cart = Provider.of<Cart>(context);
    final uid = Provider.of<ProductService>(context);
    var productBloc = Provider.of<ProductBloc>(context);

    ///===Image Carousel=================
    Widget imageCarousel = new Container(
      height: 200.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: SizedBox(
          height: 200,
          width: 380,
          child: new Carousel(
            boxFit: BoxFit.cover,
            images: [
              AssetImage('assets/images/cod.jpg'),
              AssetImage('assets/images/great-deals.jpg'),
              AssetImage('assets/images/original-products.jpg'),
            ],
            autoplay: true,
            showIndicator: false,
            animationCurve: Curves.fastOutSlowIn,
            animationDuration: Duration(milliseconds: 1000),
            dotSize: 4.0,
            indicatorBgPadding: 1.0,
          ),
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/abs5.jpg'),
            fit: BoxFit.fill),
      ),
      child: Scaffold(
        // drawerScrimColor: Colors.white70,      ///The white shade effect during right swipe
        drawer: Drawer(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ///Header
              UserAccountsDrawerHeader(
                accountName: StreamBuilder<List<ApplicationUser>>(
                    stream: uid.fetchUserData(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Center(child: CircularProgressIndicator());      ///Fix for length.null error
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            var user = snapshot.data[index];
                            SizedBox(height: 5.0,);
                            return Text('Welcome ${user.name}',
                              style: GoogleFonts.poppins(fontSize: 19.5, fontWeight: FontWeight.w600),);
                          }
                      );
                    }
                ),
                accountEmail: FutureBuilder(
                  future: Provider.of<ProductService>(context).getCurrentUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text('${snapshot.data.email}',
                        style: GoogleFonts.poppins(fontSize: 17.0, color: Colors.white, fontWeight: FontWeight.w500),);
                    } else {
                      return Text('');
                    }
                  },
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                    image: AssetImage("assets/images/abs1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(
                height: 20.0,
              ),

              InkWell(
                child: ListTile(
                  title: Text(
                    'My Orders',
                    style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                  leading: Icon(Icons.shopping_bag_outlined, size: 40.0, color: Colors.deepPurple),
                ),
                onTap: () => Navigator.of(context).pushNamed('/myorders'),
              ),

              SizedBox(
                height: 10.0,
              ),

              InkWell(
                child: ListTile(
                  title: Text(
                    'Manage Address',
                    style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w500,),
                  ),
                  leading: Icon(Icons.home_outlined, size: 40.0, color: Colors.deepPurple),
                ),
                onTap: () => Navigator.of(context).pushNamed('/addresspage'),
              ),

              SizedBox(
                height: 10.0,
              ),

              InkWell(
                child: InkWell(
                  child: ListTile(
                    leading: Icon(Icons.shopping_cart_outlined, size: 40.0, color: Colors.deepPurple,),
                    title: Text(
                      'Shopping Cart',
                      style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                    trailing: Text('${cart.items.length}',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onTap: () => Navigator.of(context).pushNamed('/cart'),
                ),
                onTap: () {},
              ),

              SizedBox(
                height: 20.0,
              ),

              InkWell(
                child: ListTile(
                  title: Text(
                    'F A Q',
                    style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                  leading: Icon(Icons.help_outline_outlined, size: 40.0, color: Colors.deepPurple),
                ),
                onTap: () => Navigator.of(context).pushNamed('/faq'),
              ),

              SizedBox(
                height: 10.0,
              ),

              InkWell(
                child: ListTile(
                  title: Text(
                    'Logout',
                    style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                  leading: Icon(Icons.logout, size: 40.0, color: Colors.deepPurple,),
                ),
                onTap: () => authBloc.logout(),
              ),

              SizedBox(
                height: 60.0,
              ),

              Divider(color: Colors.indigo, thickness: 2.0,),

              ListTile(
                leading: Icon(Icons.email_outlined, size: 40.0, color: Colors.deepPurple,),
                title: Text(
                    'Contact Us',
                    style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w600),
                ),

              ),

              ListTile(
                title: Text(
                  'onpressed@gmail.com',
                  style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                // leading: Icon(Icons.email_outlined, size: 40.0, color: Colors.deepPurple,),
              ),
            ],
          ),
        ),
        ///=====App Bar Scaffold Starts===========
        appBar: AppBar(
          // backgroundColor: Colors.teal,
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                Text(
                  'The',
                  style: GoogleFonts.mcLaren(fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.cyanAccent),
                ),
                SizedBox(width: 8.0,),
                Text(
                  'BuyBuy',
                  style: GoogleFonts.mcLaren(fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.white),
                ),
                SizedBox(width: 8.0,),
                Text(
                  'Store',
                  style: GoogleFonts.mcLaren(fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.amberAccent),
                )
              ],
            ),
          ),
        ),

        ///Background Color / Image
        backgroundColor: Colors.transparent,

        body: ListView(
          children: <Widget>[
            SizedBox(height: 10.0,),
            ///carousel
            imageCarousel,
            SizedBox(
              height: 10.0,
            ),
            SingleChildScrollView(child: LandingCategoryTwo()),     ///Flexible
          ],
        ),
      ),
    );
  }
}
