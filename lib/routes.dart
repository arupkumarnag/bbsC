import 'package:flutter/material.dart';
import 'package:grocery_client_reboot/category-view-screens/ketchup_edit.dart';
import 'package:grocery_client_reboot/category-view-screens/rice_edit.dart';
import 'package:grocery_client_reboot/category-view-screens/salt_edit.dart';
import 'package:grocery_client_reboot/category-view-screens/spices_edit.dart';
import 'package:grocery_client_reboot/faq_section/faq.dart';
import 'package:grocery_client_reboot/screens/add_quantity/quantity_unit.dart';
import 'package:grocery_client_reboot/screens/cart_widget_screens/cart_screen_map.dart';
import 'package:grocery_client_reboot/screens/login.dart';
import 'package:grocery_client_reboot/screens/login.dart';
import 'package:grocery_client_reboot/screens/order_detail/order_details.dart';
import 'package:grocery_client_reboot/screens/product-landing.dart';
import 'package:grocery_client_reboot/screens/signup.dart';
import 'package:grocery_client_reboot/screens/signup.dart';
import 'package:grocery_client_reboot/screens/widgetscreens/address_screen.dart';
import 'package:grocery_client_reboot/screens/widgetscreens/my_orders.dart';
import 'package:grocery_client_reboot/screens/widgetscreens/user_data_edit.dart';
import 'category-view-screens/biscuit_edit.dart';
import 'category-view-screens/milk_edit.dart';
import 'category-view-screens/noodles_edit.dart';
import 'category-view-screens/tea_edit.dart';
import 'screens/signup.dart';
import 'screens/widgetscreens/checkout_screen.dart';


abstract class Routes {

  static MaterialPageRoute materialRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/signup":
        return MaterialPageRoute(builder: (context) => Signup());
      case "/login":
        return MaterialPageRoute(builder: (context) => Login());
      case "/landing":
        return MaterialPageRoute(builder: (context) => LandingPage());
      case "/biscuit":
        return MaterialPageRoute(builder: (context) => BiscuitPage());
      case "/ketchup":
        return MaterialPageRoute(builder: (context) => KetchupPage());
      case "/milk":
        return MaterialPageRoute(builder: (context) => MilkPage());
      case "/noodles":
        return MaterialPageRoute(builder: (context) => NoodlePage());
      case "/rice":
        return MaterialPageRoute(builder: (context) => RicePage());
      case "/chocolate":
        return MaterialPageRoute(builder: (context) => ChocolatePage());
      case "/spices":
        return MaterialPageRoute(builder: (context) => SpicesPage());
      case "/tea":
        return MaterialPageRoute(builder: (context) => TeaPage());
      case "/cart":
        return MaterialPageRoute(builder: (context) => CartScreen());
      case "/checkout":
        return MaterialPageRoute(builder: (context) => CheckoutScreen());
      case "/addresspage":
        return MaterialPageRoute(builder: (context) => SetAddress());
      case "/myorders":
        return MaterialPageRoute(builder: (context) => MyOrders());
      case "/order-details":
        return MaterialPageRoute(builder: (context) => OrderDetails());

      case "/faq":
        return MaterialPageRoute(builder: (context) => FAQSection());


        default:
          var routeArray = settings.name.split('/');
          if (settings.name.contains('/addresspage/')) {
            return MaterialPageRoute(builder: (context) => UserDataEdit(userId: routeArray[2],));
          }

          if (settings.name.contains('/quantityunit/')) {
            return MaterialPageRoute(builder: (context) => AddQtyUnitEdit(productId: routeArray[2],));
          }

          return MaterialPageRoute(builder: (context) => Login());
    }
  }
}