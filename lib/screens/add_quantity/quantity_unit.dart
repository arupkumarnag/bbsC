
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_client_reboot/app.dart';
import 'package:grocery_client_reboot/blocs/product_bloc.dart';
import 'package:grocery_client_reboot/models/cart_model/cart.dart';
import 'package:grocery_client_reboot/models/product_model.dart';
import 'package:grocery_client_reboot/services/firestore_service.dart';
import 'package:grocery_client_reboot/styles/base.dart';
import 'package:grocery_client_reboot/styles/colors.dart';
import 'package:grocery_client_reboot/styles/text.dart';
import 'package:provider/provider.dart';


class AddQtyUnitEdit extends StatefulWidget {
  final String productId;

  AddQtyUnitEdit({this.productId});

  @override
  _AddQtyUnitEditState createState() => _AddQtyUnitEditState();
}

class _AddQtyUnitEditState extends State<AddQtyUnitEdit> {
  int _currentQuantity = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var prodBloc = Provider.of<ProductBloc>(context);
    final uid = Provider.of<ProductService>(context);
    var array = Provider.of<ArrayProduct>(context);
    final cart = Provider.of<Cart>(context);

    return FutureBuilder<ProductModel>(
      future: prodBloc.fetchProduct(widget.productId),      ///Edit here- Watch
      builder: (context, snapshot) {
        if (!snapshot.hasData && widget.productId != null) {         ///Watch Here
          return Center(child: CircularProgressIndicator());
        }   

        ProductModel existingProduct;

        if (widget.productId != null) {
          existingProduct = snapshot.data;
        
        } else {
          existingProduct = snapshot.data;
        }


        return Container(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.teal,
              title: Center(child: Text('More Info', style: GoogleFonts.economica(fontSize: 35.0, fontWeight: FontWeight.bold))),
              actions: [
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
                              
                                      child: Center(
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
              
          body: ListView(
            children: <Widget>[
              SizedBox(height: 15.0,),
              Text(
                'Product Details',
                style: TextStyles.subtitle,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: BaseStyles.listPadding,
                child: Divider(color: AppColors.darkblue),
              ),

               StreamBuilder<String>(
                  stream: productBloc.imageUrl,
                  builder: (context, snapshot) {
                    if(existingProduct.imageUrl == null)
                      return Text('No Image');
                    return Column(
                      children: <Widget>[
                        Container(
                            height: 250.0,
                            width: 250.0,
                            child: Image.network(existingProduct.imageUrl)),
                      ],
                    );
                  }),

              Column(
                children: [
                  StreamBuilder<String>(
                      stream: productBloc.productName,
                      builder: (context, snapshot) {
                        return Text(existingProduct.productName, style: GoogleFonts.economica(
                            fontWeight: FontWeight.w600, fontSize: 40.0));
                      }),

                  SizedBox(height: 15.0,),
                  ///Shows Product Price
                  StreamBuilder<double>(
                      stream: productBloc.unitPrice,
                      builder: (context, snapshot) {
                        return Text('Price : ₹ ${existingProduct.unitPrice.toString()}', style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600, fontSize: 19.0));
                      }),

                  SizedBox(height: 10.0,),

                  StreamBuilder<String>(
                      stream: productBloc.productOffer,
                      builder: (context, snapshot) {
                        return Text(
                            existingProduct.productOffer != null ?
                            'Offer : ${existingProduct.productOffer}' : '', style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600, fontSize: 19.0));
                      }),
                  SizedBox(height: 5.0,),

                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      children: <Widget>[
                        Text('*Max Quantity Allowed per Customer is ', style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w800, fontSize: 15.0, color: Colors.black)),

                        StreamBuilder<int>(
                            stream: productBloc.availableUnits,
                            builder: (context, snapshot) {
                              return Text('${existingProduct.availableUnits}', style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.red));
                            }),

                        Text(' units. ', style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w800, fontSize: 15.0, color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 35.0,),

              Row(
                children: [
                  SizedBox(width: 0.0,),
                  Container(
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 25.0,),
                        Text('Select Quantity : ', style: GoogleFonts.poppins(
                            fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.teal),
                        ),
                        SizedBox(width: 25.0,),

                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.indigo,
                            ),
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            _currentQuantity >= 1 ?
                            setState(() {
                              ///Function
                              array.removeSingleArrayItem(
                                existingProduct.productName,
                              );
                              // print(array.cartArray.toString());

                              _currentQuantity -=1;
                            }) : _showQtyZero();
                            ///Removes One item qty from Map
                            cart.removeSingleItem(existingProduct.productId);
                          },
                        ),
                        SizedBox(width: 10),
                        Text(
                          "$_currentQuantity",
                          style: GoogleFonts.poppins(fontSize: 22.0, fontWeight: FontWeight.w500, color: Colors.teal),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.indigo,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                           _currentQuantity < existingProduct.availableUnits ?   ///<
                            setState(() {

                              ///Function
                              array.addArrayItem(existingProduct.productName,);

                              print(array.cartArray.toString());

                              _currentQuantity ++;    ///_currentAmount += 1;

                              cart.addItem(        
                                  existingProduct.productId, existingProduct.productName,
                                  existingProduct.unitPrice, existingProduct.imageUrl);
                            })
                            : _showQtyAlert();

                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0,)
            ],
           ),
          ),
        );       
      },
    );
  }

  ///If More than Available units Alert
  Future<void> _showQtyAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user may not tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black26,
          title: Center(child: Text('Alert !!', style: TextStyle(color: Colors.white),)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: Text('Maximum Quantity Exceeded',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
                )),
              ],
            ),
          ),


          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text('Okay', style: TextStyle(fontSize: 18.0, color: Colors.orange)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  ///If Qty is less than 1
  Future<void> _showQtyZero() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user may not tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black26,
          title: Center(child: Text('Alert !!', style: TextStyle(color: Colors.white),)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: Text('Minimum Quantity must be 1',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                )),
              ],
            ),
          ),


          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text('Okay', style: TextStyle(fontSize: 18.0, color: Colors.orange)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
