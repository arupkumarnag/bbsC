import 'package:grocery_client_reboot/models/user_model_model/cart_userdata.dart';
import 'package:grocery_client_reboot/services/firestore_service.dart';

class CartBloc {
  final db = ProductService();

  //Getter
  Stream<List<UserDataCart>> get fetchUpcomingMarkets => db.fetchUserDataForCart();
  


  dispose(){}
}