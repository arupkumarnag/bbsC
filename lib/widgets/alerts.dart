import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_client_reboot/styles/text.dart';

abstract class AppAlerts {

  // static Future<void> showErrorDialog(bool isIOS, BuildContext context, String errorMessage) async {
  static Future<void> showErrorDialog(BuildContext context,
      String errorMessage) async {
    // return (isIOS)
    // ? showCupertinoDialog(
    //   context: context,
    //   builder: (context){
    //     return CupertinoAlertDialog(
    //       title: Text('Error',style: TextStyles.subtitle,),
    //       content: SingleChildScrollView(
    //         child: ListBody(
    //           children: <Widget>[
    //             Text(errorMessage, style: TextStyles.body)
    //           ],
    //         ),
    //       ),
    //       actions: <Widget>[
    //         CupertinoButton(
    //           child: Text('Okay',style: TextStyles.body),
    //           onPressed: () => Navigator.of(context).pop(),
    //         )
    //       ],
    //     );
    //   }
    // )
    // :
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Oops !', style: GoogleFonts.poppins(
                fontSize: 30.0,
                fontWeight: FontWeight.w500,
                color: Colors.red),)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(errorMessage, style: TextStyles.body)
                ],
              ),
            ),
            actions: <Widget>[
              Center(
                child: FlatButton(
                  child: Text('Okay', style: GoogleFonts.poppins(fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent),),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            ],
          );
        }
    );
  }
}