import 'package:flutter/material.dart';
import 'package:grocery_client_reboot/blocs/cart_bloc.dart';
import 'package:grocery_client_reboot/models/application_user.dart';
import 'package:grocery_client_reboot/models/category_loader_model.dart';
import 'package:grocery_client_reboot/models/orders_notifier/order_notifier.dart';
import 'package:grocery_client_reboot/models/product_model.dart';
import 'package:grocery_client_reboot/models/product_model.dart';
import 'package:grocery_client_reboot/routes.dart';
import 'package:grocery_client_reboot/routes.dart';
import 'package:grocery_client_reboot/screens/login.dart';
import 'package:grocery_client_reboot/screens/product-landing.dart';
import 'package:grocery_client_reboot/screens/product-landing.dart';
import 'package:grocery_client_reboot/services/firestore_service.dart';
import 'package:grocery_client_reboot/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'blocs/auth_bloc.dart';
import 'blocs/cart_bloc.dart';
import 'blocs/product_bloc.dart';
import 'models/application_user.dart';
import 'models/cart_model/cart.dart';
import 'models/category_loader_model.dart';
import 'models/orders_notifier/order_notifier.dart';
import 'models/product_model.dart';
import 'routes.dart';
import 'screens/login.dart';
import 'screens/product-landing.dart';
import 'services/firestore_service.dart';

///All of these will be available throughout the App

final authBloc = AuthBloc();
final productBloc = ProductBloc();
final productModel = ProductModel();
final service = ProductService();
final user = ApplicationUser();
final arrayCart = ArrayProduct();     
final cartBloc = CartBloc();

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (context) => authBloc),
          Provider(create: (context) => productBloc),
          Provider(create: (context) => productModel),
          Provider(create: (context) => arrayCart),
          Provider(create: (context) => service),
          Provider(create: (context) => user),
          Provider(create: (context) => cartBloc),
          FutureProvider(create: (context) => authBloc.isLoggedIn()),
          ChangeNotifierProvider.value(
              value: Products(),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProvider(
              create: (context) => OrderNotifier()
          ),
        ],
        child: PlatformApp());
  }

  @override
  void dispose() {
    authBloc.dispose();
    productBloc.dispose();
    super.dispose();
  }
}

class PlatformApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var isLoggedIn = Provider.of<bool>(context);

    return MaterialApp(
          home: (isLoggedIn == null) ? loadingScreen() : (isLoggedIn == true ) ? LandingPage() : Login(),
          onGenerateRoute: Routes.materialRoutes,
          theme: ThemeData(scaffoldBackgroundColor: Colors.white)
      );
    }



  Widget loadingScreen(){
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
